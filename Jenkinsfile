pipeline {
    agent { label 'node1' }
    triggers { pollSCM '* * * * *'  }
    parameters {  
                 choice(name: 'maven_goal', choices: ['install','package'], description: 'build the code')
                 choice(name: 'branch_to_build', choices: ['main', 'dev', 'ppm'], description: 'choose build')
                }
    
    stages {
        stage ('vcs') {
            steps {
                mail subject: "Build started for spc JOB $env.JOB_NAME",
                      body: "Build started for spc JOB $env.JOB_NAME with build id $env.BUILD_ID",
                      to: "devops@gmail.com"
                git branch: 'main', url: "https://github.com/spring-projects/spring-petclinic.git"
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
                    serverId: "JFROG_PRACTICE",
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
    post {
        always {
            mail subject: "Build completed for spc JOB $env.JOB_NAME",
                 body: "Build completed for spc JOB $env.JOB_NAME \n click here: $env.JOB_URL",
                 to: "devops@gmail.com"
        }
        failure {
            mail subject: "Build failed for spc JOB $env.JOB_NAME",
                 body: "Build failed for spc JOB $env.JOB_NAME with build id $env.BUILD_ID",
                 to: "devops@gmail.com"
        }
        success {
            junit testResults: '**/target/surefire-reports/*.xml'
        }
    }
}
