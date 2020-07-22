#!/bin/bash

set -eo pipefail

aws eks --region us-east-2 update-kubeconfig --name $CLUSTER_NAME

pushd .k8s
kubectl apply -f ns.yaml
sed -i "s/appversion/$BUILDKITE_BUILD_NUMBER/g" $ENV/deployment.yaml

for schema in service deployment; do
  kubectl apply -f $ENV/${schema}.yaml
done