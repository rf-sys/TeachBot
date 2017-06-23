#!/bin/bash

# delete "puma.pid" file if it is presented (from previous app boot)
if [[ -a /tmp/puma.pid ]]; then
  rm /tmp/puma.pid
fi

# delete "puma.sock" file if it is presented (from previous app boot)
if [[ -a /tmp/puma.sock ]]; then
  rm -rf /tmp/puma.sock
fi

# do all necessary actions to prepare app to production
if [[ $RAILS_ENV == "production" ]]; then
  echo "preparing app to production"
  rails assets:precompile
  cp -R public/* /usr/share/app/assets
fi

# run puma web-server
bundle exec rails server