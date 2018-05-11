pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'echo $WORKSPACE'
        sh 'export GOPATH=$HOME/go'
        sh 'echo $GOPATH'
        sh 'ln -sf $WORKSPACE  $GOPATH/src/github.com/kubernetes-incubator/kube-aws'
        sh 'make build'
      }
    }
    stage('kube-aws init') {
      steps {
        sh '''KUBE_CLUSTER_NAME=kube_clust
kube-aws init \\
--cluster-name=my-$KUBE_CLUSTER_NAME \\
--region=eu-west-2 \\
--availability-zone=eu-west-2a \\
--key-name=sergey.k \\
--kms-key-arn="arn:aws:kms:eu-west-2:717986625066:key/6db2ca6d-f86b-42c2-8ab2-4d2416d15a0d"'''
      }
    }
  }
}