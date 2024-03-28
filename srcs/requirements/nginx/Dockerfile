FROM debian:bullseye

MAINTAINER acardona

RUN apt update -y \
	&& apt install -y nginx \
    && rm /etc/nginx/sites-enabled/*

RUN apt install -y openssl \
    && mkdir /etc/nginx/ssl \
	&& openssl req -nodes -x509 -keyout /etc/nginx/ssl/wordpress.key \
		-out /etc/nginx/ssl/wordpress.crt \
		-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42/CN=acardona.42.fr/UID=acardona"

COPY ./conf/nginx.conf /etc/nginx/conf.d/wordpress.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]