#!/usr/bin/env ruby
#Make a tarball of only the recipes called in dna.json
#Takes as an argument the path to a Vagrant VM's folder.
require 'rubygems'
require 'json'

class EC2Packager

  def initialize(_path=".")
    @vagrant_root = File.expand_path(_path)
    self.generate_dna_files
  end

  def cookbook_directory
    File.join(@vagrant_root,"cookbooks")
  end

  def cookbook_archive_file
    "#{cookbook_directory}.tgz"
  end

  def dna_file
    File.join(@vagrant_root,'dna.json')
  end

  def cookbooks_json_path
    File.join(@vagrant_root, '.cookbooks_path.json')
  end

  def create_tarfile
    cd do
      # hack to make tarfile use relative paths ..
      dir = cookbook_directory.gsub(@vagrant_root,'').gsub(/^\//,'')
      tar_command = "tar czf #{cookbook_archive_file} #{dir} 2> /dev/null"
      %x[#{tar_command}]
    end
  end

  protected
  # First modify the VagrantFile according to instructions here: https://github.com/lynaghk/vagrant-ec2
  # use the Vagrant file to configure cookbooks
  def generate_dna_files
    cd do
      # run vagrant to parse the `Vagrantfile` and write out `dna.json` and `.cookbooks_path.json`.
      results = %x[vagrant]
      if $?.exitstatus != 0
        puts "failed to run vagrant: #{results}"
        exit 1
      end
      @cookbook_paths = [JSON.parse(open(cookbooks_json_path).read)].flatten
      @recipe_names = JSON.parse(open(dna_file).read)["run_list"]
      @recipe_names.map! { |file_name|
        file_name.gsub('recipe', '').gsub(/(\[|\])/, '').gsub(/::.*$/, '')
      }
      @recipe_names.uniq!
    end
  end

  def cd
    Dir.chdir @vagrant_root do
      yield
    end
  end

end

