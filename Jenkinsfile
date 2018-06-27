pipeline {

  agent any

  options {
    ansiColor('xterm')
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10')) // only keep artifacts of the last 10 builds
  }

  stages {
    stage('Build gem') {
      steps {
        sh "bnw_runner./_pipeline/step_build_gem.sh"
      }
    }
  }
}
