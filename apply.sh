AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=exporters/pgsql/values.yaml
RELEASE=pg-exporter
CHART=prometheus-community/prometheus-postgres-exporter
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
