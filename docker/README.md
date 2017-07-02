## Using docker to set up application

Be sure you have "Docker" and "docker-compose" installed

Using Docker, we recommend to download one of our
[releases](https://github.com/Okalia/TeachBot/releases), extract archive, go to extracted folder. 

**It is not recommended to clone master branch with latest commits 
as it can include mistakes in docker builds.**

### Development:

1. Rename `.env.development.sample` into `.env.development`

2. Fill in `.env.development` with your credentials for development

3. Run `docker-compose build` to build images

4. If did "build" first time, you need to run `docker-compose run app sh scripts/init_app.sh`
to create db, run db seeds, fill up and add indexes to elasticsearch service

5. Run `docker-compose up` to start your app

6. Visit `http://0.0.0.0` to check if application works

### Production:

1. Rename `.env.production.sample` into `.env.production`

2. Fill in `.env.production` with your credentials for production

3. Run `docker-compose -f docker-compose.prod.yml build` to build images

4. If you did "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run app sh scripts/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

5. Run `docker-compose -f docker-compose.prod.yml up` to start your app

6. Visit `http://0.0.0.0` to check if application works

### Deploy on DigitalOcean

1. Rename `.env.production.sample` into `.env.production`

2. Fill in `.env.production` with your credentials for production

3. Create docker-machine on Digitalocean: `docker-machine create --driver digitalocean --digitalocean-access-token=$token --digitalocean-size=4gb teachbot`

It's preferable if you have at least 4gb droplet, but it's not necessarily, 
cause of we force Elasticsearch to use less memory to keep up
(see docker-compose.prod.yml `ES_JAVA_OPTS: -Xms1g -Xmx1g # by default - 10g`). 
You can change or remove (to use default value) this env variable in config

4. Run `docker-machine env teachbot`

5. Run `eval $(docker-machine env teachbot)`

6. Run `docker-compose -f docker-compose.prod.yml build` to build images

7. If you have done "build" first time, you need to run `docker-compose -f docker-compose.prod.yml run app sh scripts/init_app.sh`
to create db, fill up and add indexes to elasticsearch service

8. Run `docker-compose -f docker-compose.prod.yml up` to start your app

9. Visit `http://your_machine_ip` to check if application works

(to get `your_machine_ip` you can copy IPv4 of your droplet on Digitalocen or type `docker-machine ip teachbot`)

#### Troubleshoots

##### Byebug and Docker interaction 
If you are using **byebug** gem in development, you need start 'app' service separately from others
in debug mode. Example solution:

1. in the first console: `docker-compose up nginx postgres redis webpacker worker` - start all services, except "app"

2. in the second console: `docker-compose run --service-ports app` - start "app" in debug mode to be able interact with byebug

[Solution source](http://stackoverflow.com/questions/31669226/rails-byebug-did-not-stop-application)

##### RubyMine and Docker

RubyMine still a problem when we want to use IDE run/debug/rspec... configurations with docker-compose. 
But there is a hack you can use to use your containers and IDE's abilities at the same time:

1. If you services run locally (on your machine in containers - by default), then services, that are in the containers must be called from 0.0.0.0:port to access to them from IDE:

change your .env.development and .env.test to:

`REDIS_URL=redis://0.0.0.0:6379/0`

`DB_HOST=0.0.0.0`

2. Start your containers, expect app:

`docker-compose up nginx postgres redis webpacker worker`

3. Start worker in the console in app folder:

`bundle exec sidekiq -C config/sidekiq.yml`

(Sidekiq won't work in container as we changed out env's ip to 0.0.0.0 and hence it won't be able to call db and redis)

3. Now, you are able to interact with your services and
to use IDE Run/Debug configurations (as run app/tests...) while other services are reachable.

As you can notice, we don't use "app" and "worker" containers. Instead we merely interact with app 
and call other containers from outside through 0.0.0.0. 

### Kubernetes

[Kubernetes](https://kubernetes.io/) is an open-source system for automating deployment, scaling, and management of containerized applications.

We use [Minikube](https://github.com/kubernetes/minikube) (for development) and 
[Google Container Engine](https://cloud.google.com/container-engine/) (for production). Configurations
are intended to be used in those services. If you use another service in production (e.g. AWS, Azure...), then, you,
probably, need to edit configurations to be suited for these services.

#### Minikube

To deploy your cluster on Minikube node, you need:
1. Start Minikube cluster with command: `minikube start`. 
It will also prepare kubectl configuration to call minikube cluster.
2. Send secrets to your cluster. Example file: `kubernetes/minikube/secrets-minikube.example.txt`. 
Replace values with your values (db username, password, services' keys...), copy and paste content of the 
file in console to exec command.
3. Fill up cluster with `kubectl create -f kubernetes/minikube`. 
It will apply cluster-targeted .yml configs in "minikube" directory.
4. Connect you docker to remote host: `minikube docker-env` and `eval $(minikube docker-env)`. 
Further docker commands in the current console will be executed in docker machine.
5. Build images on minikube with script: `sh scripts/deploy-minikube.sh`. This files simulates continuous delivery.
It will build necessary images, attach to them tag with "commit id" and apply new images to kubernetes 
appropriate pods.

You can use 
[minikube dashboard](https://github.com/kubernetes/minikube#dashboard) or 
[kubectl proxy](https://kubernetes.io/docs/tasks/access-kubernetes-api/http-proxy-access-api/) 
commands to monitor cluster's state. Open new terminal
window, run one of the commands and leave window to work. 

#### GKE

You, probably, need, first and foremost, in `kubernetes/production/web.yml` at the bottom replace externalIPs
with `type: loadBalancer`. 

You need to obtain service account key and place its .json file into the root directory of the project 
to be able to connect gcloud sdk to your project and deploy images and cluster changes. 

[Guide](https://stackpointcloud.com/community/tutorial/how-to-create-auth-credentials-on-google-container-engine-gke) 

See [travis encrypting files](https://docs.travis-ci.com/user/encrypting-files/)

Load balancers, are, usually, too expensive to keep up if you are just learning 
kubernetes and don't have suggestive budget, so current solution allows to evade load balancer 
(at least on GKE) and get access to cluster through machine's external ip as in .yml file (web.yml) 
we specify internal ip. 
Problem: [stackoverflow](https://serverfault.com/questions/801189/expose-port-80-and-443-on-google-container-engine-without-load-balancer)

If you are new in GKE, you can visit [guide](https://deis.com/blog/2016/first-kubernetes-cluster-gke/) 
to understand how to deploy your cluster on Google Container Engine (GKE).

You also need, at least, to replace `scripts/deploy-staging.sh` variables with your project id, cluster 
name and compute zone.

Secrets and configs for production are placed in `kubernetes/production` folder.
What you can do next: 
1. send secrets to cluster (similar to paragraph "2" Minikube section, but use production folder).
2. Fill up cluster with `kubectl create -f kubernetes/production`.
3. Use prepared script `bash scripts/deploy-staging.sh` to deploy images to GKE cluster.
This script is developed to use in continuous delivery, so, if you gonna use it manually, don't forget to
uncomment `export TRAVIS_COMMIT=1` and specify new number each time before you use this script
