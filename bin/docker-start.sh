#!/bin/sh

# setup project
bundle exec rails tmp:clear
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
