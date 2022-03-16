AWS_REGION=us-west-2
CLUSTER_NAME=production
RELEASE=coredns
CHART=coredns/coredns
VALUES=coredns/prod/values.yaml
NS=kube-system

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
