FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/bankapp-0.0.1-SNAPSHOT.jar /app/bank-app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/bank-app.jar"]
