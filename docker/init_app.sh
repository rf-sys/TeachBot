#!/bin/sh

# setup project
rails tmp:clear
rails db:create
rails db:migrate
rails db:seed
