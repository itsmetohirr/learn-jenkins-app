pipeline {
    agent any

    stages {
        
        stage("stage1") {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh 'echo "Hey there"'
            }
        }
    }
}