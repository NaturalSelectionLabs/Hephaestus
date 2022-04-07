AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=exporters/redis/values.yaml
RELEASE=redis-exporter-pregod
CHART=prometheus-community/prometheus-redis-exporter
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
