#!/bin/bash

# delete "<none>" images if any
if [[ $(docker images -f "dangling=true" -q) != "" ]]; then
  echo "delete \"dangling\" images"
  docker rmi -f $(docker images -f "dangling=true" -q)
fi
