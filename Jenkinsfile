pipeline {
    agent any
    triggers { cron('H 23 * * *') }
    stages {
       stage('vcs') {
        steps {
            git url: 'git@github.com:Nagaraju11111/spring-petclinic.git',
                branch: 'ad'    
        }
       }
       stage ('Artifactory configuration') {
            steps {
                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "JFROG-AC",
                    releaseRepo: 'default-libs-release-local',
                    snapshotRepo: 'default-libs-snapshot-local'
                )
           }
        }
        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: 'MAVEN-3.6.3', // Tool name from Jenkins configuration
                    pom: 'pom.xml',
                    goals: 'clean package',
                    deployerId: "MAVEN_DEPLOYER"
                )
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "JFROG-AC"
                )
            }
        }
       
    }
}
