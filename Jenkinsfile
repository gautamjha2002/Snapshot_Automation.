pipeline {
    parameters {
        string(name: "LINODE_ACCESS_TOKEN", defaultValue: "", trim: true, description: "Provide Linode cloud Access Token")
        string(name: "MAINNET_STAPSHOT_URL", defaultValue: "", trim: true, description: "Provide Snapshot URL for Mainnet")
        string(name: "TESTNET_STAPSHOT_URL", defaultValue: "", trim: true, description: "Provide Snapshot URL for Testnnet")
        string(name: "AWS_ACCESS_KEY", defaultValue: "", trim: true, description: "S3 Access Key")
        password(name: "AWS_SECRET_KEY", defaultValue: "", description: "s3 Secret key")
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
                    sh "sleep 30"
                    unstash 'IPStash'
                    def serverIP = readFile('serverIP.txt').trim()
                    echo "${serverIP}"
                    sh "ansible-playbook -i '${serverIP},' mount_volume.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f\""
                }
            }
        }

        stage('Deploying Avalanche Mainnet Protocol') {
            steps {
                script {
                    def serverIP = readFile('serverIP.txt').trim()
                    sh "ansible-playbook -i '${serverIP},' deploy_mainnet_avax.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f mainnet_snapshot_url=${params.MAINNET_STAPSHOT_URL}\""

                }
            }
        }

        stage('Creat Snapshot and upload to S3 Bucket - Mainnet') {
            steps {
                script {
                    def serverIP = readFile('serverIP.txt').trim()
                    sh "ansible-playbook -i '${serverIP},' create_snapshot.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f aws_access_key_id=${params.AWS_ACCESS_KEY} aws_secret_key=${params.AWS_SECRET_KEY} network=mainnet\""
                }
            }
        }

        stage('Deploying Avalanche Testnet Protocol') {
            steps {
                script {
                    def serverIP = readFile('serverIP.txt').trim()
                    sh "ansible-playbook -i '${serverIP},' deploy_testnet_avax.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f testnet_snapshot_url=${params.TESTNET_STAPSHOT_URL}\""

                }
            }
        }

        stage('Creat Snapshot and upload to S3 Bucket - Testnet') {
            steps {
                script {
                    def serverIP = readFile('serverIP.txt').trim()
                    sh "ansible-playbook -i '${serverIP},' create_snapshot.yml -u root --extra-vars \"ansible_ssh_pass=mLGCTk5gV&+f aws_access_key_id=${params.AWS_ACCESS_KEY} aws_secret_key=${params.AWS_SECRET_KEY} network=testnet\""
                }
            }
        }

        stage('Destroying Infra') {
            steps {
                sh 'terraform destroy -lock=false -auto-approve -var=api_token=${params.LINODE_ACCESS_TOKEN}' 
                echo "Destroying Infra"
            }
        }
    }
}
