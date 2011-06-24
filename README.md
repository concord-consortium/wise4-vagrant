This project uses Vagrant to setup a wise4 virtual machine.

Prerequisites
=============

- ruby - on OS X this is already installed
- git
- vagrant - run "sudo gem install vagrant" (rvm users: change that appropriately)
- virtualbox - http://www.virtualbox.org/wiki/Downloads


Get Started
===========

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant
    vagrant up # this will take some time as it downloads a 636mb file
    open http://localhost:8080/webapp/index.html

When you are done using it and want to save disk space

    vagrant destroy  # note this will completely remove any data on the virtual machine

Then to use it again just do

    vagrant up

If you want to get into the VM and check it out

    vagrant ssh

For more details see http://vagrantup.com

Add a New Node (step type)
==========================

1. generate new step files: java -jar lib/StepTypeCreator.jar mynewstep mns
2. enable that new step type in the Vagrantfile, uncomment the 2nd line:

    'Mynewstep' => "mynewstep"

3. tell Vagrant to reconfigure the VM: vagrant reload
4. continue on step 4 here: http://code.google.com/p/wise4/wiki/HowToCreateANewWise4Step

The values in the hashmap of Vagrantfile can be relative or paths.  Directories which are symlinks don't work because
the directories need to be mounted into the VM, and symlinks don't work for that.