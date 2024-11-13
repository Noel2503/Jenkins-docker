pipeline {
    agent any
    
    environment {
        // Define environment variables, such as the Docker image name
        DOCKER_REGISTRY = 'noel135/jenkins-docker'  // e.g., Docker Hub username or registry URL if needed
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your Git repository
                git branch: 'main', url: 'https://github.com/Noel2503/jenkins-nodejs.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Install Node.js version if needed, or use pre-installed
                script {
				    sh 'npm install'
                }
            }
        }
        stage('Build Application') {
            steps {
                // Run npm build command to build the application
                script {
				    sh 'npm run build'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build Docker image from Dockerfile in the current directory
                script {
                    docker.build("${DOCKER_REGISTRY}:latest")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-credential') {  // 'docker-credentials-id' should be replaced with your Jenkins Docker credentials ID
                        docker.image("${DOCKER_REGISTRY}:latest").push()
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup workspace and Docker resources if needed
            cleanWs()
        }
    }
}
