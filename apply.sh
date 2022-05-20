AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=exporters/rabbitmq/values.yaml
RELEASE=rabbitmq-exporter
CHART=prometheus-community/prometheus-rabbitmq-exporter
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
