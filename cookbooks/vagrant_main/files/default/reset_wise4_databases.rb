# 
# restores WISE4 databases to pristine state (same as a new wise4 install)
#

# stop tomcat
system "sudo service tomcat6 stop"

# drop and recreate the wise4 databases
sql= <<-SQL
drop database if exists sail_database;
create database sail_database;
grant all privileges on sail_database.* to 'wise4user'@'localhost' identified by 'wise4pass';
drop database if exists vle_database;
create database vle_database;
grant all privileges on vle_database.* to 'wise4user'@'localhost' identified by 'wise4pass';
flush privileges;
SQL
system "mysql -u root -ppassword -e\"#{sql}\""

# load the initial data into the sail_database
tels_path = "/var/lib/tomcat6/webapps/webapp/WEB-INF/classes/tels"
system "mysql sail_database -u root -ppassword < #{tels_path}/wise4-createtables.sql"

# start tomcat
system "sudo service tomcat6 start"
