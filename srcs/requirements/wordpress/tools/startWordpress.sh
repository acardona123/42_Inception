#!/bin/bash

echo -e "\e[1mWordpress initialization:\e[0m" 

#setting local variables for a better confidentiality (kind of)
LOCAL_SQL_HOST=$SQL_HOST
LOCAL_WP_DOMAIN_NAME=$WP_DOMAIN_NAME
LOCAL_WP_SITE_TITLE=$WP_SITE_TITLE
LOCAL_WP_ADMIN_LOGIN=$WP_ADMIN_LOGIN
LOCAL_WP_ADMIN_PASSWORD=$WP_ADMIN_PASSWORD
LOCAL_WP_ADMIN_EMAIL=$WP_ADMIN_EMAIL
LOCAL_WP_USER_LOGIN=$WP_USER_LOGIN
LOCAL_WP_USER_MAIL=$WP_USER_MAIL
LOCAL_WP_USER_PASSWORD=$WP_USER_PASSWORD
LOCAL_SQL_DATABASE=$SQL_DATABASE
LOCAL_SQL_USER=$SQL_USER
LOCAL_SQL_USER_PASSWORD=$SQL_USER_PASSWORD
unset SQL_HOST WP_DOMAIN_NAME WP_SITE_TITLE WP_ADMIN_LOGIN WP_ADMIN_PASSWORD WP_ADMIN_EMAIL WP_USER_LOGIN WP_USER_MAIL WP_USER_PASSWORD SQL_DATABASE SQL_USER SQL_USER_PASSWORD
if [ -z "$LOCAL_SQL_HOST" ]\
 || [ -z "$LOCAL_WP_DOMAIN_NAME" ]\
 || [ -z "$LOCAL_WP_SITE_TITLE" ]\
 || [ -z "$LOCAL_WP_ADMIN_LOGIN" ]\
 || [ -z "$LOCAL_WP_ADMIN_PASSWORD" ]\
 || [ -z "$LOCAL_WP_ADMIN_EMAIL" ]\
 || [ -z "$LOCAL_WP_USER_LOGIN" ]\
 || [ -z "$LOCAL_WP_USER_MAIL" ]\
 || [ -z "$LOCAL_WP_USER_PASSWORD" ]\
 || [ -z "$LOCAL_SQL_DATABASE" ]\
 || [ -z "$LOCAL_SQL_USER" ]\
 || [ -z "$LOCAL_SQL_USER_PASSWORD" ]\
 ; then 
	echo "Error: missing or empty environment varaible: "
	[[ -z "$LOCAL_SQL_HOST" ]] && echo "SQL_HOST "
	[[ -z "$LOCAL_WP_DOMAIN_NAME" ]] && echo "WP_DOMAIN_NAME "
	[[ -z "$LOCAL_WP_SITE_TITLE" ]] && echo "WP_SITE_TITLE "
	[[ -z "$LOCAL_WP_ADMIN_LOGIN" ]] && echo "WP_ADMIN_LOGIN "
	[[ -z "$LOCAL_WP_ADMIN_PASSWORD" ]] && echo "WP_ADMIN_PASSWORD "
	[[ -z "$LOCAL_WP_ADMIN_EMAIL" ]] && echo "WP_ADMIN_EMAIL "
	[[ -z "$LOCAL_WP_USER_LOGIN" ]] && echo "WP_USER_LOGIN "
	[[ -z "$LOCAL_WP_USER_MAIL" ]] && echo "WP_USER_MAIL "
	[[ -z "$LOCAL_WP_USER_PASSWORD" ]] && echo "WP_USER_PASSWORD "
	[[ -z "$LOCAL_SQL_DATABASE" ]] && echo "SQL_DATABASE"
	[[ -z "$LOCAL_SQL_USER" ]] && echo "SQL_USER"
	[[ -z "$LOCAL_SQL_USER_PASSWORD" ]] && echo "SQL_USER_PASSWORD"
	exit 1
fi

if [[ "$LOCAL_WP_ADMIN_LOGIN" == *"admin"* ]] || [[ "$LOCAL_WP_ADMIN_LOGIN" == *"admin"* ]]; then
	echo "Error: The admin login cannot contain the words 'admin' ou 'Admin'"
	exit 1
fi


cd /var/www/html/wordpress

if ! wp core is-installed --allow-root 2>/dev/null; then
	wp config create --allow-root \
		--dbhost=${LOCAL_SQL_HOST} \
		--dbname=${LOCAL_SQL_DATABASE} \
		--dbuser=${LOCAL_SQL_USER} \
		--dbpass=${LOCAL_SQL_USER_PASSWORD} \
		--url=https://${LOCAL_WP_DOMAIN_NAME} 
	wp core install --allow-root \
		--url=https://${LOCAL_WP_DOMAIN_NAME} \
		--title=${LOCAL_WP_SITE_TITLE} \
		--admin_user=${LOCAL_WP_ADMIN_LOGIN} \
		--admin_password=${LOCAL_WP_ADMIN_PASSWORD} \
		--admin_email=${LOCAL_WP_ADMIN_EMAIL};
	wp user create --allow-root \
		${LOCAL_WP_USER_LOGIN} ${LOCAL_WP_USER_MAIL} \
		--user_pass=${LOCAL_WP_USER_PASSWORD} \
		--role=author
	wp language core install fr_FR --allow-root --activate
	wp cache flush --allow-root
	wp rewrite structure '/%postname%/' --allow-root
else
	echo "A wordpress is allready installed"
fi

mkdir -p /run/php;
rm /etc/php/7.4/fpm/pool.d/www.conf

echo -e "\e[1mWordpress successfully initialized\e[0m"

exec /usr/sbin/php-fpm7.4 --nodaemonize -R