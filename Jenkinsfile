pipeline {
    agent { label 'REDHAT-NODE' }
    stages{
        stage('git') {
            steps {
                git branch: 'ppm2', 
                url: 'https://github.com/Nagaraju11111/spring-petclinic.git'
            }
        }
        stage('build')  {
            steps {
                sh 'mvn package'
            }
        }
        stage('test results') {
            steps {
               junit testResults: '**/surefire-reports/*.xml'
        }
            }
        stage('archive artifacts') {
            steps {
                archiveArtifacts '**/target/*.jar'
            }
        }   
            
        }
    }
