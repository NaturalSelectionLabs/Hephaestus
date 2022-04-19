AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=metrics-server/prod/values.yaml
RELEASE=metrics-server
CHART=metrics-server/metrics-server
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
