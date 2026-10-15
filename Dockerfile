
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY . /tmp/foodwala

RUN mkdir -p /usr/local/tomcat/webapps/ROOT \
    && cp -r /tmp/foodwala/src/main/webapp/. /usr/local/tomcat/webapps/ROOT/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/lib

RUN cp /tmp/foodwala/src/main/webapp/WEB-INF/lib/jbcrypt-0.4.jar \
    /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/ \
    && cp /tmp/foodwala/src/main/webapp/WEB-INF/lib/mysql-connector-j-9.7.0/mysql-connector-j-9.7.0.jar \
    /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

RUN find /tmp/foodwala/src/main/java -name "*.java" > /tmp/sources.txt \
    && javac -cp "/usr/local/tomcat/lib/*:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*" \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes @/tmp/sources.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
