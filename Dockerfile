FROM gcr.io/dataflow-templates-base/java11-template-launcher-base:latest

# Define the Java command options required by Dataflow Flex Templates.
ENV FLEX_TEMPLATE_JAVA_MAIN_CLASS="com.spotify.flextemplate.WordCount"
ENV FLEX_TEMPLATE_JAVA_CLASSPATH="/template/flex-wordcount.jar"

# Make sure to package as an uber-jar including all dependencies.
COPY target/scala-2.13/flex-wordcount.jar ${FLEX_TEMPLATE_JAVA_CLASSPATH}