#!/usr/bin/env bash

set -e

#export TRAVIS_COMMIT=1

echo "Set deploy envs"
export GOOGLE_APPLICATION_CREDENTIALS=./client-secret.json
       GCLOUD_PROJECT_ID=kubernetes-168515
       GCLOUD_CLUSTER_NAME=teachbot-staging
       CLOUDSDK_COMPUTE_ZONE=europe-west1-b

# local name
export LOCAL_NGINX_IMAGE_NAME=teachbot_nginx
       LOCAL_APP_IMAGE_NAME=teachbot_app
       LOCAL_WORKER_IMAGE_NAME=teachbot_worker

# gcloud name
export GCLOUD_NGINX_IMAGE_NAME=gcr.io/${GCLOUD_PROJECT_ID}/${LOCAL_NGINX_IMAGE_NAME}
       GCLOUD_APP_IMAGE_NAME=gcr.io/${GCLOUD_PROJECT_ID}/${LOCAL_APP_IMAGE_NAME}
       GCLOUD_WORKER_IMAGE_NAME=gcr.io/${GCLOUD_PROJECT_ID}/${LOCAL_WORKER_IMAGE_NAME}

echo "create tag reference with commit id on docker-compose images"
docker tag ${LOCAL_NGINX_IMAGE_NAME} ${GCLOUD_NGINX_IMAGE_NAME}:$TRAVIS_COMMIT
docker tag ${LOCAL_APP_IMAGE_NAME} ${GCLOUD_APP_IMAGE_NAME}:$TRAVIS_COMMIT
docker tag ${LOCAL_WORKER_IMAGE_NAME} ${GCLOUD_WORKER_IMAGE_NAME}:$TRAVIS_COMMIT

echo "Auth service account"
gcloud auth activate-service-account --key-file ${GOOGLE_APPLICATION_CREDENTIALS}

echo "Configure gcloud"
gcloud --quiet config set project $GCLOUD_PROJECT_ID
gcloud --quiet config set container/cluster $GCLOUD_CLUSTER_NAME
gcloud --quiet config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $GCLOUD_CLUSTER_NAME

echo "Push containers to gcloud"
gcloud docker -- push ${GCLOUD_NGINX_IMAGE_NAME}
yes | gcloud beta container images add-tag ${GCLOUD_NGINX_IMAGE_NAME}:$TRAVIS_COMMIT ${GCLOUD_NGINX_IMAGE_NAME}:latest

gcloud docker -- push ${GCLOUD_APP_IMAGE_NAME}
yes | gcloud beta container images add-tag ${GCLOUD_APP_IMAGE_NAME}:$TRAVIS_COMMIT ${GCLOUD_APP_IMAGE_NAME}:latest

gcloud docker -- push ${GCLOUD_WORKER_IMAGE_NAME}
yes | gcloud beta container images add-tag ${GCLOUD_WORKER_IMAGE_NAME}:$TRAVIS_COMMIT ${GCLOUD_WORKER_IMAGE_NAME}:latest

echo "Set updated containers to kubernetes"
kubectl set image deployment/web nginx=${GCLOUD_NGINX_IMAGE_NAME}:$TRAVIS_COMMIT
kubectl set image deployment/web app=${GCLOUD_APP_IMAGE_NAME}:$TRAVIS_COMMIT
kubectl set image deployment/worker worker=${GCLOUD_WORKER_IMAGE_NAME}:$TRAVIS_COMMIT