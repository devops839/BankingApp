# Use OpenJDK 17 image as the base image
FROM openjdk:17-jdk-slim
WORKDIR /app
EXPOSE 8080
COPY app/*.jar /app/bankapp.jar
CMD ["java", "-jar", "/app/bankapp.jar"]
