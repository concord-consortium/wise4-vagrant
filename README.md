This project uses Vagrant to setup a wise4 virtual machine.

## Prerequisites

- ruby - on OS X this is already installed
- git
- vagrant - run "sudo gem install vagrant" (rvm users: normally you will not use sudo)
- virtualbox 4.1 - http://www.virtualbox.org/wiki/Downloads

# Get Started

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant
    vagrant up # this will take some time as it downloads a 636mb file
    open http://localhost:8080/webapp/index.html

When you are done using it and want to save disk space run:

    $ vagrant destroy

This command deletes all the data from the virtual machine. If you have updated to the wise4 codebase you will lose these changes but they can be easily restored by running this script on the wise4-trunk vm: /home/vagrant//src/update-wise4.sh.

Running vagrant destroy does not delete the wise4-trunk base box initially downloaded.

Then to use it again just do

    vagrant up

If you want to get into the VM and check it out

    vagrant ssh

For more details see http://vagrantup.com
 
To use the wise4-trunk vm again after halting or destroying just run:

    $ vagrant up

To update to the latest version of wise4 ssh into the vagrant box and run the ./src/update-wise4.sh script which updates the wise4 portal and vlewrapper projects from subversion, builds them with maven and ant and deploys them to tomcat:

    $ vagrant ssh
    vagrant@lucid32:~$ ./src/update-wise4.sh
    vagrant@lucid32:~$ exit

Then open the wise4 web page:

    $ open http://localhost:8080/webapp/index.html

## Connecting to a running vagrant box with SSH

If you want to get into the VM and work directly with the wise4 instance or the services it depends on the vagrant instance need to be running and then from within the same directory run: `vagrant ssh`.

It can be very useful to be able to use ssh to run remote commands on a vagrant box. The ssh invocation looks like this

    $ ssh -l vagrant <VAGRANT-IP-ADDR>  -i <VAGRANT-IDENTITY-FILE> '<COMMAND>'

The `VAGRANT-IDENTITY-FILE` is located in the path to the vagrant Ruby Gem itself and can be displayed by executing the following Ruby command:

    ruby -e "puts File.join(Gem::Specification.find_by_name('vagrant').gem_dir, 'files', 'vagrant')"
    
The `VAGRANT-IP-ADDR` is configured when the base box is created in this file: `rebuild/Vagrantfile` and is normally 33.33.33.10.

In order to use ssh to more easily run remote commands on the vagrant instance add a named local host
associating the IP address used for the vagrant instance with an appropriate name and add a custom ssh comfiguration for this host.

**Creating a local host named 'vagrant1.local' for the Vagrant instance using the IP address 33.33.33.10 and adding a custom ssh configuration for connecting to the vagrant box**

Run the Ruby script: `vagrant-ssh-config.rb` in this directory and follow the directions:

Here's an example of it's output:

    $ ruby vagrant-ssh-config.rb 

    After installing the vagrant gem and creating a running vagrant instance add a named local host
    associating the IP address used for the vagrant instance with an appropriate name.

    Example:

      $ sudo echo '33.33.33.10    vagrant1.local' > /etc/hosts

    Then add the following three lines to the end of your ~/.ssh/config

    Host vagrant1.local
    User vagrant
    IdentityFile /Users/stephen/.rvm/gems/ruby-1.9.2-p290/gems/vagrant-0.8.2/files/vagrant

    Example:

      $ echo '
      Host vagrant1.local
      User vagrant
      IdentityFile /Users/stephen/.rvm/gems/ruby-1.9.2-p290/gems/vagrant-0.8.2/files/vagrant
      ' >> ~/.ssh/config

    Now you can use ssh to connect and run remote commands on the vagrant box from anywhere on your system:

    Example:

      $ ssh vagrant1.local 'ls -l'
      total 16
      -rw-r--r-- 1 tomcat6 tomcat6 3312 2011-08-26 11:36 portal.properties
      -rw-r--r-- 1 vagrant vagrant 3475 2011-07-21 15:32 postinstall.sh
      -rwxr-xr-x 1 vagrant vagrant  897 2011-08-26 11:42 reset_wise4_databases.rb
      drwxrwxr-x 4 vagrant vagrant 4096 2011-08-26 11:42 src

WISE4 logs: /var/log/tomcat6/

    $ tail -n 200 -f /var/log/tomcat6/catalina.out

The wise4-trunk vagrant image includes subversion, maven, ant, emacs, vim

## Restoring the WISE4 databases to a pristine state

    $ ssh vagrant1.local '/opt/ruby/bin/ruby reset_wise4_databases.rb'

*This assumes you have already created a local host named vagrant1.local and a custom ssh configuration.*

## Rebuilding the wise4-trunk base box

If the wise4-trunk base box needs to be updated with additional applications or services change to the rebuild/ directory and follow the instructions in the readme.

For more details on using vagrant see http://vagrantup.com

## Add a New Step Type

1. generate new step files 

        java -jar lib/StepTypeCreator.jar mynewstep mns

2. enable that new step type in the Vagrantfile, uncomment the 2nd line

        'Mynewstep' => "mynewstep"

3. tell Vagrant to reconfigure the VM

        vagrant reload

4. continue on step 4
   [here (github project page)](https://github.com/WISE-Community/WISE/wiki/How-to-Create-a-New-Step-Type-in-WISE4)

The values in the hashmap of Vagrantfile can be relative or paths.  Directories which are symlinks don't work because
the directories need to be mounted into the VM, and symlinks don't work for that.
