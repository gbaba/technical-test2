#!/bin/bash
set -e
. /buildkite-secrets/aws.anz

aws eks update-kubeconfig --name $CLUSTER_NAME

pushd .k8s
kubectl apply -f ns.yaml
sed "s/<container image>/$ECR:$BN/g" $ENV/deployment.yaml

for schema in service deployment; do
  kubectl apply -f ${schema}.yaml
done