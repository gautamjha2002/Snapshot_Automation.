pipeline {
    agent any
    parameters {
        string(name: "LINODE_ACCESS_TOKEN", defaultValue: "", trim: true, description: "Provide Linode cloud Access Token")
        string(name: 'SERVER_IP', defaultValue: '', description: 'The IP address of the server')
    }
    stages {
        stage('Creating Node') {
            steps {
                sh '''
                    echo "Initializing The Terraform"
                    terraform init
                    echo "Applying The Configuration"
                    terraform apply -auto-approve -var="api_token=$params.LINODE_ACCESS_TOKEN"
                    echo "Get The public IP of server"
                    def serverIP = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    echo "Passing Server Ip to Next Stage"
                    buildWithParameters([SERVER_IP: serverIP])
                '''
            }
        }
        stage('Mounting Volume To the Instance') {
            steps {
                sh 'ansible-playbook -i '${params.SERVER_IP},' mount_volume.yml -u root --extra-vars "ansible_ssh_pass=mLGCTk5gV&+f"'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}