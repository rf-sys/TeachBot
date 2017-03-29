## Using docker to set up application

Be sure you have "Docker" and "docker-compose" installed

Using Docker, we recommend to download one of our
[releases](https://github.com/Okalia/TeachBot/releases), extract archive, go to extracted folder. 

**It is not recommended to clone master branch with latest commits 
as it can include mistakes in docker builds.**

### Development:

1. Rename `.env.development.sample` into `.env.development`

2. Fill in `.env.development` env's with your credentials

3. Run `docker-compose build` to build images

4. If you have done "build" first time, you need to run `docker-compose run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

5. Run `docker-compose up` to start your app

6. Visit `http://0.0.0.0:3000` or `http://localhost:3000` to check if application works

### Production:

1. Rename `.env.production.sample` into `.env.production`

2. Fill in `.env.production` env's with your credentials

3. Run `docker-compose -f docker-compose.prod.yml build` to build images

4. If you have done "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

5. Run `docker-compose -f docker-compose.prod.yml up` to start your app

6. Visit `http://0.0.0.0:3000` or `http://localhost:3000` to check if application works

### Deploy on Digitalocean

1. Rename `.env.production.sample` into `.env.production`

2. Fill in `.env.production` env's with your credentials

3. Create docker-machine on Digitalocean: `docker-machine create --driver digitalocean --digitalocean-access-token=$token --digitalocean-size=4gb teachbot`

It's preferable if you have at least 4gb droplet, but it's not necessarily, 
cause of we force Elasticsearch to use less memory to keep up
(see docker-compose.prod.yml `ES_JAVA_OPTS: -Xms1g -Xmx1g # by default - 10g`). 
You can change or remove (to use default value) this env variable in config

4. Run `docker-machine env teachbot`

5. Run `eval $(docker-machine env teachbot)`

6. Run `docker-compose -f docker-compose.prod.yml build` to build images

7. If you have done "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

8. Run `docker-compose -f docker-compose.prod.yml up` to start your app

9. Visit `http://your_machine_ip:3000` to check if application works

(to get `your_machine_ip` you can copy IPv4 of your droplet on Digitalocen or type `docker-machine ip teachbot`)

#### Troubleshoots

##### Byebug and Docker interaction 
If you are using **byebug** gem in development, you need start 'web' service separately from others
in debug mode. Example solution:

1. in the first console: `docker-compose up redis db elasticsearch sidekiq` - start all services, except "web"

2. in the second console: `docker-compose run --service-ports web` - start "web" in debug mode to be able interact with byebug

[Solution source](http://stackoverflow.com/questions/31669226/rails-byebug-did-not-stop-application)

##### RubyMine and Docker

RubyMine still a problem when we want to use IDE run/debug/rspec... configurations with docker-compose. 
But we found a hack you can use to use your containers and IDE's abilities at the same time:

1. If you services run locally (on your machine in containers - by default), then services, that are in the containers must be called from 0.0.0.0:port to access to them from IDE:

change your .env.development and .env.test to:

`ELASTICSEARCH_URL=http://0.0.0.0:9200`

`REDIS_URL=redis://0.0.0.0:6379/0`

`DB_HOST=0.0.0.0`

2. Start your containers, expect web:

`docker-compose up redis db elasticsearch`

3. Start Sidekiq in the console in app folder:

`bundle exec sidekiq -C config/sidekiq.yml`

(Sidekiq won't work in container as we changed out env's ip to 0.0.0.0 and hence it won't be able to call db and redis)

3. Now, you are able to interact with your services and
to use IDE Run/Debug configurations (as run app/tests...) while all necessary services are working
separately

As you can notice, we don't use "web" and "sidekiq" containers. Instead we merely interact with app 
and call other containers from outside through 0.0.0.0. 

