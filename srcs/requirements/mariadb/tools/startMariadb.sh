#!/bin/bash

echo -e "\e[1mMariadb initialization:\e[0m" 

LOCAL_SQL_ROOT_PASSWORD="$SQL_ROOT_PASSWORD"
LOCAL_SQL_USER="$SQL_USER"
LOCAL_SQL_USER_PASSWORD="$SQL_USER_PASSWORD"
LOCAL_SQL_DATABASE="$SQL_DATABASE"
unset SQL_ROOT_PASSWORD SQL_USER SQL_USER_PASSWORD SQL_DATABASE
#check if all any requiered variable is empty (not allowed)
if [ -z "$LOCAL_SQL_ROOT_PASSWORD" ]\
 || [ -z "$LOCAL_SQL_USER" ]\
 || [ -z "$LOCAL_SQL_USER_PASSWORD" ]\
 || [ -z "$LOCAL_SQL_DATABASE" ];\
 then
    echo "Error: missing or empty environment varaible: "
    [[ -z "$LOCAL_SQL_ROOT_PASSWORD" ]] && echo "SQL_ROOT_PASSWORD "
    [[ -z "$LOCAL_SQL_USER" ]] && echo "SQL_USER "
    [[ -z "$LOCAL_SQL_USER_PASSWORD" ]] && echo "SQL_USER_PASSWORD "
    [[ -z "$LOCAL_SQL_DATABASE" ]] && echo "SQL_DATABASE "
    exit 1
fi


service mariadb start;

existingDB=$(mariadb -e "SHOW DATABASES LIKE '${LOCAL_SQL_DATABASE}';" 2> /dev/null)
if [[ -z $existingDB ]]; then
    echo "Initialisation of a new database named ${LOCAL_SQL_DATABASE} for Wordpress :"

    echo "  - removing test databases"
    mariadb -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"

    echo "  - creating the database"
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${LOCAL_SQL_DATABASE}\`;"

    echo "  - removing anonymous connection"
    mariadb -e "DELETE FROM mysql.user WHERE User='';"

    echo "  - adding $LOCAL_SQL_USER as an admin for this database"
    mariadb -e "CREATE USER IF NOT EXISTS \`${LOCAL_SQL_USER}\`@'localhost' IDENTIFIED BY '${LOCAL_SQL_USER_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${LOCAL_SQL_DATABASE}\`.* TO \`${LOCAL_SQL_USER}\`@'%' IDENTIFIED BY '${LOCAL_SQL_USER_PASSWORD}';"

    echo "  - config root connection (adding password and forbidding remote access)"
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('${LOCAL_SQL_ROOT_PASSWORD}');"
    mariadb -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mariadb -e "FLUSH PRIVILEGES;"

    echo "=> New databased successfully created"

else
    echo "Database \"${LOCAL_SQL_DATABASE}\" allready exists for a Wordpress usage"
fi

sed -i "s/bind-address            = 127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

mysqladmin -u root -p${LOCAL_SQL_ROOT_PASSWORD} shutdown

echo -e "\e[1mMariaDB successfully initialized\e[0m"

exec mysqld_safe