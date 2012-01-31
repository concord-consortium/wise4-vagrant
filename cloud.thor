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

  desc "stop", "stop all servers"
  def stop
    helper = CloudHelper.new
    helper.terminate_all
  end
end

