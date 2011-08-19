Rebuild the vm from a barebones ubuntu linux box
=========================================

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant/rebuild
    vagrant up

The first time this runs it will probably take 15m on a fast network connection.

If it is successful you will be able to open this page in a web browser to see WISE4 v5.0 (trunk):
 
    open http://localhost:8080/webapp/index.html

After modifying these scripts and confirming that the new base box works correctly you'll want to make a minified vagrant package and upload it for developers using the top-level Vagrantfile.

Repackage the vm built above into a Vagrant box
=======================================
Before following these steps you need to have a running base box and be in the rebuild dir.
 
    vagrant ssh
    > sudo apt-get clean
    > sudo service tomcat6 stop
    > sudo rm /var/lib/tomcat6/webapps/*.war
    > rm -rf /home/vagrant/src/portal/target
    > rm -rf /home/vagrant/src/vlewrapper/target
    > cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill  # fills drive with zeros for compression - takes a while
    > exit
    rm package.box
    vagrant package

Add the new package as a named vagrant box to your local development platform:

    vagrant box add wise4-trunk package.box

Now test the top-level Vagrantfile to make sure it works properly with this new box:

    cd ..
    vagrant destroy
    vagrant up

When the new vagrant instance has finished importing the wise4-trunk base box make sure the wise4 app is running:

    open http://localhost:8080/webapp/index.html

Then try sshing to the vagrant box and running the script which updates the wise4 portal and vlewrapper projects from subversion and deploys them to tomcat:

    $ vagrant ssh
    vagrant@lucid32:~$ ./src/update-wise4.sh
    vagrant@lucid32:~$ exit
    open http://localhost:8080/webapp/index.html

When you are convinced the new base box works upload a copy so that a developer who just wants to work with virtual image of WISE4 trunk can run the top-level Vagrantfile successfully:

    cd rebuild
    scp package.box otto.concord.org:/web/mysystem.dev.concord.org/wise4/wise4-trunk.box

References
=======================================

- http://vagrantup.com/docs/getting-started/index.html
- http://vagrantup.com/docs/provisioners/chef_solo.html
- http://wiki.opscode.com/display/chef/Chef+Solo
- http://wiki.opscode.com/display/chef/Resources
- http://wiki.opscode.com/display/chef/Deploy+Resource