pipeline {
    agent { label 'node1' }
    triggers { pollSCM '* * * * *' }
    parameters {  
                 choice(name: 'maven_goal', choices: ['install','package','clean install'], description: 'build the code')
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
              }
            }
          }
          stage("Quality Gate") {
            steps {
              timeout(time: 30, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
          }

        stage ('Artifactory configuration') {
            steps {
                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "jfrog-id",
                    releaseRepo: "naveen-libs-release-local",
                    snapshotRepo: "naveen-libs-snapshot-local"
                )
            }
        }
        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: "MAVEN-3.6.3", // Tool name from Jenkins configuration
                    pom: "pom.xml",
                    goals: "${params.maven_goal}",
                    deployerId: "MAVEN_DEPLOYER"
                )
                stash includes: "{$worksoace}/target/*.jar" , name: 'tostage'
            }
            
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "jfrog-id"
                )
            }
        }
        stage ('docker') {
        agent { label 'node2' } 
              environment { 
                AN_ACCESS_KEY = credentials('jfrogrep_cred')
           }
           steps {
             dir("{$workspace}/target/"){
                      unstash 'tostage'
                      }
              sh 'docker image build -t spcdev:1.0 .'
              sh 'docker image tag spcdev:1.0 pdpk8s.jfrog.io/dockerimages/spcdev:1.0'
              sh 'docker image push pdpk8s.jfrog.io/dockerimages/spcdev:1.0 '
            }  
        }
    }
}
