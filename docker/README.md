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