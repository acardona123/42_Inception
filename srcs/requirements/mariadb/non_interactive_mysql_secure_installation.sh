#!/bin/sh

# Copyright (c) 2002, 2012, Oracle and/or its affiliates. All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA

echo -e "\e[103mBasepath: $BASE_PATH.\e[0m\n"

config=".my.cnf.$$"
command=".mysql.$$"
mysql_client=""

trap "interrupt" 1 2 3 6 15

rootpass=""
echo_n=
echo_c=

set_echo_compat() {
    case `echo "testing\c"`,`echo -n testing` in
	*c*,-n*) echo_n=   echo_c=     ;;
	*c*,*)   echo_n=-n echo_c=     ;;
	*)       echo_n=   echo_c='\c' ;;
    esac
}

prepare() {
    touch $config $command
    chmod 600 $config $command
}

find_mysql_client()
{
  for n in ./bin/mysql mysql
  do  
    $n --no-defaults --help > /dev/null 2>&1
    status=$?
    if test $status -eq 0
    then
      mysql_client=$n
      return
    fi  
  done
  echo "Can't find a 'mysql' client in PATH or ./bin"
  exit 1
}

do_query() {
    echo "$1" >$command
    $mysql_client --defaults-file=$config <$command
    return $?
}

# Simple escape mechanism (\-escape any ' and \), suitable for two contexts:
# - single-quoted SQL strings
# - single-quoted option values on the right hand side of = in my.cnf
#
# These two contexts don't handle escapes identically.  SQL strings allow
# quoting any character (\C => C, for any C), but my.cnf parsing allows
# quoting only \, ' or ".  For example, password='a\b' quotes a 3-character
# string in my.cnf, but a 2-character string in SQL.
#
# This simple escape works correctly in both places.
basic_single_escape () {
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

make_config() {
    echo "# mysql_secure_installation config file" >$config
    echo "[mysql]" >>$config
    echo "user=root" >>$config
    esc_pass=`basic_single_escape "$rootpass"`
    echo "password='$esc_pass'" >>$config
}

get_root_password() {
    status=1
    password=""
	hadpass=0
	rootpass=""
	make_config
	do_query ""
	status=$?
    echo "OK, successfully used root password, moving on..."
    echo
}

set_root_password() {
    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        echo "Sorry, you can't use an empty password as a database root password. Please add a non-empty MYSQL_ROOT_PASSWORD variable to your .env file"
        return 1
    fi

    esc_pass=`basic_single_escape "$password1"`
    do_query "UPDATE mysql.user SET Password=PASSWORD('$esc_pass') WHERE User='root';"
    if [ $? -eq 0 ]; then
        echo "Password updated successfully!"
        echo "Reloading privilege tables.."
        reload_privilege_tables
        if [ $? -eq 1 ]; then
            clean_and_exit
        fi
        echo
        rootpass=$MYSQL_ROOT_PASSWORD
        make_config
    else
        echo "Password update failed!"
        clean_and_exit
    fi

    return 0
}

remove_anonymous_users() {
    do_query "DELETE FROM mysql.user WHERE User='';"
    if [ $? -eq 0 ]; then
	echo " ... Success!"
    else
	echo " ... Failed!"
	clean_and_exit
    fi

    return 0
}

remove_remote_root() {
    do_query "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    if [ $? -eq 0 ]; then
	echo " ... Success!"
    else
	echo " ... Failed!"
    fi
}

remove_test_database() {
    echo " - Dropping test database..."
    do_query "DROP DATABASE test;"
    if [ $? -eq 0 ]; then
	echo " ... Success!"
    else
	echo " ... Failed!  Not critical, keep moving..."
    fi

    echo " - Removing privileges on test database..."
    do_query "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    if [ $? -eq 0 ]; then
	echo " ... Success!"
    else
	echo " ... Failed!  Not critical, keep moving..."
    fi

    return 0
}

reload_privilege_tables() {
    do_query "FLUSH PRIVILEGES;"
    if [ $? -eq 0 ]; then
	echo " ... Success!"
	return 0
    else
	echo " ... Failed!"
	return 1
    fi
}

interrupt() {
    echo
    echo "Aborting!"
    echo
    cleanup
    stty echo
    exit 1
}

cleanup() {
    echo "Cleaning up..."
    rm -f $config $command
}

# Remove the files before exiting.
clean_and_exit() {
	cleanup
	exit 1
}


# The actual script starts here

echo "==="
echo "Running a non interactive equivalent of  mysql_secure_installation"
echo "==="
echo 

prepare
find_mysql_client
set_echo_compat

get_root_password

echo "Setting the root password ensures that nobody can log into the MySQL"
set_root_password
status=$?
if [ $status -eq 1 ]; then
    exit 1
fi
echo


echo "Remove anonymous users"
    remove_anonymous_users
echo

echo "Disallow remote root login"
remove_remote_root
echo

echo "Remove test database"
remove_test_database

echo "Reload privilege tables"
reload_privilege_tables
echo

cleanup

echo
echo "End of the mysql securisation!"
echo