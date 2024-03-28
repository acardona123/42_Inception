FROM debian:bullseye

MAINTAINER acardona

RUN apt update \
    && apt-get install -y wget php-cli php-mysql php-curl php-gd php-intl php-fpm

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod 755 wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html/ \
    && cd /var/www/html/ \
    && wget https://wordpress.org/wordpress-6.4.3.tar.gz --output-document="wordpress.tar.gz" \
    && tar -xvzf wordpress.tar.gz \
    && rm -rf wordpress.tar.gz

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/wordpress.conf
COPY ./tools/startWordpress.sh /tmp/startWordpress.sh

RUN chown -R www-data:www-data /var/www/html/wordpress \
    && chmod -R 755 /var/www/html/wordpress \
    && chmod 755 /tmp/startWordpress.sh

EXPOSE 9000

ENTRYPOINT ["bash", "/tmp/startWordpress.sh"]
