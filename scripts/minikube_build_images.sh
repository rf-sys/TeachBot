#!/usr/bin/env bash

docker build -t teachbot_nginx -f docker/nginx/Dockerfile .
docker build -t teachbot_app -f docker/web/Dockerfile .
docker build -t teachbot_worker -f docker/worker/Dockerfile .