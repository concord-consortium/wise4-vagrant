This project uses Vagrant to setup a wise4 virtual machine.

Prerequisites
=============

- ruby - on OS X this is already installed
- vagrant - run "sudo gem install vagrant" (rvm users: change that appropriately)
- virtualbox - http://www.virtualbox.org/wiki/Downloads


Just use it
===========

    vagrant box add wise4-4_3-0 http://mysystem.dev.concord.org/wise4/wise4-4_3-0.box  # this downloads a 630MB file
    vagrant init wise4-4_3-0
    vagrant up
    open http://localhost:4567/webapp/index.html

When you are done using it and want to save disk space

    vagrant destroy  # note this will completely remove any data on the virtual machine

Then to use it again just do

    vagrant up

If you want to get into the VM and check it out

    vagrant ssh

For more details see http://vagrantup.com


Rebuild the vm from a barebones linux box
=========================================

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant
    vagrant up
    open http://localhost:4567/webapp/index.html


Repackage the vm built above into a box
=======================================

    vagrant ssh
    > sudo apt-get clean
    > sudo service tomcat6 stop
    > sudo rm /var/lib/tomcat6/webapps/*.war
    > cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill  # fills drive with zeros for compression - takes a while
    > exit
    rm package.box
    vagrant package --vagrantfile Vagrantfile.pkg
    scp package.box otto.concord.org:/web/mysystem.dev.concord.org/wise4/wise4-4_3-0.box