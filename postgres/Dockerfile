FROM postgres:11.7

# RUN apk add --update htop
RUN apt-get update -y
RUN apt-get install -y htop
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh

RUN chmod 0666 /docker-entrypoint-initdb.d/setup-master.sh