pipeline {
    agent any
    parameters {
        string(name: "LINODE_ACCESS_TOKEN", defaultValue: "", trim: true, description: "Provide Linode cloud Access Token")
    }
    stages {
        stage('Creating Node') {
            steps {
                script {
                    echo "Initializing The Terraform"
                    sh 'terraform init'
                    echo "Applying The Configuration"
                    sh "terraform apply -auto-approve -var=\"api_token=${params.LINODE_ACCESS_TOKEN}\""
                    echo "Get The public IP of server"
                    def serverIP = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    stash name: 'IPStash', includes: 'serverIP'
                    sh 'terraform destroy -auto-approve' 
                }
            }
        }
        stage('Mounting Volume To the Instance') {
            steps {
                script {
                    def serverIP = unstash 'IPStash'
                    echo "${serverIP}"
                    // sh "ansible-playbook -i ${params.SERVER_IP} mount_volume.yml -u root --extra-vars 'ansible_ssh_pass=mLGCTk5gV&+f'"
                    // Consider using Jenkins credentials for the password
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