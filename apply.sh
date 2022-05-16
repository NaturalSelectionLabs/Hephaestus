AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=jaeger/prod/values.yaml
RELEASE=jaeger
CHART=jaegertracing/jaeger
NS=guardian

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
