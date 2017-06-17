#!/usr/bin/env bash

# create an archive with our secrets
tar cvf secrets.tar client-secret.json .env.development .env.production .env.test

# encrypt archive with travis cli
travis encrypt-file secrets.tar