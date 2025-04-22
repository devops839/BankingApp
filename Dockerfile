# Stage 1: Build the application
FROM maven:3.8-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml /app
RUN mvn dependency:go-offline
COPY src /app/src
RUN mvn clean package -DskipTests

# Stage 2: Create the production image
FROM FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/bankapp-0.0.1-SNAPSHOT.jar /app/bank-app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/bank-app.jar"]
