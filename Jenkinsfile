pipeline {
  agent any
  stages {
    stage('kube-aws install') {
      steps {
        sh 'test -f "./kube-aws-linux-amd64.tar.gz" || wget https://github.com/kubernetes-incubator/kube-aws/releases/download/v0.10.0/kube-aws-linux-amd64.tar.gz
        sh 'test -d "./linux-amd64" || tar -xf kube-aws-linux-amd64.tar.gz
        sh 'sudo cp ./linux-amd64/kube-aws /usr/bin'
      }
    }
    stage('kube-aws init') {
      steps {
        sh '''kube-aws init \\
	--cluster-name=kube-sm3 \\
	--region=eu-west-2 \\
	--availability-zone=eu-west-2a \\
	--key-name=sergey.k \\
	--kms-key-arn="arn:aws:kms:eu-west-2:717986625066:key/6db2ca6d-f86b-42c2-8ab2-4d2416d15a0d" \\
	--s3-uri=s3://kube-aws-ops-small-bucket \\
	--external-dns-name=kube-aws-ops-sm3-cluster.zeolan.pp.ua \\
	--hosted-zone-id=ZZRMO7GMYBUIP'''
        sh 'sed -i -e \'s/#workerInstanceType: t2.medium/workerInstanceType: t2.small/g\' cluster.yaml '
        sh '''sed -i -e \'/#      # EC2 instance tags for worker nodes/i\      instanceType: t2.small\' cluster.yaml'''
        sh '''sed -i -e \'/#etcd:/i\etcd:\n  instanceType: t2.small\' cluster.yaml'''
        sh '''sed -i -e \'/#controller:/i\controller:\n  instanceType: t2.small\' cluster.yaml'''
        sh 'kube-aws render credentials --generate-ca'
        sh 'kube-aws render stack'
        sh 'kube-aws validate'
      }
    }
    stage('kube start') {
      steps {
        sh 'kube-aws up'
        sh 'kubectl --kubeconfig=kubeconfig get nodes'
        sh 'kubectl --kubeconfig=kubeconfig get rc'
        sh 'kubectl --kubeconfig=kubeconfig get pods'
      }
    }
  }
}