import sbt._
import Keys._

val scioVersion = "0.9.1"
val beamVersion = "2.20.0"
val scalaMacrosVersion = "2.1.1"
lazy val commonSettings = Def.settings(
  organization := "com.spotify",
  // Semantic versioning http://semver.org/
  version := "0.1.0-SNAPSHOT",
  scalaVersion := "2.13.2",
  scalacOptions ++= Seq(
    "-target:jvm-1.8",
    "-deprecation",
    "-feature",
    "-unchecked",
    "-Ymacro-annotations"
  ),
  javacOptions ++= Seq("-source", "1.8", "-target", "1.8")
)
lazy val assemblySettings = Def.settings(
  assembly / test := {},
  assembly / assemblyJarName := "flex-wordcount.jar",
  assembly / assemblyMergeStrategy ~= { old =>
    {
      case s if s.endsWith(".properties") => MergeStrategy.filterDistinctLines
      case s if s.endsWith("public-suffix-list.txt") =>
        MergeStrategy.filterDistinctLines
      case s if s.endsWith(".class") => MergeStrategy.last
      case s if s.endsWith(".proto") => MergeStrategy.last
      case s                         => old(s)
    }
  }
)

lazy val root: Project = project
  .in(file("."))
  .settings(commonSettings)
  .settings(assemblySettings)
  .settings(
    name := "flex-template",
    description := "flex-template",
    publish / skip := true,
    run / classLoaderLayeringStrategy := ClassLoaderLayeringStrategy.Flat,
    libraryDependencies ++= Seq(
      "com.spotify" %% "scio-core" % scioVersion,
      "com.spotify" %% "scio-test" % scioVersion % Test,
      "org.apache.beam" % "beam-runners-direct-java" % beamVersion,
      "org.apache.beam" % "beam-runners-google-cloud-dataflow-java" % beamVersion,
      "org.slf4j" % "slf4j-simple" % "1.7.25"
    )
  )
  .enablePlugins(PackPlugin)

lazy val repl: Project = project
  .in(file(".repl"))
  .settings(commonSettings)
  .settings(
    name := "repl",
    description := "Scio REPL for flex-template",
    libraryDependencies ++= Seq(
      "com.spotify" %% "scio-repl" % scioVersion
    ),
    Compile / mainClass := Some("com.spotify.scio.repl.ScioShell"),
    publish / skip := true
  )
  .dependsOn(root)
