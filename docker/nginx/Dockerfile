# Base image:
FROM nginx:alpine

RUN mkdir /logs && touch logs/nginx-access.log && touch logs/nginx-errors.log

COPY docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf