# this from the instructions here: http://code.google.com/p/wise4/wiki/StableWISEDeploymentModel

# Create the vagrant user

user "vagrant" do
  comment "vagrant user for vagrant/ec2 deploy convergence."
  shell "/bin/bash"
  home "/home/vagrant/"
  # supports :manage_home => false
end

# create vagrants home directory unless it exists already:
directory "/home/vagrant" do
   mode 0775
   owner "vagrant"
   group "vagrant"
   action :create
   recursive true
end


# Item 1
include_recipe "apt"
include_recipe "mysql::server"
include_recipe "tomcat"
include_recipe "ant"
include_recipe "maven"
include_recipe "subversion"
include_recipe "emacs"
include_recipe "vim"
include_recipe "git"

script "set locale and timezone" do
  interpreter "bash"
  user "root"
  code <<-EOH
  locale-gen en_US.UTF-8
  /usr/sbin/update-locale LANG=en_US.UTF-8
  cp /usr/share/zoneinfo/right/America/New_York /etc/localtime
  EOH
end

# Item 2
template "/etc/tomcat6/context.xml" do
  source "context.xml.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# Item 3 is specified in Vagrant file 

WEBAPPS_PATH = "/var/lib/tomcat6/webapps"

# Item 4
# this assumes the default CATALAINA_BASE location
%w{curriculum studentuploads}.each do |dir|
  directory "#{WEBAPPS_PATH}/#{dir}" do
     mode 0775
     owner "tomcat6"
     group "tomcat6"
     action :create
     recursive true
  end
end

# create a directory for the wise4 source checkouts
WISE4_SRC_PATH = "/home/vagrant/src"
directory WISE4_SRC_PATH do
   mode 0775
   owner "vagrant"
   group "vagrant"
   action :create
   recursive true
end


if (node["build_wise_from_source"])
    git "WISE4 sailportal:trunk:portal" do
    repository "git://github.com/concord-consortium/WISE-Portal.git"
    reference "master"
    destination "#{WISE4_SRC_PATH}/portal"
    user "vagrant"
    group "vagrant"
    action :sync
  end

  git "WISE4 sail-web:trunk:vlewrapper" do
    repository "https://github.com/WISE-Community/WISE-VLE.git"
    reference "master"
    destination "#{WISE4_SRC_PATH}/vlewrapper"
    user "vagrant"
    group "vagrant"
    action :sync
  end

  build_webapps = {'portal' => 'webapp', 'vlewrapper' => 'vlewrapper'}
  build_webapps.each do |dir, war_name|

    script "build #{dir}:#{war_name}.war with maven and install" do
      interpreter "bash"
      user "vagrant"
      cwd "#{WISE4_SRC_PATH}/#{dir}"
      code "mvn -Dmaven.test.skip=true package"
    end

    script "install war file for #{war_name}" do
      interpreter "bash"
      user "tomcat6"
      code "cp #{WISE4_SRC_PATH}/#{dir}/target/#{war_name}.war #{WEBAPPS_PATH}"
    end
  end
else  #for a binary build:
  puts "Using binary build of WISE4 unset BUILD_WISE_FROM_SOURCE in your environment to build from source"
  # unfortunately, its often much easier just to do this:
  downloaded_webapps = {'webapp' => '4.5', 'vlewrapper' => '4.5'}
  downloaded_webapps.each do |base, suffix|
    remote_file "/var/lib/tomcat6/webapps/#{base}.war" do
      owner "tomcat6"
      source "http://wise4.org/downloads/software/stable/#{base}-#{suffix}.war"
      mode "0644"
      notifies :restart, resources(:service => "tomcat")
      # check if each of the app folders exists when they are unpacked these folders are created
      not_if { File.directory? "/var/lib/tomcat6/webapps/#{base}" }
    end
  end

end

cookbook_file "/home/vagrant/src/update-wise4.sh" do
  source "update-wise4.sh"
  owner "vagrant"
  group "vagrant"
  mode "0755"
end


# Item 6
# need to force a catalina restart so the wars get exploded
service "tomcat" do
  action :restart
end

# Item 7
service "tomcat" do
  action :stop
end

# Item 8
template "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/portal.properties" do
  source "portal.properties.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# also a copy for the update-wise4.sh script
template "/home/vagrant/portal.properties" do
  source "portal.properties.erb"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end

# Item 9
execute "create wise4user user" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"CREATE USER 'wise4user'@'localhost' identified by 'wise4pass'\""
  only_if { `/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -D mysql -r -B -N -e "SELECT COUNT(*) FROM user where User='wise4user' and Host = 'localhost'"`.to_i == 0 }
end

execute "create application_production databases" do
  not_if { File.exists? '/home/vagrant/made_databases'}
  sql= <<-SQL
    drop database if exists sail_database;
    create database sail_database;
    grant all privileges on sail_database.* to 'wise4user'@'localhost' identified by 'wise4pass';
    drop database if exists vle_database;
    create database vle_database;
    grant all privileges on vle_database.* to 'wise4user'@'localhost' identified by 'wise4pass';
    flush privileges;
  SQL
  # using commandline here instead of mysql recipe because that doesn't support for queries outside of databases
  command "mysql -u root -p#{node[:mysql][:server_root_password]} -e\"#{sql}\" && touch /home/vagrant/made_databases"
  creates "/home/vagrant/made_databases"
end

# Item 10
# don't need to do anything because the defaults work

# Item 11
execute "create-sail_database-schemas" do
  not_if { File.exists? '/home/vagrant/made_sail_schema'}
  cwd "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/tels"
  command "mysql sail_database -u root -p#{node[:mysql][:server_root_password]} < wise4-createtables.sql && touch /home/vagrant/made_sail_schema"
  creates "/home/vagrant/made_sail_schema"
end

# Item 12
execute "insert-default-values-into-sail_database" do
  not_if { File.exists? '/home/vagrant/made_sail_data'}
  cwd "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/tels"
  command "mysql sail_database -u root -p#{node[:mysql][:server_root_password]} < wise4-initial-data.sql  && touch /home/vagrant/made_sail_data"
  creates "/home/vagrant/made_sail_data"
end

# Item 13 happens automatically with the notifies restart lines above
