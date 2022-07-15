AWS_REGION=us-west-2
CLUSTER_NAME=production
VALUES=traefik/dev/values.yaml
RELEASE=traefik
CHART=traefik/traefik
NS=default

helm upgrade $RELEASE $CHART -f $VALUES -i -n $NS
