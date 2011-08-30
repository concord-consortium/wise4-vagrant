WEBAPPS_PATH = "/var/lib/tomcat6/webapps"
STEP_SOURCE='/var/lib/wise4/steps/'
directory "#{STEP_SOURCE}" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
  recursive true
end

template "#{WEBAPPS_PATH}/vlewrapper/vle/node/setupNodes.js" do
  source "setupNodes.js.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
end

cookbook_file "/home/vagrant/src/update-wise4.sh" do
  source "update-wise4.sh"
  owner "vagrant"
  group "vagrant"
  mode "0755"
end

template "/home/vagrant/reset_wise4_databases.rb" do
  source "reset_wise4_databases.rb.erb"
  owner "vagrant"
  group "vagrant"
  mode "0755"
end

template "/home/vagrant/portal.properties" do
  source "portal.properties.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
end
