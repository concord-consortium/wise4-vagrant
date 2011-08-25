template "/var/lib/tomcat6/webapps/vlewrapper/vle/node/setupNodes.js" do
  source "setupNodes.js.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
end

template "/home/vagrant/reset_wise4_databases.rb" do
  source "reset_wise4_databases.rb.erb"
  owner "vagrant"
  group "vagrant"
  mode "0755"
end
