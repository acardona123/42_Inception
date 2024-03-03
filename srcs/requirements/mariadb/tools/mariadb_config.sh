#!/bin/bash

LOCAL_MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD"
LOCAL_MYSQL_USER="$MYSQL_USER"
LOCAL_MYSQL_USER_PASSWORD="$MYSQL_USER_PASSWORD"
unset "$MYSQL_ROOT_PASSWORD" "$MYSQL_USER" "$MYSQL_USER_PASSWORD"


echo -e "\e[1mDatabase initialization:\e[0m" 
if [ "a$LOCAL_MYSQL_ROOT_PASSWORD" = "a" ] || [ "a$LOCAL_MYSQL_USER" = "a" ] || [ "a$LOCAL_MYSQL_USER_PASSWORD" = "a" ]; then
    echo "Error: missing or empty root password or user name/password"
    exit 1
fi

#script to modify the config and open the port and bind-address for a less restrictive one
cat /etc/mysql/my.cnf | sed s/"# port"/"port"/g | sed s/"# Import all"/"bind-address = 0.0.0.0\n\n# Import all"/g  > /tmp/my.cnf && mv /tmp/my.cnf /etc/mysql/my.cnf

echo "  - installation script: mysql_install_db"
# script that properly lunch mysql fo mariadb
mysql_install_db --user=mysql --ldata=/var/lib/mysql

echo "  - mariadb start:"
service mariadb start

echo "  - config root connection"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('$LOCAL_MYSQL_ROOT_PASSWORD');"

mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"

echo "  - adding $LOCAL_MYSQL_USER as an admin"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "CREATE USER '$LOCAL_MYSQL_USER'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('$LOCAL_MYSQL_USER_PASSWORD');"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$LOCAL_MYSQL_USER'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"



echo "Done"
echo

sleep 2000