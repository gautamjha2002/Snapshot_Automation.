pipeline {
    agent any
    stages {
        stage('Creating Node') {
            steps {
                script {
                    echo "Initializing The Terraform"
                    sh 'terraform init'
                    echo "Applying The Configuration"
                    sh "terraform apply -auto-approve -var=\"api_token=${params.LINODE_ACCESS_TOKEN}\""
                    sh 'terraform output -raw public_ip > serverIP.txt' // Directly save IP to file
                    stash name: 'IPStash', includes: 'serverIP.txt'
                    sh 'terraform destroy -auto-approve' 
                }
            }
        }
        stage('Mounting Volume To the Instance') {
            steps {
                script {
                    unstash 'IPStash'
                    def serverIP = readFile('serverIP.txt').trim()
                    echo "${serverIP}"
                    // Continue with your remaining steps
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
