pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'make build'
        sh 'sudo cp ./bin/kube-aws /usr/bin'
      }
    }
    stage('kube-aws init') {
      steps {
        sh '''kube-aws init \\
--cluster-name=kube-small \\
--region=eu-west-2 \\
--availability-zone=eu-west-2a \\
--key-name=sergey.k \\
--kms-key-arn="arn:aws:kms:eu-west-2:717986625066:key/6db2ca6d-f86b-42c2-8ab2-4d2416d15a0d" \\
--s3-uri=s3://kube-aws-ops-small-bucket \\
--external-dns-name=kube-aws-ops-small-cluster.zeolan.pp.ua \\
--hosted-zone-id=ZZRMO7GMYBUIP'''
        sh 'sed -i -e \'s/#workerInstanceType: t2.medium/workerInstanceType: t2.small/g\' cluster.yaml '
        sh '''sed -i \'/#controller:/i \\
controller:\\
  instanceType: t2.small\' cluster.yaml'''
        sh 'kube-aws render credentials --generate-ca'
        sh 'kube-aws render stack'
        sh 'kube-aws validate'
      }
    }
    stage('kube start') {
      steps {
        sh 'kube-aws up'
      }
    }
  }
}