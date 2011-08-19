This project uses Vagrant to setup a trunk version of WISE4 virtual machine.

Prerequisites
=============

- ruby - on OS X this is already installed
- git
- vagrant - run "sudo gem install vagrant" (rvm users: normally you will not use sudo)
- virtualbox 4.1 - http://www.virtualbox.org/wiki/Downloads

Get Started
===========

    $ git clone git://github.com/concord-consortium/wise4-vagrant.git
    $ cd wise4-vagrant
    $ git checkout --track origin/wise4-trunk
    $ vagrant up

The first time you do this it will download and cache a 1.2GB vagrant virtual machine image named wise4-trunk which is then used as a base box for the actual vagrant instance you are creating. After the wise4-trunk base box is downloaded and cached recreating your local wise4-trunk base box will be much faster.

The wise4-trunk base box was built using WISE4 vlewrapper svn rev: 2344 and portal svn rev: 3236. The base box includes a script in /home/vagrant/src you can manually run to update the svn checkouts of the portal and vlewrapper projects, build them with maven, and deploy them to tomcat.

After the vagrant up command has completed without error try opening wise4:

    $ open http://localhost:8080/webapp/index.html

When you are done using the wise4-trunk vagrant instance run:

    $ vagrant halt

When you are done using it and want to save disk space run:

    $ vagrant destroy

This command deletes all the data from the virtual machine. If you have updated to the wise4 codebase you will lose these changes but they can be easily restored by running this script on the wise4-trunk vm: /home/vagrant//src/update-wise4.sh.

Running vagrant destroy does not delete the wise4-trunk base box initially downloaded.
 
To use the wise4-trunk vm again after halting or destroying just run:

    $ vagrant up

To update to the latest version of wise4 ssh into the vagrant box and run the ./src/update-wise4.sh script which updates the wise4 portal and vlewrapper projects from subversion, builds them with maven and ant and deploys them to tomcat:

    $ vagrant ssh
    vagrant@lucid32:~$ ./src/update-wise4.sh
    vagrant@lucid32:~$ exit

Then open the wise4 web page:

    $ open http://localhost:8080/webapp/index.html

If you want to get into the VM and work directly with the wise4 instance or the services it depends on:

    $ vagrant ssh

The wise4-trunk vagrant image includes subversion, maven, ant, emacs, vim

Rebuilding the wise4-trunk base box
===================

If the wise4-trunk base box needs to be updated with additional applications or services change to the rebuild/ directory and follow the instructions in the readme.

For more details on using vagrant see http://vagrantup.com

Add a New Step Type
===================

1. generate new step files 

        java -jar lib/StepTypeCreator.jar mynewstep mns

2. enable that new step type in the Vagrantfile, uncomment the 2nd line

        'Mynewstep' => "mynewstep"

3. tell Vagrant to reconfigure the VM

        vagrant reload

4. continue on step 4 here: http://code.google.com/p/wise4/wiki/HowToCreateANewWise4Step

The values in the hashmap of Vagrantfile can be relative or paths.  Directories which are symlinks don't work because
the directories need to be mounted into the VM, and symlinks don't work for that.