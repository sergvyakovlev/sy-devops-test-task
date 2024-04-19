#!/bin/bash

###
# Go-app minikube health check for MacOS
###
# Assume that redis-cli and curl are available. `brew install redis-cli curl`
# kubectl port-forward svc/webservice 8080:8080 # Available by port on localhost
# kubectl port-forward svc/redis 6379:6379 # Available by port on localhost
EXPECTED_HTTP_CODE=200
EXPECTED_REDIS_RESPONCE='updated_time'

HTTP_CODE=$(curl -X GET -s -o /dev/null -I -w "%{http_code}" http://localhost:8080)
if [ "$HTTP_CODE" == $EXPECTED_HTTP_CODE ]; then
    echo "HTTP Server GET response: $EXPECTED_HTTP_CODE"
    REDIS_SCAN=$(redis-cli --scan 2>&1)
    if [ "$REDIS_SCAN" == $EXPECTED_REDIS_RESPONCE ]; then
        echo "The entity $REDIS_SCAN in redis exists."
        kubectl top pods -l app=webservice
        kubectl top pods -l app=redis
    else
        echo "The entity $EXPECTED_REDIS_RESPONCE in redis NOT available."
        echo "Details: $REDIS_SCAN"
    fi
else
    echo "HTTP Server GET response is: $HTTP_CODE"
    echo "Header details:"
    curl -X GET -I http://localhost:8080
fi
