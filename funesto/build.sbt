val springBootVersion = "2.6.5"
val flywayVersion = "8.5.5"

val commonSettings = Seq(
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
)

ThisBuild / organization := "funesto.server"
ThisBuild / scalaVersion := "2.13.1"

lazy val server1 = project
  .settings(
    commonSettings,
    name := "server1",
    version := "0.1.0-SNAPSHOT",
    Universal / packageName := "server1",
    Universal / name := "server1"
  )
  .enablePlugins( JavaAppPackaging )

lazy val server2 = project
  .settings(
    commonSettings,
    name := "server2",
    version := "0.1.0-SNAPSHOT",
    Universal / packageName := "server2",
    Universal / name := "server2"
  )
  .enablePlugins( JavaAppPackaging )
