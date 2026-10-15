
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY . /tmp/foodwala

RUN mkdir -p /usr/local/tomcat/webapps/ROOT \
    && cp -r /tmp/foodwala/src/main/webapp/. /usr/local/tomcat/webapps/ROOT/ \
    && mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && cp -r /tmp/foodwala/src/main/java/. /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
