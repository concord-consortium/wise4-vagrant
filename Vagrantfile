require 'yaml'

wise4_step_types_path = File.expand_path('../wise4-step-types.yml', __FILE__)

if File.exists?(wise4_step_types_path)
  wise4_step_types = YAML.load_file(wise4_step_types_path)
else
  wise4_step_types = {}
end

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "wise4-4_3-2"
  
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://mysystem.dev.concord.org/wise4/wise4-4_3-2.box"

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # NOTE: this port 8080 is hard coded into some of the wise4 settings files
  #   so changing it might break somethings. 
  config.vm.forward_port "http", 8080, 8080

  wise4_step_types.each{ |name, dir|
    config.vm.share_folder(name.downcase, "/var/lib/tomcat6/webapps/vlewrapper/vle/node/#{name.downcase}", dir)
  }

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"

    # Tell chef what recipe to run. In this case, the `vagrant_main` recipe
    # does all the magic.
    chef.add_recipe("vagrant_main")

    # Customize recipes
    chef.json.merge!({ 
      :wise4 => { :step_types => wise4_step_types.keys }
    })
  end

end
