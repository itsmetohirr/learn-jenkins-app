pipeline {
    agent any

    environment {
        EC2_HOST = 'root@ec2-3-82-226-77.compute-1.amazonaws.com'
        SSH_KEY = 'ec2-ssh-key'
        APP_DIR = '/root/project'
        REPO_URL = 'https://github.com/itsmetohirr/learn-jenkins-app.git'
    }

    stages {
        stage("Build") {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f build/index.html
                    npm test
                '''
            }
        }
    }

    post {
        always {
            emailext (
                subject: "Pipeline Status: ${BUILD_NUMBER}",
                body: '''
                    <html>
                        <body>
                            <p>Build Status: ${BUILD_STATUS}</p>
                            <p>Build Number: ${BUILD_NUMBER}</p>
                            <p>Check the <a href="${BUILD_STATUS}">console output</a></p>
                        </body>
                    </html>
                ''',
                to: "itsmetohir@gmail.com",
                from: "itsmetohir@gmail.com"
            )
        }
    }
}
