WEBAPPS_PATH = "/var/lib/tomcat6/webapps"
WISE4_SRC_PATH = "/home/vagrant/src"

directory WISE4_SRC_PATH do
   mode 0775
   owner "vagrant"
   group "vagrant"
   action :create
   recursive true
end

subversion "WISE4 sailportal:trunk:portal" do
  repository "http://sailportal.googlecode.com/svn/trunk/portal"
  revision "HEAD"
  destination "#{WISE4_SRC_PATH}/portal"
  user "vagrant"
  group "vagrant"
  action :sync
end

subversion "WISE4 sail-web:trunk:vlewrapper" do
  repository "http://sail-web.googlecode.com/svn/trunk/vlewrapper"
  revision "HEAD"
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
    code <<-EOH
    cd #{WISE4_SRC_PATH}/#{dir}
    mvn -Dmaven.test.skip=true package
    sudo cp target/#{war_name}.war #{WEBAPPS_PATH}
    EOH
  end
  # ruby_block "build #{dir}:#{war_name}.war with maven and install" do
  #   block do
  #     Dir.chdir "#{WISE4_SRC_PATH}/#{dir}" do
  #       if system("mvn -Dmaven.test.skip=true package")
  #         system("cp target/#{war_name}.war #{WEBAPPS_PATH}")
  #       else
  #         raise "Error building WISE4 #{dir}:#{war_name}.war"
  #       end
  #     end
  #   end
  # end
end

script "restart tomcat" do
  interpreter "bash"
  user "root"
  code <<-EOH
  cd #{WISE4_SRC_PATH}
  EOH
end

template "#{WEBAPPS_PATH}/vlewrapper/vle/node/setupNodes.js" do
  source "setupNodes.js.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
end
