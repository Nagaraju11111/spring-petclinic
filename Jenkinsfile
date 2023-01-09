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
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "jfrog-id"
                )
            }
        }
    }
}
