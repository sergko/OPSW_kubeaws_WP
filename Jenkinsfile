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
--cluster-name=kube-sm3 \\
--region=eu-west-2 \\
--availability-zone=eu-west-2a \\
--key-name=sergey.k \\
--kms-key-arn="arn:aws:kms:eu-west-2:717986625066:key/6db2ca6d-f86b-42c2-8ab2-4d2416d15a0d" \\
--s3-uri=s3://kube-aws-ops-small-bucket \\
--external-dns-name=kube-aws-ops-sm3-cluster.zeolan.pp.ua \\
--hosted-zone-id=ZZRMO7GMYBUIP'''
        sh 'sed -i -e \'s/#workerInstanceType: t2.medium/workerInstanceType: t2.small/g\' cluster.yaml '
        sh '''sed -i -e \'/#      # EC2 instance tags for worker nodes/i \\
      instanceType: t2.small\' cluster.yaml'''
        sh '''sed -i -e \'/#etcd:/i \\
etcd:\\
  instanceType: t2.small\' cluster.yaml'''
        sh '''sed -i -e \'/#controller:/i \\
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
        sh 'kubectl --kubeconfig=kubeconfig get nodes'
        sh 'kubectl --kubeconfig=kubeconfig get rc'
        sh 'kubectl --kubeconfig=kubeconfig get pods'
      }
    }
    stage('deploy wp2k8s') {
      steps {
        sh 'kubectl --kubeconfig=kubeconfig create -f deployment-wordpress.yaml'
        sh 'kubectl --kubeconfig=kubeconfig create -f service-wordpress.yaml'
        sh 'kubectl --kubeconfig=kubeconfig describe service wordpress'
        sh '''NS=$NULL
until [ $NS ]
do
NS=`kubectl --kubeconfig=kubeconfig describe service wordpress \
| grep "LoadBalancer Ingress:" | awk '{ print $3 }'`
sleep 5
done
kubectl --kubeconfig=kubeconfig describe service wordpress
sed -i -e \'s/route53replacement/\'$NS\'/g\' route53-wordpress.json
cat route53-wordpress.json'''
        sh 'aws route53 change-resource-record-sets --hosted-zone-id ZZRMO7GMYBUIP --change-batch file://route53-wordpress.json'
        sh 'kubectl --kubeconfig=kubeconfig get rc'
        sh 'kubectl --kubeconfig=kubeconfig get pods'
      }
    }
  }
}