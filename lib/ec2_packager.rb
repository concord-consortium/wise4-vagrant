#!/usr/bin/env ruby
#Make a tarball of only the recipes called in dna.json
#Takes as an argument the path to a Vagrant VM's folder.
require 'rubygems'
require 'json'

class EC2Packager

  def initialize(_path=".")
    @vagrant_root = File.expand_path(_path)
    @recipe_list_file = ".recipe_list"
    self.generate_dna_files
  end

  def cookbook_archive_file
    File.join(@vagrant_root,'cookbooks.tgz')
  end

  def dna_file
    File.join(@vagrant_root,'dna.json')
  end

  def create_tarfile
    self.write_recipe_list_file()
    cd do
      tar_command = "tar czf #{cookbook_archive_file} --files-from #{@recipe_list_file} 2> /dev/null"
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
      @cookbook_paths = [JSON.parse(open('.cookbooks_path.json').read)].flatten
      @recipe_names = JSON.parse(open(dna_file).read)["run_list"]
      @recipe_names.map! { |file_name|
        file_name.gsub('recipe', '').gsub(/(\[|\])/, '').gsub(/::.*$/, '')
      }
      @recipe_names.uniq!
    end
  end

  def write_recipe_list_file
    cd do
      open(@recipe_list_file, 'w') do |f|
        f.puts @recipe_names.map{ |x|
          paths = @cookbook_paths.map do|cookbook_path|
            "#{cookbook_path}/#{x}"
          end

          # strip full paths to relative file paths:
          paths.map! { |path| path.gsub(@vagrant_root,'').gsub(/^\//,"") }
          paths.reject!{|path| not File.exists?(path)}
          if paths.length > 1
            raise "Multiple cookbooks '#{x}' exist within `chef.cookbooks_path`; I'm not sure which one to use"
          end
          if 0 == paths.length
            raise "I can't find any recipes for '#{x}'"
          end
          paths[0]
        }
      end
    end
  end

  def cd
    Dir.chdir @vagrant_root do
      yield
    end
  end

end

