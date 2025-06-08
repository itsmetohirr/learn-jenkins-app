pipeline {
    agent any

    environment {
        NODE_IMAGE = 'node:18'  // You can change the version
        CONTAINER_NAME = 'node-container'
    }

    stages {
        stage('Pull Node Docker Image') {
            steps {
                script {
                    echo "Pulling Node.js image: ${env.NODE_IMAGE}"
                    sh "docker pull ${env.NODE_IMAGE}"
                }
            }
        }

        stage('Run Node Container') {
            steps {
                script {
                    echo "Starting Node.js container"
                    sh "docker run -dit --name ${env.CONTAINER_NAME} ${env.NODE_IMAGE} bash"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Example: install `express` globally inside the container
                    echo "Installing npm packages inside the container"
                    sh "docker exec ${env.CONTAINER_NAME} npm install -g express"
                }
            }
        }
    }
}