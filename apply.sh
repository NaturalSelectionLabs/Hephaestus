AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=traefik-mesh/prod/values.yaml
RELEASE=traefik-mesh
CHART=traefik-mesh/traefik-mesh
NS=default

aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
