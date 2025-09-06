# --- Stage 1: Build the application ---
FROM maven:3.9.3-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the jar
RUN mvn clean package -DskipTests

# --- Stage 2: Run the app ---
FROM eclipse-temurin-17-jdk-alpine

WORKDIR /app

# Use a wildcard to copy the JAR, making it more robust
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# REMOVED: All ENV variables with secrets are gone.
# They will be provided by the deployment platform (e.g., Render).

ENV YOUTUBE_API_KEY=AIzaSyDcOSEhx8LpaG0MhheUC6EDY-bA3Tpp_nA
ENV SPRING_MAIL_USERNAME=chotabheemdholakpurwala@gmail.com
ENV SPRING_MAIL_PASSWORD=ijtvmcdpdrvvlrun
ENV SPRING_REDIS_HOST=redis-13017.c305.ap-south-1-1.ec2.redns.redis-cloud.com
ENV SPRING_REDIS_PORT=13017
ENV SPRING_REDIS_PASSWORD=qaWUX9eWWGv4isZCwW0m01aialdnJriX

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
