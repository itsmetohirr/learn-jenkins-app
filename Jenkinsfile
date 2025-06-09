pipeline {
    agent any

    environment {
        EC2_HOST = 'ubuntu@ec2-3-82-226-77.compute-1.amazonaws.com'
        SSH_KEY = 'ec2-ssh-key'
        APP_DIR = '/home/ubuntu/project'
        REPO_URL = 'https://github.com/itsmetohirr/learn-jenkins-app.git'
    }

    stages {
        stage('Install Docker on EC2 (Ubuntu)') {
            steps {
                sshagent (credentials: ["${SSH_KEY}"]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_HOST} << 'EOF'
                        if ! command -v docker &> /dev/null; then
                            echo "Installing Docker..."
                            sudo apt update -y
                            for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
                            
                            # Add Docker's official GPG key:
                            sudo apt-get update
                            sudo apt-get install ca-certificates curl
                            sudo install -m 0755 -d /etc/apt/keyrings
                            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                            sudo chmod a+r /etc/apt/keyrings/docker.asc

                            # Add the repository to Apt sources:
                            echo \
                            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                            \$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
                            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                            sudo apt-get update
                            
                            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                        else
                            echo "Docker is already installed"
                        fi
                    EOF
                    """
                }
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
                        docker build -t my-node-app .
                        docker run -d -p 3000:3000 --name my-node-container my-node-app
                        npm install
                        npm start
                    EOF
                    """
                }
            }
        }
    }
}