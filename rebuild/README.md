Rebuild the vm from a barebones linux box
=========================================

Because there is a bug in the wise4 4.3 binary distro, we need to
manually resize a database row when creating a virtual box. In order to
resize the table, we must first save some learner data.  This bug was
fixed in 
[SVN commit2332](http://code.google.com/p/sail-web/source/diff?spec=svn2332&r=2332&format=side&path=/trunk/vlewrapper/src/vle/domain/work/StepWork.java).

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    cd wise4-vagrant/rebuild 
    vagrant up
    open http://localhost:8080/webapp/index.html

    # login as admin to author a project and create a project run 
    # login as a student and run the project and save data

    # alter the table:
    vagrant ssh
    > mysql -u wise4user -p<YOUR_SECRET_WORD> vle_database -e "alter table stepwork modify column data text;"


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
    scp package.box otto.concord.org:/web/mysystem.dev.concord.org/wise4/wise4-4_3-4.box
