AWS_REGION=us-west-2
CLUSTER_NAME=production
RELEASE=prometheus
CHART=prometheus-community/prometheus
VALUES=prometheus/prod/values.yaml
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
