AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=prometheus/prod/values.yaml
RELEASE=prometheus
CHART=prometheus-community/prometheus
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
