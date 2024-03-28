FROM debian:bullseye

MAINTAINER acardona

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y mariadb-server 

COPY ./tools/startMariadb.sh /bin/
RUN chmod u+x /bin/startMariadb.sh \
    && mkdir -p /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld/ \
    && mkdir -p /var/lib/mysql \
    && chown mysql:mysql /var/lib/mysql/

EXPOSE 3306

ENTRYPOINT [ "bash", "bin/startMariadb.sh"]