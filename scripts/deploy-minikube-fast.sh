#!/usr/bin/env bash

# Notices:
# to apply changes, we need to manually delete pods, which contains affected images

export NGINX_IMAGE=teachbot/teachbot_nginx
       APP_IMAGE=teachbot/teachbot_app
       WORKER_IMAGE=teachbot/teachbot_worker

docker build -t ${NGINX_IMAGE} -f docker/nginx/Dockerfile .
docker build -t ${APP_IMAGE} -f docker/web/Dockerfile .
docker build -t ${WORKER_IMAGE} -f docker/worker/Dockerfile .

echo "Set updated containers to pods"
kubectl set image deployment/web nginx=${NGINX_IMAGE}
kubectl set image deployment/web app=${APP_IMAGE}
kubectl set image deployment/worker worker=${WORKER_IMAGE}

# delete pods to apply changes
kubectl delete pod -l sub=web
kubectl delete pod -l sub=worker