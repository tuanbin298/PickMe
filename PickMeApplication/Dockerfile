# Multi-stage build for Spring Boot application
FROM maven:3.9.4-openjdk-17-slim AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first to cache dependencies
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/PickMeApplication-1.0-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]