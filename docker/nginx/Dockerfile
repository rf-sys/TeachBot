# Base image:
FROM nginx

# Set our working directory inside the image
WORKDIR /usr/src/app

# create log directory
RUN mkdir log
 
# Copy Nginx config template
COPY config/nginx.conf /etc/nginx/conf.d/default.conf
 
EXPOSE 80
 
# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]