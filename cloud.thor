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

  desc "provision (id)", "provision an existing server"
  def provision(id=nil)
    helper = CloudHelper.new
    if id
      helper.provision(id)
    else
      helper.provision()
    end
  end

  desc "stop (id)", "stop all servers"
  def stop(id=nil)
    helper = CloudHelper.new
    if id
      helper.trerminate(id)
    else
      helper.terminate_all
    end
  end

  desc "ssh (id)", "ssh to the machine with [id]"
  def ssh(id=nil)
    helper = CloudHelper.new
    if id
      helper.open_ssh(id)
    else
      helper.open_ssh(id)
    end 
  end

  desc "state [id][state]", "manually set the [state] for machine [id]"
  def state(id,state)
    helper = CloudHelper.new
    helper.set_state(id,state)
  end

end

