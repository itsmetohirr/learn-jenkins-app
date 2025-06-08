pipeline {
    agent any

    environment {
        EC2_HOST = 'ec2-3-82-226-77.compute-1.amazonaws.com'
        SSH_KEY = 'ec2-ssh-key' // Jenkins credential ID (SSH private key)
        APP_DIR = '/home/ubuntu/project'
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

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ["${SSH_KEY}"]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_HOST} << 'EOF'
                        rm -rf ${APP_DIR}
                        git clone ${REPO_URL} ${APP_DIR}
                        cd ${APP_DIR}
                        npm install
                        npm start
                    EOF
                    """
                }
            }
        }
    

    }
}