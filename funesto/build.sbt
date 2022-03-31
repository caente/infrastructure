val springBootVersion = "2.6.5"
val flywayVersion = "8.5.5"

libraryDependencies ++= Seq(
  "org.springframework.boot" % "spring-boot-starter-parent" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-web" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-test" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-data-rest" % springBootVersion,
  "org.flywaydb" % "flyway-core" % flywayVersion,
  "org.flywaydb" % "flyway-mysql" % flywayVersion,
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.13.2",
  "org.springframework.boot" % "spring-boot-starter-data-r2dbc" % springBootVersion,
  "mysql" % "mysql-connector-java" % "8.0.28", //runtimeOnly
  "dev.miku" % "r2dbc-mysql" % "0.8.2.RELEASE" //runtimeOnly
)

name := "server"
version := "0.1.0-SNAPSHOT"
organization := "funesto.server"
scalaVersion := "2.13.1"
maintainer := "dimeder.com"

enablePlugins( JavaAppPackaging )
Universal / packageName := "server"
Universal / name := "server"
