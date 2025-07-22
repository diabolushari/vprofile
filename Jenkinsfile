pipeline {
    agent any
    options {
        // Adds timestamps to console logs
        timestamps()
    }

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk'
        GIT_CREDENTIALS_ID = '43d1fe7b-7f7f-4cc5-a16c-2c2c0aede42c'
        TARGET_REPO = 'https://github.com/diabolushari/petclinic_artifacts.git'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: env.GIT_CREDENTIALS_ID, url: 'https://github.com/diabolushari/petclinic.git', branch: 'main'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh './gradlew clean test'
            }
        }

        stage('Package with Timestamp') {
            steps {
                script {
                    def ts = new Date().format("yyyyMMdd-HHmmss", TimeZone.getDefault())
                    env.BUILD_TIMESTAMP = ts
                    sh "./gradlew build -x test -Pversion=${ts}"
                }
            }
        }

        stage('Push Artifact to Git') {
            steps {
                script {
                    def ts = env.BUILD_TIMESTAMP
                    def artifact = sh(script: "ls build/libs/*.jar | head -1", returnStdout: true).trim()
                    sh """
                        rm -rf artifact-repo
                        git clone https://${GIT_CREDENTIALS_ID}@${TARGET_REPO.replace('https://','')} artifact-repo
                        cp ${artifact} artifact-repo/petclinic-${ts}.jar
                        cd artifact-repo
                        git add .
                        git commit -m "Artifact built at ${ts}"
                        git push origin main
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build & push completed with timestamp: ${env.BUILD_TIMESTAMP}"
        }
        failure {
            echo "❌ Build failed – check console output!"
        }
    }
}
