require 'fog'


def config_dir
  File.expand_path(File.join(File.dirname(__FILE__),"../config/"))
end

def config_file
  File.join(config_dir,"fog.config")
end

def security_group_name
  'wise4-dev'
end

def ports
  [22,25,80,8080]
end

def make_group
  group = @connection.security_groups.get(security_group_name)
  unless group
    group = @connection.security_groups.new(
      :name => security_group_name,
      :description => 'ports required for wise4-development: 22,25,80,8080'
    )
    group.save
  end

  ports.each do |number|
    begin
      group.authorize_port_range(number..number)
    rescue # InvalidPermission.Duplicate
    end
  end
  return group
end

def running_servers
  @connection.servers.all.select { |s| s.state == "running" }
end

def servers_with_tag(tag,value)
  running_servers.select { |s| s.tags[tag] == value }
end

def servers_running_wise
  servers_with_tag('Name','wise_ec2')
end

def list_servers_running_wise
  servers = servers_running_wise
  servers.table([:id, :flavor_id, :public_ip_address, :image_id])
  puts servers.inspect
end

def connect_to_server
  server = servers_running_wise.first
  puts server.ssh('ls -la').inspect
end

def create_server
  key_name = Fog.credentials[:key_name]
  user = ENV['USER'] || env['USERNAME'] || 'unknown'
  @server = @connection.servers.create( 
    # :image_id => 'ami-245fac4d', 
    :image_id => 'ami-079e5d6e',
    :user_name => 'ubuntu', 
    :key_name => key_name, 
    :groups => [security_group_name], 
    :tags => { 
      :created_by  => "cloud_setup", 
      :remote_user => user, 
      :Name => "wise_ec2" 
  })
  @server.wait_for(60 * 60 * 5, 100) { ready? } # give server time to boot

  @server.destroy # cleanup after yourself or regret it, trust med
end


Fog.credentials_path = config_file


@connection = Fog::Compute.new(:provider => 'AWS')
group = make_group

connect_to_server
# create_server
# terminate_running_wise


