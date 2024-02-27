#!/bin/bash

echo -e "Database initialization:" 


echo "  - installation script: mysql_install_db"
# script that properly lunch mysql fo mariadb
mysql_install_db --user=mysql --ldata=/var/lib/mysql

echo "  - mariadb start:"
service mariadb start

echo "  - config root connection"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('$MYSQL_ROOT_PASSWORD');"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"

echo "  - adding $MYSQL_USER as an admin"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('$MYSQL_USER_PASSWORD');"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;"

mysql -e "FLUSH PRIVILEGES;"

echo "Done"
echo

sleep 2000



# # connecting as root to db
# mysql -u root -h 'localhost' 
# # changing root passworld
# ALTER USER 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
# # remove root loging remotly
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');
# # remove anonymous users
# DELETE FROM mysql.user WHERE User='';
# # creating admind user:
# #  - adding user with password
#   CREATE USER "$MYSQL_USER"@'localhost' IDENTIFIED BY "$MYSQL_USER_PASSWORD";
# #  - granting proviledges to user
# GRANT ALL PRIVILEGES ON *.* TO "$MYSQL_USER"@'localhost' WITH GRANT OPTION;
# #  flush priviledges
# FLUSH PRIVILEGES;
# # remove test database
# DROP DATABASE test;


