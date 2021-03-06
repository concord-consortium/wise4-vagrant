# this from the instructions here: http://code.google.com/p/wise4/wiki/StableWISEDeploymentModel

# Item 1 
include_recipe "apt"
include_recipe "mysql::server"
include_recipe "tomcat"

# Item 2
template "/etc/tomcat6/context.xml" do
  source "context.xml.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# Item 3 is specified in Vagrant file 

# Item 4
# this assumes the default CATALAINA_BASE location
%w{curriculum studentuploads}.each do |dir|
  directory "/var/lib/tomcat6/webapps/#{dir}" do
     mode 0775
     owner "tomcat6"
     group "tomcat6"
     action :create
     recursive true
  end
end

# Item 5
webapps = {'webapp' => '-4.3', 'vlewrapper' => '-4.3', 'jnlp' => ''}
webapps.each do |base, suffix|
  remote_file "/var/lib/tomcat6/webapps/#{base}.war" do
    source "http://wise4.org/downloads/software/#{base}#{suffix}.war"
    mode "0644"
    notifies :restart, resources(:service => "tomcat")
    # check if each of the app folders exists when they are unpacked these folders are created
    not_if { File.directory? "/var/lib/tomcat6/webapps/#{base}" }
  end
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

# Item 9
execute "create wise4user user" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"CREATE USER 'wise4user'@'localhost' identified by 'wise4pass'\""
  only_if { `/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -D mysql -r -B -N -e "SELECT COUNT(*) FROM user where User='wise4user' and Host = 'localhost'"`.to_i == 0 }
end
execute "create application_production databases" do
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
  command "mysql -u root -p#{node[:mysql][:server_root_password]} -e\"#{sql}\""
end

# Item 10
# don't need to do anything because the defaults work

# Item 11
execute "create-sail_database-schemas" do
  cwd "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/tels"
  command "mysql sail_database -u root -p#{node[:mysql][:server_root_password]} < wise4-createtables.sql"
end

# Item 12
execute "insert-default-values-into-sail_database" do
  cwd "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/tels"
  command "mysql sail_database -u root -p#{node[:mysql][:server_root_password]} < wise4-initial-data.sql"
end

# Item 13 happens automatically with the notifies restart lines above
