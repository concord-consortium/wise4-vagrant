WEBAPPS_PATH = "/var/lib/tomcat6/webapps"

template "#{WEBAPPS_PATH}/vlewrapper/vle/node/setupNodes.js" do
  source "setupNodes.js.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
end
