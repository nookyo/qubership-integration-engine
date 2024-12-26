
# FROM eclipse-temurin:21-jre-alpine
FROM alpine/java:21-jre

RUN chmod -R 755 /opt/java/openjdk && \
    apk add --no-cache curl

USER 10001

WORKDIR /app

VOLUME /tmp

EXPOSE 8080

COPY --chown=10001:0 target/qip-engine-*-exec.jar /app/qip-engine.jar

CMD ["/opt/java/openjdk/bin/java", "-Xmx832m", "-Djava.security.egd=file:/dev/./urandom", "-Dfile.encoding=UTF-8", "-jar", "/app/qip-engine.jar"]