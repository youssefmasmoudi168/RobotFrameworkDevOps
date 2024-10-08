pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          resources:
            requests:
              memory: 50Mi
              cpu: 50m
          priorityClassName: high-priority
          serviceAccountName: jenkins-admin
          containers:
          - name: robot
            image: rapidfort/python-chromedriver
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          - name: kubectl
            image: bitnami/kubectl:latest
            securityContext:
              runAsUser: 1000
            command:
            - "sleep"
            args:
            - "99d"
            tty: true
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock    
        '''
    }
  }
  stages {
    stage('Clone') {
      steps {
        container('robot') {
          git branch: 'main', credentialsId: 'git-cred', url: 'https://gitlab.com/youssefmasmoudi16/robot_tests.git'
        }
      }
    }  
    stage('robot-tests') {
      steps {
        container('robot') {
          sh 'pip install -r requirements.txt'
          sh 'python demoapp/server.py &'
          sh 'robot --outputdir ./reports login_tests'
        }
      }
      post {
        always {
          archiveArtifacts artifacts: 'reports/*', followSymlinks: false
        }
      }
    }
    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh 'docker build -t youssefmasmoudi/myserver:latest .'
        }
      }
    }
    stage('Login-Docker') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'password', usernameVariable: 'user')]) {
            sh 'docker login -u ${user} -p ${password}'
           }
        }
      }
    }
    stage('Push-Images-Docker-to-DockerHub') {
      steps {
        container('docker') {
          sh 'docker push youssefmasmoudi/myserver:latest'
        }
      }
    }
    stage('Update Kubernetes Deployment') {
      steps {
         container('kubectl') {
           sh 'kubectl set image deployment/myserver-deployment myserver=youssefmasmoudi/myserver:latest -n myapp'
         }
       }
     }
  }

  post {
    always {
      container('docker') {
        sh 'docker logout'
      }
    }
  }
}
