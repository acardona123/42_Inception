FROM debian:bullseye

RUN apt update -y && apt upgrade -y \
    # && apt install wget unzip php7.4-fpm -y
    && apt-get install -y wget unzip php7.4 php7.4-curl php7.4-fpm php7.4-bcmath php7.4-gd php7.4-soap php7.4-zip php7.4-curl php7.4-mbstring php7.4-mysqlnd php7.4-gd php7.4-xml php7.4-intl php7.4-zip

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

WORKDIR /var/www/html



COPY /tools/wordpress_config.sh /tmp/wordpress_config.sh
RUN chmod 777 /tmp/wordpress_config.sh

#  For server domain name
# COPY conf/custom-apache-config.conf /etc/apache2/sites-available/000-default.conf


ENTRYPOINT ["/tmp/wordpress_config.sh"]