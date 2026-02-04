pipeline {
    agent any

     environment {
        IMAGE_NAME = 'my_nginximage'
        IMAGE_TAG  ='v1'
        DOCKER_USER = 'archanaadmin02'
        CHART_NAME="nginx-app"
        CHART_PATH="./nginx-app/"
        RELEASE_NAME="nginx"
        NAMESPACE="nginx"
      }
      
    stages {
     stage('Clone repo') {
       steps {
         sh 'rm -rf Nginx-app-deployment'
         sh 'echo "Cloning a repo..."'
         sh 'git clone https://github.com/archanak0210/Nginx-app-deployment.git'
       }
     }
     
      stage('Build Docker Image') {
         steps {
           sh """
             echo "--- Checking Docker Access ---"
             id
             whoami
             groups
             ls -l /var/run/docker.sock

             echo "---- Building the Docker Image ---"
             cd Nginx-app-deployment
             docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f Dockerfile .
           """
        }
      }

      stage('Docker Login & Push') {
        steps {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh """
              echo "--- Logging into Docker Hub ---"
              echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

              echo "---Tagging and Pushing Image ---"
              docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
              docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
              echo "Docker image ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} pushed successfully!"
            """
           }
         }
       }
        
       stage('Deploy to Kubernetes') {
          steps {
             sh """
               echo "---Deploying image using Helm ---"
               sudo kubectl create ns ${NAMESPACE}
               sudo export CHART_PATH="./nginx-app/"
               sudo helm lint $CHART_PATH
               sudo helm package $CHART_PATH
               sudo helm install ${RELEASE_NAME} ${CHART_NAME} -n ${NAMESPACE}
        """
         }
      }   
      stage('Verify Deployment') {
          steps {
            sh """
                echo "---Verifying deployment---"
                sudo kubectl rollout status deployment/${RELEASE_NAME} -n ${NAMESPACE}
                sudo kubectl get pods -n ${NAMESPACE}
                sudo kubectl get svc -n ${NAMESPACE}
                sudo curl http://192.168.49.2:30008
                echo "---application access outside of cluster"
                sudo kubectl port-forward service/nginx-service -n ${NAMESPACE} 30008:80
            """            
             }
          }
      }
  }
