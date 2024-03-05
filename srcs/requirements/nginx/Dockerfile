FROM debian:bullseye

MAINTAINER acardona

# # installation procedure from http://nginx.org/en/linux_packages.html#Debian

RUN apt update -y
RUN apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    |  tee /etc/apt/sources.list.d/nginx.list

RUN apt update -y \
    && apt install nginx
COPY tools/nginx_wordpress.conf /etc/nginx/conf.d/wordpress.conf
COPY tools/nginx_wordpress.conf /etc/nginx/sites-available/wordpress.conf
RUN ln -s ../sites-available/wordpress.conf /etc/nginx/sites-enabled
COPY tools/nginx_exec.sh /tmp/nginx_exec.sh 
RUN chmod 777 /tmp/nginx_exec.sh \
    && /tmp/nginx_exec.sh \
    && rm /tmp/nginx_exec.sh
EXPOSE 413
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
