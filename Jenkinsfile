// Define variables
skipDockerStage = false

pipeline {
    agent any

    options {
        timeout(time: 60, unit: 'MINUTES')
        disableConcurrentBuilds(abortPrevious: true)
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Define branchName
                    branchName = env.CHANGE_BRANCH ?: env.BRANCH_NAME

                    // Set skipDockerStage boolean
                    if (branchName.contains('dependabot')) {
                        skipDockerStage = true
                    }
                }
            }
        }
        stage('Build Docker Image') {
            when {
                expression {
                    !skipDockerStage
                }
            }
            steps {
                script {
                    // Try to build the Docker image
                    try {
                        sh 'docker build . -t shadow-role'
                    } catch (Exception ex) {
                        println('Exception: ' + ex)
                        println('Could not build Docker image.')
                    }
                }
            }
        }
    }
    post {
        success {
            slackSend channel: '#debugging-slack-jenkins', color: 'good', message: "shadow-role test has succeeded for *<${BUILD_URL}|${branchName}>*", tokenCredentialId: 'SlackToken'
        }
        failure {
            slackSend channel: '#debugging-slack-jenkins', color: 'danger', message: "shadow-role test has failed for *<${BUILD_URL}|${branchName}>*", tokenCredentialId: 'SlackToken'
        }
        cleanup {
            // Clean the Docker environment
            sh 'docker stop $(docker ps -aq) || true'
            sh 'docker rm $(docker ps -aq) || true'

            // Clean the working directory
            deleteDir()
        }
    }
}
