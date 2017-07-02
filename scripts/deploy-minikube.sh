#!/usr/bin/env bash

# path to file with last commit id
FILE_WITH_COMMIT_ID=./scripts/files/last_minikube_commit_id.txt

# create file and set content to 0 if file doesn't exists
if [ ! -f ${FILE_WITH_COMMIT_ID} ]; then
  # create file with commit id
  touch touch ${FILE_WITH_COMMIT_ID}
  # set default value to the file
  echo 0 > ${FILE_WITH_COMMIT_ID}
fi

# read content from file and set commit ids
LAST_COMMIT_ID=`cat ${FILE_WITH_COMMIT_ID}`
COMMIT_ID=$(($LAST_COMMIT_ID+1))

# check if MINIKUBE_DEPLOY_CLEANER env is empty
if [[ -z ${MINIKUBE_DEPLOY_CLEANER+x} ]]; then
  echo "Remove previous images after deploy new ones ? (1/2)"
  echo "It will help to free space, but will make it unable to roll back to previous images through \"kubectl rollout\""
  select yn in "Yes" "No"; do
      case ${yn} in
          Yes ) MINIKUBE_DEPLOY_CLEANER=1; echo "Previous images will be removed"; break;;
          No ) MINIKUBE_DEPLOY_CLEANER=0; echo "Previous images will not be removed"; break;;
      esac
  done
fi

echo "Set variables"
AUTHOR=teachbot

# local images name
LOCAL_NGINX_IMAGE_NAME=teachbot_nginx
LOCAL_APP_IMAGE_NAME=teachbot_app
LOCAL_WORKER_IMAGE_NAME=teachbot_worker

# minikube images name
MINIKUBE_NGINX_IMAGE_NAME=${AUTHOR}/${LOCAL_NGINX_IMAGE_NAME}
MINIKUBE_APP_IMAGE_NAME=${AUTHOR}/${LOCAL_APP_IMAGE_NAME}
MINIKUBE_WORKER_IMAGE_NAME=${AUTHOR}/${LOCAL_WORKER_IMAGE_NAME}

echo "build necessary images"
docker-compose build nginx app worker

echo "create tag reference with commit id on docker-compose images"
docker tag ${LOCAL_NGINX_IMAGE_NAME} ${MINIKUBE_NGINX_IMAGE_NAME}:${COMMIT_ID}
docker tag ${LOCAL_APP_IMAGE_NAME} ${MINIKUBE_APP_IMAGE_NAME}:${COMMIT_ID}
docker tag ${LOCAL_WORKER_IMAGE_NAME} ${MINIKUBE_WORKER_IMAGE_NAME}:${COMMIT_ID}

echo "Set updated containers to pods"
kubectl set image deployment/web nginx=${MINIKUBE_NGINX_IMAGE_NAME}:${COMMIT_ID}
kubectl set image deployment/web app=${MINIKUBE_APP_IMAGE_NAME}:${COMMIT_ID}
kubectl set image deployment/worker worker=${MINIKUBE_WORKER_IMAGE_NAME}:${COMMIT_ID}

echo "save commit id"
echo ${COMMIT_ID} > ${FILE_WITH_COMMIT_ID}

if [[ ${MINIKUBE_DEPLOY_CLEANER} == 1 ]]; then
  echo "delete previous images"

  # delete images with previous commit id if any exist
  if docker inspect "${MINIKUBE_NGINX_IMAGE_NAME}:${LAST_COMMIT_ID}" > /dev/null 2>&1; then
    docker rmi -f ${MINIKUBE_NGINX_IMAGE_NAME}:${LAST_COMMIT_ID}
  fi

  if docker inspect "${MINIKUBE_APP_IMAGE_NAME}:${LAST_COMMIT_ID}" > /dev/null 2>&1; then
    docker rmi -f ${MINIKUBE_APP_IMAGE_NAME}:${LAST_COMMIT_ID}
  fi

  if docker inspect "${MINIKUBE_WORKER_IMAGE_NAME}:${LAST_COMMIT_ID}" > /dev/null 2>&1; then
    docker rmi -f ${MINIKUBE_WORKER_IMAGE_NAME}:${LAST_COMMIT_ID}
  fi
fi
