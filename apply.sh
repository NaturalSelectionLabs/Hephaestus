AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=loki/prod/values.yaml
RELEASE=loki
CHART=grafana/loki-stack
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
