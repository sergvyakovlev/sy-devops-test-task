#!/bin/bash
###
# Redeploy POD to minikube
###
eval $(minikube docker-env)
#docker build --tag webservice:local . --no-cache

# For MacOS
pkill -f "port-forward svc/webservice"
pkill -f "port-forward svc/redis"

# Better to have some container tag version `helm upgrade go-app chart --set 'containers.webservice=webservice:$TAG_VERSION'`
# But as a shortcut will do:
helm uninstall go-app
helm install go-app chart

# Better to have some logic based on `kubectl get pods -l app=webservice`
# But as a shortcut will do:
/bin/sleep 30

# For MacOS
nohup kubectl port-forward svc/webservice 8080:8080 > /dev/null 2>&1 &
nohup kubectl port-forward svc/redis 6379:6379 > /dev/null 2>&1 &
/bin/sleep 5

echo "<===Trying minikube health check===>"
/bin/bash ./monitoring/minikube-health.sh
