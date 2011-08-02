Rebuild the vm from a barebones linux box
=========================================

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant/rebuild
    vagrant up
    open http://localhost:8080/webapp/index.html


Repackage the vm built above into a box
=======================================

    cd rebuild
    vagrant ssh
    > sudo apt-get clean
    > sudo service tomcat6 stop
    > sudo rm /var/lib/tomcat6/webapps/*.war
    > cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill  # fills drive with zeros for compression - takes a while
    > exit
    rm package.box
    vagrant package
    scp package.box otto.concord.org:/web/mysystem.dev.concord.org/wise4/wise4-4_3-1.box
    
References
=======================================
# http://vagrantup.com/docs/getting-started/index.html
# http://vagrantup.com/docs/provisioners/chef_solo.html
# http://wiki.opscode.com/display/chef/Chef+Solo
# http://wiki.opscode.com/display/chef/Resources
# http://wiki.opscode.com/display/chef/Deploy+Resource