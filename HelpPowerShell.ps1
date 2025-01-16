$kubernetesVersion = "1.30"
$jsonOutput = eksctl utils describe-addon-versions --kubernetes-version $kubernetesVersion 
#  eksctl utils describe-addon-versions --kubernetes-version 1.29
$jsonOutput > result.json
# Set-Content -Path result.json -Value $jsonOutput


# aws eks update-kubeconfig --name prod-cluster
# kubectl port-forward svc/nginx-service 8080:80

#Removing old version nodes and moving pods to new nodes
#1. kubectl cordon <old-node-name>
#2. kubectl drain <old-node-name> --ignore-daemonsets --delete-emptydir-data
#3. kubectl get pods -o wide
#4. kubectl delete node <old-node-name>
#5. kubectl uncordon <node-name> 
