pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'echo "Without Docker"'
            }
        }

        stage('with docker') {
            agent {
                docker {
                    image 'node:18-alpine'
                }
            }
            steps {
                sh 'echo "With Docker"'
                sh 'nmp --version'
            }
            }
    }
}