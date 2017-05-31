#!/usr/bin/env bash


# check if directory with gcloud bin doesn't exists
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then
  rm -rf $HOME/google-cloud-sdk;
  export CLOUDSDK_CORE_DISABLE_PROMPTS=1;
  curl https://sdk.cloud.google.com | bash;
fi

source /home/travis/google-cloud-sdk/path.bash.inc
gcloud --quiet version
gcloud --quiet components update