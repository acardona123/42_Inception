FROM debian:bullseye

RUN apt update -y && apt upgrade -y \
    && apt-get install -y wget unzip php php-curl php-fpm php-bcmath php-gd php-soap php-zip php-curl php-mbstring php-mysqlnd php-gd php-xml php-intl php-zip

RUN sed -i s/"max_execution_time = 30"/"max_execution_time = 300"/g /etc/php/7.4/fpm/php.ini \
    && sed -i s/"memory_limit = 128M"/"memory_limit = 512M"/g /etc/php/7.4/fpm/php.ini \
    && sed -i s/"post_max_size = 8M"/"post_max_size = 128M"/g /etc/php/7.4/fpm/php.ini \
    && sed -i s/"upload_max_filesize = 2M"/"upload_max_filesize = 128M"/g /etc/php/7.4/fpm/php.ini

RUN cd /tmp \
    && wget https://wordpress.org/latest.zip \
    && mkdir -p /var/www/html/ \
    && rm -rf /var/www/html/* \
    && unzip latest.zip -d /var/www/html/ \
    && rm latest.zip

RUN cd /var/www/html/wordpress \
    && cp wp-config-sample.php wp-config.php \
    && sed -i s/"database_name_here"/"$WORDPRESS_DB_NAME"/g wp-config.php \
    && sed -i s/"username_here"/"$WORDPRESS_DB_USER"/g wp-config.php \
    && sed -i s/"password_here"/"$WORDPRESS_DB_PASSWORD"/g wp-config.php

RUN chown -R www-data:www-data /var/www/html/wordpress/
# RUN chmod -R 755 *

ENTRYPOINT ["sleep", "infinity"]