FROM debian:bullseye

MAINTAINER acardona

# LABEL 
# USER acardona

RUN apt update
RUN apt install -y mariadb-server
COPY ./tools/test.sh /tmp/test.sh
RUN chmod +x /tmp/test.sh
# COPY ./tools/mysql_init_commands.sql /tmp/mysql_init_commands.sql
ENTRYPOINT ["/tmp/test.sh"]
