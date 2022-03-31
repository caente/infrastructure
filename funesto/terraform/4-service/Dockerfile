FROM openjdk:alpine

EXPOSE 8080
ADD server.jar server.jar
ENTRYPOINT ["java","-jar","-Xms1024m","-Xmx1800m","server.jar"]