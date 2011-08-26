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
stopping tomcat'
sudo service tomcat6 stop

echo '
copying webapp.war to /var/lib/tomcat6/webapps'
sudo cp /home/vagrant/src/portal/target/webapp.war /var/lib/tomcat6/webapps
echo 'copying vlewrapper.war to /var/lib/tomcat6/webapps'
sudo cp /home/vagrant/src/vlewrapper/target/vlewrapper.war /var/lib/tomcat6/webapps

echo '
removing expanded directory: /var/lib/tomcat6/webapps/webapp'
sudo rm -rf /var/lib/tomcat6/webapps/webapp
echo '
removing expanded directory: /var/lib/tomcat6/webapps/vlewrapper'
sudo rm -rf /var/lib/tomcat6/webapps/vlewrapper

echo '
resetting owner:group to tomcat6:tomcat6 in: /var/lib/tomcat6/webapps/webapp'
sudo chown -R tomcat6:tomcat6 /var/lib/tomcat6/webapps

echo '
starting tomcat'
sudo service tomcat6 start

echo '
updating portal properties and restarting tomcat'
sudo cp /home/vagrant/portal.properties /var/lib/tomcat6/webapps/webapp/WEB-INF/classes/portal.properties
sudo chown tomcat6:tomcat6 /var/lib/tomcat6/webapps/webapp/WEB-INF/classes/portal.properties
sudo service tomcat6 restart
