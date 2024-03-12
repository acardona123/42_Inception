FROM debian:bullseye

RUN apt update
RUN apt install nginx -y
RUN rm -rf /etc/nginx/sites-enabled/*
COPY conf/wordpress.conf /etc/nginx/conf.d/wordpress.conf
# EXPOSE 413
# EXPOSE 80
COPY tools/nginx_launch.sh tmp/nginx_launch.sh
ENTRYPOINT ["tmp/nginx_launch.sh"]
