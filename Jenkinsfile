pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT = 'false'
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -input=false -no-color'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform validation and planning successful.'
        }

        failure {
            echo 'Terraform pipeline failed. Review console output.'
        }

        always {
            deleteDir()
        }
    }
}
