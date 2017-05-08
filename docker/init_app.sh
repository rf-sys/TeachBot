#!/bin/sh

# setup project
yarn
rails tmp:clear
rails db:create
rails db:migrate
rails db:seed
