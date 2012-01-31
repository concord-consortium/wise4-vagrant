require 'fog'

config_dir = File.expand_path(File.join(File.dirname(__FILE__),"../config/"))
config_file = File.join(config_dir,"fog.config")

Fog.credentials_path = config_file
@connection = Fog::Compute.new(:provider => 'AWS')

@server = @connection.servers.create(:image_id => 'ami-245fac4d')
