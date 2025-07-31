FROM eclipse-temurin:21-jdk

# Set environment variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Download and extract Tomcat 9
RUN apt-get update && apt-get install -y curl && \
    curl -fSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz -o /tmp/tomcat.tar.gz && \
    mkdir -p /opt/tomcat && \
    tar -xzf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm /tmp/tomcat.tar.gz

# Remove default webapps
RUN rm -rf /opt/tomcat/webapps/*

# Copy your WAR to ROOT
COPY myapp.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
