FROM openjdk:alpine

EXPOSE 8080
ADD server.zip server.zip
RUN unzip server.zip
RUN apk update && apk add bash && apk add mysql-client && rm -f /var/cache/apk/*
ADD startup.sh startup.sh
RUN chmod +x startup.sh
ENTRYPOINT ./startup.sh