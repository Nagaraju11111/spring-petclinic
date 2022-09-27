pipeline {
    agent { label 'REDHAT-NODE && NODE' }
    stages{
        stage('vcs') {
            steps {
                git url: 'https://github.com/Nagaraju11111/spring-petclinic.git'
            }
        stage('build')  {
            steps {
                sh 'mvn package'
            }
        }
        stage('test results') {
            steps {
                '**/target/*.jar'
                '**/sure-fire reports/*.xml'
            }
        }   
        }
    }

}
