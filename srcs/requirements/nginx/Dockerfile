# FROM debian:bullseye

# MAINTAINER acardona

# # installation procedure from http://nginx.org/en/linux_packages.html#Debian

# RUN apt update
# RUN apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
# RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
#     | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
# # RUN gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
# http://nginx.org/packages/debian `lsb_release -cs` nginx" \
#     |  tee /etc/apt/sources.list.d/nginx.list
# # RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
# # http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
# #     |  tee /etc/apt/sources.list.d/nginx.list
# # RUN echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
# #     | tee /etc/apt/preferences.d/99nginx
# RUN apt update
# RUN apt install nginx
# COPY ./nginx_exec.sh /tmp/nginx_exec.sh 
# RUN chmod 777 /tmp/nginx_exec.sh 
# # RUN /tmp/nginx_exec.sh
# # CMD service start nginx
# ENTRYPOINT ["sleep", "infinity"]


# Use Debian Bullseye as the base image
FROM debian:bullseye

# Update the package list
RUN apt-get update

# Install NGINX
RUN apt-get install -y nginx

# # Optionally, remove the default NGINX configuration
# RUN rm -rf /etc/nginx/sites-enabled/default

# Expose port  80
EXPOSE  80

# Define the command to run NGINX
CMD ["nginx", "-g", "daemon off;"]
