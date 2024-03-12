#!/bin/bash

sed -i s/"max_execution_time = 30"/"max_execution_time = 300"/g /etc/php/7.4/fpm/php.ini
sed -i s/"memory_limit = 128M"/"memory_limit = 512M"/g /etc/php/7.4/fpm/php.ini
sed -i s/"post_max_size = 8M"/"post_max_size = 128M"/g /etc/php/7.4/fpm/php.ini
sed -i s/"upload_max_filesize = 2M"/"upload_max_filesize = 128M"/g /etc/php/7.4/fpm/php.ini

mkdir -p /var/www/html/
chown -R www-data:www-data /var/www/html/ >/dev/null

echo "Downloading wordpress files"
cd /tmp \
 && wget -q https://wordpress.org/latest.zip\
 && rm -rf /var/www/html/* \
 && unzip latest.zip -d /var/www/html/ >/dev/null\
 && rm latest.zip

echo "Settings update"
cd /var/www/html/wordpress \
 && cp wp-config-sample.php wp-config.php \
 && sed -i s/"database_name_here"/"$WORDPRESS_DB_NAME"/g wp-config.php \
 && sed -i s/"localhost"/"$WORDPRESS_DB_HOST"/g wp-config.php \
 && sed -i s/"username_here"/"$WORDPRESS_DB_USER"/g wp-config.php \
 && sed -i s/"password_here"/"$WORDPRESS_DB_PASSWORD"/g wp-config.php \
 && chown -R www-data:www-data /var/www/html/wordpress/ >/dev/null\
 && chmod -R 755 *

echo Wordpress initialization done 

service php7.4-fpm start

sleep infinity