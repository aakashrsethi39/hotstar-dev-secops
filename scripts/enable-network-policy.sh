#!/usr/bin/env bash
set -euo pipefail

kubectl get ds aws-node -n kube-system -o json |
jq '{
  spec: {
    template: {
      spec: {
        containers: [
          .spec.template.spec.containers[]
          | select(.name == "aws-eks-nodeagent")
          | {
              name,
              args: [
                .args[]
                | if startswith("--enable-network-policy=")
                  then "--enable-network-policy=true"
                  else .
                  end
              ]
            }
        ]
      }
    }
  }
}' | kubectl patch ds aws-node -n kube-system \
  --type=strategic --patch-file=/dev/stdin

kubectl rollout status ds/aws-node \
  -n kube-system --timeout=300s
