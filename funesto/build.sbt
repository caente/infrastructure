val springBootVersion = "2.6.5"
val flywayVersion = "8.5.5"

libraryDependencies ++= Seq(
  "org.springframework.boot" % "spring-boot-starter-parent" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-web" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-test" % springBootVersion,
  "org.springframework.boot" % "spring-boot-starter-data-rest" % springBootVersion,
  //  "org.flywaydb" % "flyway-core" % flywayVersion,
  //  "org.flywaydb" % "flyway-mysql" % flywayVersion,
  "com.fasterxml.jackson.module" %% "jackson-module-scala" % "2.13.2",
  //  "org.springframework.boot" % "spring-boot-starter-data-r2dbc" % springBootVersion,
  "mysql" % "mysql-connector-java" % "8.0.28", //runtimeOnly
  //  "dev.miku" % "r2dbc-mysql" % "0.8.2.RELEASE" //runtimeOnly
)

ThisBuild / name := "funesto"
ThisBuild / version := "0.1.0-SNAPSHOT"
ThisBuild / organization := "funesto.server"
ThisBuild / scalaVersion := "2.13.1"
assembly / mainClass := Some("funesto.server.Boot")
assembly / assemblyJarName := "server.jar"

assembly / assemblyMergeStrategy := {
  case PathList("META-INF", "spring.factories") => MergeStrategy.filterDistinctLines
  case PathList("META-INF", _*) => MergeStrategy.discard
  case _ => MergeStrategy.first
}