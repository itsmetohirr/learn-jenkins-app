pipeline {
    agent any

    environment {
        EC2_HOST = 'root@ec2-3-82-226-77.compute-1.amazonaws.com'
        SSH_KEY = 'ec2-ssh-key'
        APP_DIR = '/root/project'
        REPO_URL = 'https://github.com/itsmetohirr/learn-jenkins-app.git'
    }

    stages {
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
}