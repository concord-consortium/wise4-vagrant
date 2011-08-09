#!/bin/sh

echo '
updating subversion checkout of portal'
cd /home/vagrant/src/portal
svn up
echo 'building webapp.war with maven'
mvn -Dmaven.test.skip=true package

echo '
updating subversion checkout of vlewrapper'
cd /home/vagrant/src/vlewrapper
echo 'svn revert locally built WebContent/WEB-INF/lib/vlewrapper-classes.jar'
svn revert -R *
svn up
echo 'building vlewrapper.war with maven'
mvn -Dmaven.test.skip=true package

echo '
copying webapp.war to /var/lib/tomcat6/webapps'
sudo cp /home/vagrant/src/portal/target/webapp.war /var/lib/tomcat6/webapps
echo 'copying vlewrapper.war to /var/lib/tomcat6/webapps'
sudo cp /home/vagrant/src/vlewrapper/target/vlewrapper.war /var/lib/tomcat6/webapps

echo '
restarting tomcat'
sudo service tomcat6 restart
