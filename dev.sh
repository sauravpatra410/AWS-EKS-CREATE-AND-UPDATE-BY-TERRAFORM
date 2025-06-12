#!/bin/bash

# Set Kubernetes version
kubernetesVersion="1.29"

# Run the eksctl command and save JSON output
eksctl utils describe-addon-versions --kubernetes-version "$kubernetesVersion" > dev.json
