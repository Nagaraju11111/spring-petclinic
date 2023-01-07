pipeline {
    agent { label 'node1' }
    triggers { pollSCM '* * * * *' }
    parameters {  
                 choice(name: 'maven_goal', choices: ['install','package'], description: 'build the code')
                 choice(name: 'branch_to_build', choices: ['main', 'dev', 'ppm'], description: 'choose build')
                }
    
    stages {
        stage ('vcs') {
            steps {
                git branch: 'dev', url: "https://github.com/spring-projects/spring-petclinic.git"
            }
        }
        stage("build & SonarQube analysis") {
            steps {
              withSonarQubeEnv('sonarqube-id') {
                sh "mvn ${params.maven_goal} sonar:sonar"
                 sh 'docker image build -t spc:1.0 .'
              }
            }
          }
        stage ('jfrog and docker') {
             environment { 
                AN_ACCESS_KEY = credentials('jfrogrep_cred') 
            }
            steps {
              sh 'docker image tag spc:1.0 pdpk8s.jfrog.io/dockerimages/spc:1.0'
              sh 'docker image push pdpk8s.jfrog.io/dockerimages/spc:1.0 '
            }
        }
    }
}
