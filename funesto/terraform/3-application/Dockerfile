FROM openjdk:alpine

EXPOSE 8080
ADD funesto.jar funesto.jar
ENTRYPOINT ["java","-jar","-Xms1024m","Xmx1800m","funesto.jar"]