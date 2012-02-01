require 'fog'
require 'yaml'

class CloudHelper

  DefaultGroupName='wise4-dev'
  DefaultPorts    = [22,25,80,8080]
  DefaultUser     = 'ubuntu'
  DefaultAmiImage = 'ami-57588e3e'
  DefaultName     = 'wise_ec2'

  def self.config_dir
    File.expand_path(File.join(File.dirname(__FILE__),"../config/"))
  end

  def self.config_file(filename="cloud.config")
    File.join(self.config_dir,filename)
  end

  def initialize(configuration_file=CloudHelper.config_file)
    @config = YAML::load(File.open(configuration_file))
    Fog.credentials_path = CloudHelper.config_file("credentials.config")
    @connection = Fog::Compute.new(:provider => 'AWS')
  end

  def security_group_name
    @config['group_name'] ||= self.class::DefaultGroupName
  end

  def ports
    @config['ports']      ||= self.class::DefaultPorts
  end

  def login_user
    @config['login_user'] ||= self.class::DefaultUser
  end

  def ami_image
    @config['ami_image']  ||= self.class::DefaultAmiImage
  end

  def instance_name
    @config['instance_name'] ||= self.class::DefaultName
  end

  def key_name
    Fog.credentials[:key_name]
  end

  def key_path
    Fog.credentials[:private_key_path]
  end

  def make_group
    group = @connection.security_groups.get(security_group_name)
    unless group
      group = @connection.security_groups.new(
        :name        => self.security_group_name,
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
    servers = @connection.servers.all.select { |s| s.state == "running" }
    servers.select { |s| s.tags['Name'] == self.instance_name }
  end

  def servers_with_tag(tag,value)
    @connection.servers.all.select { |s| s.tags[tag] == value }
  end

  # returns the ssh string to connect to the host
  def ssh_command(id)
    server = @connection.servers.get(id)
    "ssh -i #{self.key_path} #{self.login_user}@#{server.public_ip_address}"
  end
  
  # opens an interactive ssh console
  def open_ssh(id)
    command = ssh_command(id)
    exec (command)
  end

  def list_servers
    # running_servers.table([:id, :flavor_id, :public_ip_address, :image_id])
    puts sprintf "%12.11s %12.11s %17.16s %12.11s %60.60s",
        "instance id",
        "flavor id",
        "public IP",
        "AIM",
        "ssh commandline"
    running_servers.each do |server|
      ssh_command = ssh_command(server.id)
      puts sprintf "%12.11s %12.11s %17.16s %12.11s %60.60s",
          server.id,
          server.flavor_id,
          server.public_ip_address,
          server.image_id,
          ssh_command
    end
  end

  def create_server
    key_name = Fog.credentials[:key_name]
    user = ENV['USER'] || env['USERNAME'] || 'unknown'

    #TODO: This is weird place to create a security group
    group = make_group
    server = @connection.servers.create(
      # :image_id => 'ami-245fac4d',
      :image_id   => self.ami_image,
      :user_name  => self.login_user,
      :key_name   => self.key_name,
      :flavor_id  => 'm1.small',
      :groups     => [self.security_group_name],
      :tags => {
        :created_by  => "cloud_setup",
        :remote_user => user,
        :Name => "wise_ec2"
    })
  end

  def terminate_all
    running_servers.each do |server|
      server.destroy
    end
  end

end
