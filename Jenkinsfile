pipeline {
  agent any
  stages {
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