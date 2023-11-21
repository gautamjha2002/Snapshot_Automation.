pipeline {
    parameters {
        string(name: "LINODE_ACCESS_TOKEN", defaultValue: "", trim: true, description: "Provide Linode cloud Access Token")
    }
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
                    
                }
            }
        }
        stage('Mounting Volume To the Instance') {
            steps {
                script {
                    unstash 'IPStash'
                    def serverIP = readFile('serverIP.txt').trim()
                    echo "${serverIP}"
                    sh "ansible-playbook -i '${serverIP},' mount_volume.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f\""
                }
            }
        }
        stage('Destroying Infra') {
            steps {
                // sh 'terraform destroy -auto-approve -var=api_token=${params.LINODE_ACCESS_TOKEN}' 
                echo "Destroying Infra"
            }
        }
    }
}
