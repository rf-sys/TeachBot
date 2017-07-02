#!/bin/bash

# delete .pid file if it is presented (from previous app boot)
if [[ -a tmp/pids/server.pid ]]; then
  rm -f tmp/pids/server.pid
fi

# delete "puma.sock" file if it is presented (from previous app boot)
if [[ -a /tmp/puma.sock ]]; then
  rm -f /tmp/puma.sock
fi

# do all necessary actions to prepare app to production
if [[ $RAILS_ENV == "production" ]]; then
  echo "preparing app to production"
  rails assets:precompile
  cp -R public/* /usr/share/app/assets
fi

# run puma web-server
bundle exec rails server