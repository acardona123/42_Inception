FROM debian:bullseye

MAINTAINER acardona
# LABEL 
# USER acardona

ENTRYPOINT ["sleep", "infinity"]

RUN apt update
RUN apt install -y mariadb-server
# COPY ./non_interactive_mysql_secure_installation.sh /tmp/non_interactive_mysql_secure_installation.sh
# RUN chmod +x /tmp/non_interactive_mysql_secure_installation.sh
# RUN /tmp/non_interactive_mysql_secure_installation.sh
COPY ./test.sh /tmp/test.sh
RUN chmod +x /tmp/test.sh
RUN /tmp/test.sh