## Using docker to set up application

Be sure you have "Docker" and "docker-compose" installed

### Development:
1. Clone repository:

`git clone https://github.com/Okalia/TeachBot.git`

2. Rename `.env.development.sample` into `.env.development`

3. Fill in `.env.development` env's with your credentials

4. Run `docker-compose build` to build images

5. If you have done "build" first time, you need to run `docker-compose run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

6. Run `docker-compose up` to start your app

7. Visit `http://0.0.0.0:3000` or `http://localhost:3000` to check if application works

### Production:

1. Clone repository:

`git clone https://github.com/Okalia/TeachBot.git`

2. Rename `.env.production.sample` into `.env.production`

3. Fill in `.env.production` env's with your credentials

4. Run `docker-compose -f docker-compose.prod.yml build` to build images

5. If you have done "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

6. Run `docker-compose -f docker-compose.prod.yml up` to start your app

7. Visit `http://0.0.0.0:3000` or `http://localhost:3000` to check if application works

### Deploy on Digitalocean

1. Clone repository:

`git clone https://github.com/Okalia/TeachBot.git`

2. Rename `.env.production.sample` into `.env.production`

3. Fill in `.env.production` env's with your credentials

4. Create docker-machine on Digitalocean: `docker-machine create --driver digitalocean --digitalocean-access-token=$token --digitalocean-size=4gb teachbot`

It's preferable if you have at least 4gb droplet, but it's not necessarily, 
cause of we force Elasticsearch to use less memory to keep up
(see docker-compose.prod.yml `ES_JAVA_OPTS: -Xms1g -Xmx1g # by default - 10g`). 
You can change or remove (to use default value) this env variable in config

5. Run `docker-machine env teachbot`

6. Run `eval $(docker-machine env teachbot)`

7. Run `docker-compose -f docker-compose.prod.yml build` to build images

5. If you have done "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run web sh docker/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

8. Run `docker-compose -f docker-compose.prod.yml up` to start your app

9. Visit `http://your_machine_ip:3000` to check if application works

(to get `your_machine_ip` you can copy IPv4 of your droplet on Digitalocen or type `docker-machine ip teachbot`)