pipeline {
    agent any // or a specific agent with kubectl installed and configured
    stages {
        stage('Check K8s Connectivity') {
            steps {
                script {
                    try {
                        // Execute kubectl command to get namespaces and capture the output
                        def output = sh(script: 'sudo kubectl get namespaces', returnStdout: true).trim()
                        echo "Successfully connected to Kubernetes cluster."
                        echo "Namespaces found: ${output}"
                    } catch (Exception e) {
                        // Handle the error if the command fails
                        echo "Failed to connect to Kubernetes cluster or execute kubectl command."
                        echo "Error: ${e.getMessage()}"
                        // Fail the stage explicitly if needed
                        // error "Kubernetes connectivity test failed."
                    }
                }
            }
        }
    }
}
