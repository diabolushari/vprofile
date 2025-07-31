FROM eclipse-temurin:21-jdk

# Install Tomcat 9
RUN curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz && \
    tar -xvzf apache-tomcat-9.0.85.tar.gz && \
    mv apache-tomcat-9.0.85 /opt/tomcat && \
    rm apache-tomcat-9.0.85.tar.gz

# Remove default apps and deploy your WAR
RUN rm -rf /opt/tomcat/webapps/*
COPY myapp.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
