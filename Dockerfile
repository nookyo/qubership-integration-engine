# Defini builder step
FROM alpine/java:21-jdk as builder

# Install necessary tools in one layer to reduce image size
RUN apk add --no-cache maven curl \
    && mkdir -p /app

# Copy the project files and build the application
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Use a minimal runtime base image
FROM alpine/java:21-jdk

# Set up non-root user in a single layer
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && mkdir -p /app && chown appuser:appgroup /app

USER appuser

# Define a volume for temporary data
VOLUME /tmp

# Expose the application port
EXPOSE 8080

# Copy only the built artifact
COPY --from=builder /app/target/qip-engine-*-exec.jar /app/qip-engine.jar

# Set the entrypoint
CMD ["java", "-Xmx832m", "-Djava.security.egd=file:/dev/./urandom", "-Dfile.encoding=UTF-8", "-jar", "/app/qip-engine.jar"]