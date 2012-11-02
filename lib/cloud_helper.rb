require 'fog'
require 'yaml'
require 'ec2_packager'

class CloudHelper

  DefaultGroupName='wise4-dev'
  DefaultPorts    = [22,25,80,8080]
  DefaultUser     = 'ubuntu'
  DefaultAmiImage = 'ami-57588e3e'
  DefaultName     = 'wise_ec2'
  DefaultTimeout  = 1000 * 60 * 10   # 5 minutes
  StateFile       = '/tmp/cloud_state'

  # Taken from config/bootrap.sh
  CHEF_COOKBOOK_PATH   = "/tmp/cheftime/cookbooks"
  CHEF_FILE_CACHE_PATH = "/tmp/cheftime"
  
  # TODO: WISE image specific
  VLE_NODE_DIR='/var/lib/tomcat6/webapps/vlewrapper/vle/node/'


  def initialize(configuration_file=CloudHelper.config_file)
    #TODO: we need a way to specify vagrant root better...
    @vagrant_root = File.join(Dir.pwd(),'rebuild')
    @config = YAML::load(File.open(configuration_file))
    Fog.credentials_path = CloudHelper.config_file("credentials.config")
    @connection = Fog::Compute.new(:provider => 'AWS')

    if File.exists?(CloudHelper.wise4_step_types_path)
      @wise4_step_types = YAML.load_file(CloudHelper.wise4_step_types_path)
    else
      @wise4_step_types = {}
    end
  end

  # opens an interactive ssh console
  def open_ssh(id=@connection.servers.first)
    command = ssh_cli_string(id)
    exec(command)
  end

  def list_servers
    # running_servers.table([:id, :flavor_id, :public_ip_address, :image_id])
    _format = "%12.11s %12.11s %17.16s %12.11s %60.60s"
    puts sprintf _format,
        "instance id",
        "state",
        "public IP",
        "AMI",
        "ssh commandline"
    running_servers.each do |server|
      ssh_cli_string = ssh_cli_string(server.id)
      puts sprintf _format,
          server.id,
          state(server),
          server.public_ip_address,
          server.image_id,
          ssh_cli_string
    end
  end

  def create_server
    key_name = Fog.credentials[:key_name]
    user = ENV['USER'] || env['USERNAME'] || 'unknown'
    check_keys()

    #TODO: This is weird place to create a security group
    group = make_group
    server = @connection.servers.bootstrap(
      # :image_id => 'ami-245fac4d',
      :image_id   => self.ami_image,
      :user_name  => self.login_user,
      :username   => self.login_user,
      :key_name   => self.key_name,
      :private_key_path => self.key_path,
      :flavor_id  => 'm1.small',
      :groups     => [self.security_group_name],
      :user_data  => self.boot_data,
      :tags => {
        :created_by  => "cloud_setup",
        :remote_user => user,
        :Name => "wise_ec2"
    })
    state(server, "bootstrap")
    provision(server)
  end

  def provision(server=@connection.servers.first)
    if server.kind_of? String
      server = @connection.servers.get(server)
    end
    copy_chef_files(server)
    run_chef(server)
    state(server, "complete")
  end

  def set_state(id,state)
    server = @connection.servers.get(id)
    state(server,state)
  end

  def terminate(id)
    server = @connection.servers.get(id)
    server.destroy
  end

  def rsync(id)
    ssh_cmd = ssh_cli_string(id)
    puts "synching wise 4 steps #{@wise4_step_types.inspect}"
    @wise4_step_types.each{ |name, dir |
      remote_path = "#{VLE_NODE_DIR}#{File.basename(dir)}"
      puts "remote path: #{remote_path}"
      puts "local path : #{dir}"
      server = @connection.servers.get(id)
      # make sure vagrant can write to the file.
      self.sudo server, "mkdir -p #{remote_path}"
      self.sudo server, "chown -R #{self.login_user} #{remote_path}"
      rsync_cmd = %[rsync -rtzPu -e "ssh -i #{self.key_path}" #{dir} #{self.login_user}@#{server.public_ip_address}:#{File.dirname(remote_path)}]
      puts "command: #{rsync_cmd}"
      results = %x[#{rsync_cmd}]
      puts "results: #{results}"
    }
  end

  def terminate_all
    running_servers.each do |server|
      server.destroy
    end
  end

  protected

  def self.dir
    File.dirname(__FILE__)
  end

  def self.config_dir
    File.expand_path(File.join(self.dir,"../config/"))
  end

  def self.wise4_step_types_path
      File.expand_path(File.join(self.dir,'../wise4-step-types.yml'))
  end

  def self.config_file(filename="cloud.config")
    File.join(self.config_dir,filename)
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
    servers.select { |s| s.key_name == self.key_name }
  end

  def servers_with_tag(tag,value)
    @connection.servers.all.select { |s| s.tags[tag] == value }
  end

  # returns the ssh string to connect to the host
  def ssh_cli_string(id)
    server = @connection.servers.get(id)
    "ssh -i #{self.key_path} #{self.login_user}@#{server.public_ip_address}"
  end


  def boot_data
    @boot_data ||= File.open(CloudHelper.config_file("bootstrap.sh")).read()
  end

  def copy_chef_files(server)
    packager = EC2Packager.new(@vagrant_root)
    packager.create_tarfile
    server.scp(packager.cookbook_archive_file,".")
    server.scp(packager.dna_file,".")
    state(server,"files-copied")
  end

  def ssh(server, command)
    results = server.ssh(command).first
    if results.status != 0
      puts "Error: STDERR: #{results.stderr}"
      puts "Error: STDOUT: #{results.stdout}"
    end
    results.stdout.chomp
  end

  def sudo(server, command)
    ssh server, "sudo sh -c '#{command}'"
  end

  def wait_for_command(server, command, regex, interval=4,timeout_sec=240)
    timeout = Time.now + timeout_sec
    not_found = true
    while not_found
      sleep interval
      found = ssh(server,command)
      if found =~ regex
        not_found = false
      end
      if timeout < Time.now
        state(server, 'error')
        raise RuntimeError, 'unable to find chef-solo'
      end
    end
  end

  def run_chef(server=@connection.servers.first)

    state(server, 'wating for chef-solo')
    wait_for_command(server, 'which chef-solo', /bin/)
    state(server, "chef_start")
    # TODO: chef-solor the correct way.
    chef_solo = "/var/lib/gems/1.8/bin/chef-solo"
    sudo server, "cd #{CHEF_FILE_CACHE_PATH} && cp -r /home/#{self.login_user}/cookbooks.tgz ."
    sudo server, "cd #{CHEF_FILE_CACHE_PATH} && cp -r /home/#{self.login_user}/dna.json ."
    sudo server, "cd #{CHEF_FILE_CACHE_PATH} && #{chef_solo} -c solo.rb -j dna.json -r cookbooks.tgz"
    state(server, "chef_done")
  end

  def state(server,state=nil)
    return "waiting" unless server.ready?
    if state
      puts state
      results = server.ssh("echo #{state} > #{StateFile}")
    else
      results = server.ssh("cat #{StateFile}")
    end
    if results && results.size > 0
      if results.first.status == 0
        return results.first.stdout.chomp
      else
        return "error"
      end
    else
      return "unkown"
    end
  end


  def check_keys
    filename = self.key_path
    unless File.exist?(filename)
      keypair = @connection.key_pairs.get(self.key_name)
      if keypair
        puts "found keypair: #{keypair.name}"
      else
        keypair = @connection.key_pairs.create(:name => self.key_name)
      end
      puts "creating new key in #{self.key_path}"
      keypair.write(self.key_path)
    end
  end
end
