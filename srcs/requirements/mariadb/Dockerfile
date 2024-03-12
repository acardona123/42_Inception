FROM debian:bullseye

MAINTAINER acardona

RUN apt update \
    && apt install -y mariadb-server
COPY ./tools/mariadb_config.sh /tmp/mariadb_config.sh
RUN chmod +x /tmp/mariadb_config.sh
ENTRYPOINT ["/tmp/mariadb_config.sh"]