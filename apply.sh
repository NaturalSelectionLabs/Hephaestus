AWS_REGION=us-west-2
CLUSTER_NAME=production
RELEASE=traefik
CHART=traefik/traefik
VALUES=traefik/prod/values.yaml
NS=default

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
