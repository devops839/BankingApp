pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git_Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/devops839/BankingApp.git'
            }
        }
        stage('Trivy_FS_Scan') {
            steps {
                sh 'trivy fs . --format table -o trivy-fs-report.json'
            }
        }
        stage('Maven_Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Maven_Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('SonarQube_Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=bank-app -Dsonar.projectKey=bank-app -Dsonar.java.binaries=."
                }
            }
        }
        stage ('Sonar_QualityGate') {
            steps {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-cred'
            }
        }
        stage ('Maven_Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage ('Docker_Build') {
            steps {
                 sh 'docker build -t bankapp .'
            }
        }
        stage('Trivy_Image_Scan') {
            steps {
                sh 'trivy image --format table -o trivy-image-report.json bankapp:latest'
            }
        }
        stage ('Docker_Run') {
            steps {
                 sh 'docker run -d -p 8008:8080 --name bank-container bankapp:latest'
            }
        }
    }
}
