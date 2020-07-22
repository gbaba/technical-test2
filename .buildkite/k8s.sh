#!/bin/bash

set -eo pipefail

aws eks --region us-east-2 update-kubeconfig --name $CLUSTER_NAME

pushd .k8s
kubectl apply -f ns.yaml
sed -i "s/appversion/$BUILDKITE_BUILD_NUMBER/g" $ENV/deployment.yaml

for schema in service deployment; do
  kubectl apply -f $ENV/${schema}.yaml
done

echo $ENV endpoint, please use the below script to validate
if [ $ENV = dev ]
then
    echo curl -silent $(kubectl get service technical-test2-service-devlopment -n technical-test2 -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80/version
else
    echo curl -silent $(kubectl get service technical-test2-service-prod -n technical-test2 -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80/version
fi
