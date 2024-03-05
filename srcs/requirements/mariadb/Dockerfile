FROM debian:bullseye

MAINTAINER acardona

# LABEL 
# USER acardona

RUN apt update \
    && apt install -y mariadb-server
COPY ./tools/mariadb_config.sh /tmp/mariadb_config.sh
RUN chmod +x /tmp/mariadb_config.sh
# COPY ./tools/mysql_init_commands.sql /tmp/mysql_init_commands.sql
ENTRYPOINT ["/tmp/mariadb_config.sh"]


