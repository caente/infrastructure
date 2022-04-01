FROM openjdk:alpine

ARG SERVICE_NAME
EXPOSE 8080
ADD ${SERVICE_NAME}.zip ${SERVICE_NAME}.zip
RUN unzip ${SERVICE_NAME}.zip
RUN apk update && apk add bash && apk add mysql-client && rm -f /var/cache/apk/*
ADD startup.sh startup.sh
RUN chmod +x startup.sh
ENTRYPOINT ./startup.sh