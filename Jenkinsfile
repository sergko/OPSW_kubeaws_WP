pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'export GOPATH=/var/lib/jenkins/go'
        sh 'make build'
        sh 'sudo cp ./bin/kube-aws /usr/bin'
      }
    }
    stage('kube-aws init') {
      steps {
        sh '''kube-aws init \\
--cluster-name=my-$KUBE_CLUSTER_NAME \\
--region=eu-west-2 \\
--availability-zone=eu-west-2a \\
--key-name=sergey.k \\
--kms-key-arn="arn:aws:kms:eu-west-2:717986625066:key/6db2ca6d-f86b-42c2-8ab2-4d2416d15a0d" \\
--s3-uri=s3://kube-aws-ops-bucket \\
--external-dns-name=kube-aws-ops-cluster \\
--hosted-zone-id=ZZRMO7GMYBUIP'''
      }
    }
  }
}