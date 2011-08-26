require 'rubygems'

vagrant_identity_path = File.join(Gem::Specification.find_by_name('vagrant').gem_dir, 'files', 'vagrant')

puts <<-HEREDOC

After installing the vagrant gem and creating a running vagrant instance add a named local host
associating the IP address used for the vagrant instance with an appropriate name.

Example:

  $ sudo echo '33.33.33.10    vagrant1.local' > /etc/hosts

Then add the following three lines to the end of your ~/.ssh/config

Host vagrant1.local
User vagrant
IdentityFile #{vagrant_identity_path}

Example:

  $ echo '
  Host vagrant1.local
  User vagrant
  IdentityFile #{vagrant_identity_path}
  ' >> ~/.ssh/config

Now you can use ssh to connect and run remote commands on the vagrant box from anywhere on your system:

Example:

  $ ssh vagrant1.local 'ls -l'
  total 16
  -rw-r--r-- 1 tomcat6 tomcat6 3312 2011-08-26 11:36 portal.properties
  -rw-r--r-- 1 vagrant vagrant 3475 2011-07-21 15:32 postinstall.sh
  -rwxr-xr-x 1 vagrant vagrant  897 2011-08-26 11:42 reset_wise4_databases.rb
  drwxrwxr-x 4 vagrant vagrant 4096 2011-08-26 11:42 src

HEREDOC
