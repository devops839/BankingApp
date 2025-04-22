FROM openjdk:17-jdk-slim
WORKDIR /app
COPY app/target/bankapp-0.0.1-SNAPSHOT.jar /app/bank-app.jar  # Updated path to match where the JAR is downloaded
EXPOSE 8080
CMD ["java", "-jar", "/app/bank-app.jar"]
