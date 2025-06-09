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

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ["${SSH_KEY}"]) {
                    sh """
ssh -o StrictHostKeyChecking=no ${EC2_HOST} << EOF
rm -rf ${APP_DIR}
git clone ${REPO_URL} ${APP_DIR}
cd ${APP_DIR}

sudo docker stop my-node-container || true
sudo docker rm my-node-container || true
sudo docker build -t my-node-app .
sudo docker run -d -p 3000:3000 --name my-node-container my-node-app
EOF
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                def status = currentBuild.currentResult
                def duration = currentBuild.durationString
                def buildId = env.BUILD_ID
                def buildUrl = env.BUILD_URL
                def jobName = env.JOB_NAME
                def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss", TimeZone.getTimeZone("UTC"))

                def branch = env.GIT_BRANCH ?: "N/A"
                def commit = env.GIT_COMMIT ?: "N/A"

                def message = """
                            📣 Jenkins Build Notification
                            ──────────────────────────────
                            🔖 Job:        ${jobName}
                            🔢 Build ID:   ${buildId}
                            🌐 URL:        ${buildUrl}
                            🕒 Time:       ${timestamp} UTC
                            ⏱ Duration:   ${duration}
                            🌿 Branch:     ${branch}
                            🔨 Commit:     ${commit}
                            📦 Status:     ${status}
                            """
            }
        }
    }
}
