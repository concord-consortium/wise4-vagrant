$:.push(File.dirname(__FILE__),'lib')
require 'cloud_helper'

class Cloud < Thor
  desc "list", "list existing servers"
  def list
    helper = CloudHelper.new
    helper.list_servers
  end

  desc "new", "create a new server"
  def new
    helper = CloudHelper.new
    helper.create_server
  end

  desc "provision [id]", "provision an existing server"
  def provision(id)
    helper = CloudHelper.new
    helper.provision(id)
  end

  desc "stop", "stop all servers"
  def stop
    helper = CloudHelper.new
    helper.terminate_all
  end

  desc "ssh [id]", "ssh to the machine with [id]"
  def ssh(id)
    helper = CloudHelper.new
    helper.open_ssh(id)
  end

  desc "state [id][state]", "manually set the [state] for machine [id]"
  def state(id,state)
    helper = CloudHelper.new
    helper.set_state(id,state)
  end

end

