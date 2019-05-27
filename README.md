# W53-USERAPI

This project is a reference implemetation of a microservices architecture style with nodejs based programming language.

## Functional Description

The w53-userapi application is just an application to manage a list of users by adding, deleting and getting the list. There are three methods that implements each of these operations.

The list of users are stored in a mongdb database as json objects.

## Technical Overview

### Architecture

The application represents an concrete implementation of [microservices style architecture](https://en.wikipedia.org/wiki/Microservices) following the [Group IT application standards](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab%3a%3a6fe37660-8d95-449a-80b1-6eeb13a3c343?label=Application+Standards+in+Wiki&context=%7b%0d%0a++%22subEntityId%22%3a+%22%7b%5c%22pageId%5c%22%3a8%2c%5c%22sectionId%5c%22%3anull%2c%5c%22origin%5c%22%3a2%7d%22%2c%0d%0a++%22canvasUrl%22%3a+%22https%3a%2f%2fteams.microsoft.com%2fl%2ftab%2f19%253a6239855bbac34516a2518de57c37c1ca%2540thread.skype%2ftab%253a%253a6fe37660-8d95-449a-80b1-6eeb13a3c343%3flabel%3dWiki%26tenantId%3dc28eb601-be1d-4918-89f4-0d1b73c2ddc5%22%2c%0d%0a++%22channelId%22%3a+%2219%3a6239855bbac34516a2518de57c37c1ca%40thread.skype%22%0d%0a%7d&tenantId=c28eb601-be1d-4918-89f4-0d1b73c2ddc5).

The concrete implementation is based on ExpressJS MVC framework for nodejs programming language for web sites and web apis.

The application is the result of the aggregation of four microservices:

- userapi. It's web service that implements the business logic for manage the user list.

- userapi-db. It's the database to persists the list of users. The database is hosted in a docker container based on mongodb ephimeral base image.

These all three services, and the database resource, are the basic implementation of the application functionality with a microservice architecture style, allowing independent deployment models for each one.

### Wider Technical Context

The contenization engine choosen is docker that is part of the technology catalogue. Because of that each service and resource has a dockerfile defining the operation system where they run, the system packages used, the system users running them and the rest of the infrastructure needed by each service and resource software instances.

The complete application can work in any host system with just these few system requirements:

- Docker engine
- Docker compose utility

The docke engine has some differences on windows machine where it's needed [Docker for Windows](https://www.docker.com/docker-windows). An special branch for it is created in this repository called "windows-host" that includes in the Dockerfile this special lines:

```
...
RUN apt-get install dos2unix
...
RUN dos2unix ./start.sh
...
```

From Windows 10, docker engine is a feature that could be enabled in windows, but not possible to run linux based images on it. So, it's important to use Docker for windows instead, with the comented changes in dockerfile.

Docker compose allows us to run the complete application by communicating the different service as defined in the docker-compose.yml file.

In any case, the stack is standard an the only requirement is to use the docker engine. Fullfilling this, it can be used any container cluster manager like [Docker Swarn](https://github.com/docker/swarm), [Kubernetes](https://kubernetes.io/), DC/OS, ... It's part of the technology catalogue Openshift, so it's recommended to install locally [Minishift](https://github.com/minishift/minishift) and use it as hosting docker cluter manager.

### Common Data Model and Contract

Adopt API First approach is part of the [Group IT application standards](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab%3a%3a6fe37660-8d95-449a-80b1-6eeb13a3c343?label=Application+Standards+in+Wiki&context=%7b%0d%0a++%22subEntityId%22%3a+%22%7b%5c%22pageId%5c%22%3a8%2c%5c%22sectionId%5c%22%3anull%2c%5c%22origin%5c%22%3a2%7d%22%2c%0d%0a++%22canvasUrl%22%3a+%22https%3a%2f%2fteams.microsoft.com%2fl%2ftab%2f19%253a6239855bbac34516a2518de57c37c1ca%2540thread.skype%2ftab%253a%253a6fe37660-8d95-449a-80b1-6eeb13a3c343%3flabel%3dWiki%26tenantId%3dc28eb601-be1d-4918-89f4-0d1b73c2ddc5%22%2c%0d%0a++%22channelId%22%3a+%2219%3a6239855bbac34516a2518de57c37c1ca%40thread.skype%22%0d%0a%7d&tenantId=c28eb601-be1d-4918-89f4-0d1b73c2ddc5). Because of that, the service contract is defined with JSON format in a REST endpoint. The [API specification](https://userapi65.docs.apiary.io/#) is defined in a sharing design tool like Apiary.

The application works with unstructured messages received by HTTP GET and POST. That's why the database is a non-sql database with no defined schemas.

### Configuration

For all services, there is a distinction of two kind of configurations:

- Static. It's a Operational/Infrastructure related configuration settings managenment. The settings managed statically are basically the related to OS definition, connection strings, credentials, ... In the examples they are implemented as environment vaiables injected in deployment time in Dockerfile and docker-compose.yml files.

```
environment:
      - GLOBALCONF=https://raw.githubusercontent.com/dparra0007/W53-STATIC-CONFIG-SETTINGS/master-local/env.sh
      - SYSTEMCONF=https://raw.githubusercontent.com/dparra0007/W53-STATIC-CONFIG-SETTINGS/userapi/env.sh
```

Trying to simulate final implementation in Hybrid Cloud Platform, it's used the [sidecar pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar) in the scope of microservices. The settings are read from a configuration web service, that in this example is just implemented by the raw Github url endpoint.

- Dynamic. It's a business/application related configuration settings management. The settings managed dynamically are the ones that are directly defining the business logic, like the message content in response to each POST and DELETE requests. In this service, the concrete implementation is done with sidecar pattern as well. The difference with static configuration is that in this case the base image of the sidecar image has a cron daemon that is pooling cahnges from a configuration web service. In this case, again, raw Github url endpoint:

```
System.setProperty("archaius.configurationSource.additionalUrls", "https://github.com/dparra0007/W53-USERAPI-CONFIG/blob/master/default.json");
```

### Logging & Monitoring

The application implements Logging & [Monitoring standards](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab%3a%3a6fe37660-8d95-449a-80b1-6eeb13a3c343?label=Monitoring+in+Wiki&context=%7b%0d%0a++%22subEntityId%22%3a+%22%7b%5c%22pageId%5c%22%3a2%2c%5c%22sectionId%5c%22%3anull%2c%5c%22origin%5c%22%3a2%7d%22%2c%0d%0a++%22canvasUrl%22%3a+%22https%3a%2f%2fteams.microsoft.com%2fl%2ftab%2f19%253a6239855bbac34516a2518de57c37c1ca%2540thread.skype%2ftab%253a%253a6fe37660-8d95-449a-80b1-6eeb13a3c343%3flabel%3dWiki%26tenantId%3dc28eb601-be1d-4918-89f4-0d1b73c2ddc5%22%2c%0d%0a++%22channelId%22%3a+%2219%3a6239855bbac34516a2518de57c37c1ca%40thread.skype%22%0d%0a%7d&tenantId=c28eb601-be1d-4918-89f4-0d1b73c2ddc5) based in indsutry standards and [Group IT application standards](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab%3a%3a6fe37660-8d95-449a-80b1-6eeb13a3c343?label=Application+Standards+in+Wiki&context=%7b%0d%0a++%22subEntityId%22%3a+%22%7b%5c%22pageId%5c%22%3a8%2c%5c%22sectionId%5c%22%3anull%2c%5c%22origin%5c%22%3a2%7d%22%2c%0d%0a++%22canvasUrl%22%3a+%22https%3a%2f%2fteams.microsoft.com%2fl%2ftab%2f19%253a6239855bbac34516a2518de57c37c1ca%2540thread.skype%2ftab%253a%253a6fe37660-8d95-449a-80b1-6eeb13a3c343%3flabel%3dWiki%26tenantId%3dc28eb601-be1d-4918-89f4-0d1b73c2ddc5%22%2c%0d%0a++%22channelId%22%3a+%2219%3a6239855bbac34516a2518de57c37c1ca%40thread.skype%22%0d%0a%7d&tenantId=c28eb601-be1d-4918-89f4-0d1b73c2ddc5).

All services and resources send logs to standard output as event stream messages. The host environment define and implements the event conllector and re-send them to a final storage with an strcutured JSON format.

The concrete implementation is based on [Bunyan](https://github.com/villadora/express-bunyan-logger) and [Zipkin](https://github.com/openzipkin/zipkin-js/tree/master/packages/zipkin-instrumentation-express) packages as explained [Logging & Monitoring Guidelines](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab%3a%3a6fe37660-8d95-449a-80b1-6eeb13a3c343?label=Guidelines+in+Wiki&context=%7b%0d%0a++%22subEntityId%22%3a+%22%7b%5c%22pageId%5c%22%3a2%2c%5c%22sectionId%5c%22%3a7%2c%5c%22origin%5c%22%3a2%7d%22%2c%0d%0a++%22canvasUrl%22%3a+%22https%3a%2f%2fteams.microsoft.com%2fl%2ftab%2f19%253a6239855bbac34516a2518de57c37c1ca%2540thread.skype%2ftab%253a%253a6fe37660-8d95-449a-80b1-6eeb13a3c343%3flabel%3dWiki%26tenantId%3dc28eb601-be1d-4918-89f4-0d1b73c2ddc5%22%2c%0d%0a++%22channelId%22%3a+%2219%3a6239855bbac34516a2518de57c37c1ca%40thread.skype%22%0d%0a%7d&tenantId=c28eb601-be1d-4918-89f4-0d1b73c2ddc5).
For Bunyan, after the instance of bunyan function, the structure of the log is the standard one extended by including Zipkin traces in the red_id field with the fields X-B3-TraceId and X-B3-SpanId. This is done by set up the logger with:

```
app.use(require('express-bunyan-logger')({
  genReqId: function(req) {
     return tracer.id;
  }
}));
```

in [app.js](https://gitlab.com/W53/W53-USERAPI/blob/master/userapi/app.js).

After that set up, the usage is very straight forward with just calling Bunyan log API: log.debug(), log.info(), log.warn(), ...

To have [Zipkin](https://github.com/openzipkin/zipkin-js/tree/master/packages/zipkin-instrumentation-express) as dependency package it's just because the need to pass Openstracing http headers between requests. It could be done by custom code, but it's easier to let Zipkin to manage http headers for Opentracing, although there are not any endpoint configured for Zipkin to send traces, because it's the platform who owns that responsability.

## Development Pipeline

Development workflow is versioned with the rest of the code with the continuous integration/delivery pipeline definition in the file .gitlab-ci.yml. That way, not only the application code and the infrastructure code is part of the solution package, the development workflow itself is part of that package and managed with the rest of the artefacts.

The core concepts of standard pipelines and specially the .gitlab-ci pipeline is described in the ["introduction to pipelines and jobs"](https://docs.gitlab.com/ee/ci/pipelines.html) online document.

In the concrete case of this application there are defined six stages:

- test code. The application code is unit and integration tested. Moreover, static analysis security tests are performed in this stage.
- build application. In this stage, docker images are build putting the already compiled service code inside the docker image.
- test application. Infrastructure and service code, all as part of the docker image that is the application is functional and performance tested. Moreover, in this stage, the API specification defined by the API First approach in initial process phase is validated/checked for definition compliance. There is no need for reserved enviroments for testing because the docker [excutor engine of Gitlab CI](https://docs.gitlab.com/runner/executors/docker.html) allows to run isolated tested enviroments defined by docker compose files like [docker-compose.design.test.yml](https://gitlab.com/W53/W53-USERAPI/blob/master/docker-compose.design.test.yml), [docker-compose.functional.test.yml](https://gitlab.com/W53/W53-USERAPI/blob/master/docker-compose.functional.test.yml) and [docker-compose.performance.test.yml](https://gitlab.com/W53/W53-USERAPI/blob/master/docker-compose.performance.test.yml) with docker images in it that can perform the desired kind of test. Further details will be commented n Testing section.
- push binaries. All docker images being built and tested are versioned and pushed to production docker registry.
- deploy application. In this stage, the deployment jobs put correct docker images to defined host enviroments. In this concrete example, the host is Openshift.
- regression test deploy. To enable continous delivery, a final stage with regresstion testing and rollback if test are not satisfy can be defined in the pipeline. In this case, only the regression test that is the previous functional test with production configuration agaisnt production enviroment.

All the jobs in every stage run in docker containers, as well, allowing of define build and test infrastructure identically or according to final host infrastructure. Any infrastructure change can be done together on final host dockerfiles and the dockerfiles of the pipeline's jobs.

### Testing

As we could see in previous section, there are defined five types of testing:

- static code analysis. In test code stage

```
static_test_service:
  stage: test code
  script:
    - docker run --rm -v $(pwd):/data -w /data dparra0007/sonar-scanner:20171010-1 sonar-scanner
     -Dsonar.projectKey=$CI_PROJECT_NAMESPACE:$CI_PROJECT_NAME 
     -Dsonar.projectName=$CI_PROJECT_NAME 
     -Dsonar.branch=$CI_COMMIT_REF_NAME 
     -Dsonar.projectVersion=$CI_JOB_ID 
     -Dsonar.sources=./userapi 
     -Dsonar.gitlab.project_id=$CI_PROJECT_ID 
     -Dsonar.gitlab.commit_sha=$CI_COMMIT_SHA 
     -Dsonar.gitlab.ref_name=$CI_COMMIT_REF_NAME
  except:
    - triggers
```

  Sonarqube scanner image is used to run sonarqube policy checks. In this example, it's used Sonarcloud free tier to define policies and collect results.

- validate api specification test. In test application stage

```
validate_api_description:
  stage: test application
  before_script:
    - apk update
    - apk upgrade
    - apk add python python-dev py-pip build-base
    - curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    - chmod +x /usr/local/bin/docker-compose
    - pip install docker-compose
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN registry.gitlab.com
    - export TAG=$CI_COMMIT_REF_NAME 
    - docker-compose -f docker-compose.design.test.yml up -d
    - sleep 90s
    - docker logs $(docker ps -a --filter "name= w53userapi_userapi-design-test_1" --format "{{.ID}}")
  after_script:
    - docker stop $(docker ps -a --filter status=running --format "{{.ID}}") > /dev/null
    - docker rm $(docker ps -a -q) -f > /dev/null
    - docker rmi $(docker images -q) -f > /dev/null || true
  only:
    - master
  except:
    - triggers
```

  By specifying the API contract with open standards like swagger or API Blueprint, we could use a commandline tool that can check these API specifications for guarantee that design is implemented correctly. In this example, it's used Dredd command line tool in the defined test in [userapi-design-test/Dockerfile](https://gitlab.com/W53/W53-USERAPI/blob/master/userapi-design-test/Dockerfile) that is used in [docker-compose.design.test.yml](https://gitlab.com/W53/W53-USERAPI/blob/master/docker-compose.design.test.yml).

- functional testing. In test application stage.

```
functional_test_service:
  stage: test application
  before_script:
    - apk update
    - apk upgrade
    - apk add python python-dev py-pip build-base
    - curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    - chmod +x /usr/local/bin/docker-compose
    - pip install docker-compose
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN registry.gitlab.com
    - export TAG=$CI_COMMIT_REF_NAME 
    - docker-compose -f docker-compose.functional.test.yml up -d
    - sleep 30s
    - docker logs $(docker ps -a --filter ancestor=dparra0007/newman:20170712-4 --format "{{.ID}}")
  after_script:
    - docker stop $(docker ps -a --filter status=running --format "{{.ID}}") > /dev/null
    - docker rm $(docker ps -a -q) -f > /dev/null
    - docker rmi $(docker images -q) -f > /dev/null || true
  when: manual
  only:
    - master
  except:
    - triggers
```

  A free tool to easily and productive way of working with REST APIs is [Postman](https://www.getpostman.com/). With Postman it's easy to create tests, use different enviroments for tests executions, share data between tests and execute automatic tests with [Newman tool](https://github.com/postmanlabs/newman). In this stage we take adventadge of all of them to run automatic functional tests scripted with Javascript in Postman and executed with Newman.
  The functional test cases are implemented in a postman collection available in this [link](https://documenter.getpostman.com/view/651996/S11DV2wr).

- performance testing. In test application stage.

```
performance_test_service:
  stage: test application
  before_script:
    - apk update
    - apk upgrade
    - apk add python python-dev py-pip build-base
    - curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    - chmod +x /usr/local/bin/docker-compose
    - pip install docker-compose
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN registry.gitlab.com
    - export TAG=$CI_COMMIT_REF_NAME 
    - export TEST_NUMBER=$CI_COMMIT_SHA
    - docker-compose -f docker-compose.performance.test.yml up -d
    - sleep 120s
    - docker logs $(docker ps -a --filter ancestor=dparra0007/taurus:20180402-2 --format "{{.ID}}")
  after_script:
    - docker stop $(docker ps -a --filter status=running --format "{{.ID}}") > /dev/null
    - docker rm $(docker ps -a -q) -f > /dev/null
    - docker rmi $(docker images -q) -f > /dev/null || true
  when: manual
  only:
    - master
  except:
    - triggers
```

  The core definition of the performance test stage is [Taurus framework](https://github.com/Blazemeter/taurus). With Taurus, complex JMeter test can be defined in declaration files like [greetingapi-performance-test/test.yml](https://gitlab.com/W53/W53-USERAPI/blob/master/docker-compose.performance.test.yml) and run on commandline as part of docker image with Taurus command line installed:

```
FROM dparra0007/taurus:20180402-2

COPY ./test.yml /bzt-configs/test.yml

CMD ["/bin/bash", "-c", "sleep 30 && curl --request GET --url 'https://api.getpostman.com/environments/651996-b80ed237-9179-35ec-d8a1-35d574e118c8' --header 'X-Api-Key: 100822fe2bd7454eb916c8ebdd4be266' > ci.json && wget -O collection.json https://www.getpostman.com/collections/6d9fe4f1a0033de5a2af && bzt /bzt-configs/test.yml -o modules.blazemeter.report-name=\"$REPORT\" "]
```

  In this case, the performance test consist in running the functional test already defined with Postman.

- regression testing. In regression test stage.

```
functional_regression_test_staging:
  stage: regression test deploy
  image: dparra0007/newman:20170712-4
  script:
    - newman run https://www.getpostman.com/collections/6d9fe4f1a0033de5a2af --reporters cli,json --reporter-json-export outputfile.json --environment https://api.getpostman.com/environments/651996-b6820a2c-0306-45c6-b5ab-1db91a8f727e?apikey=100822fe2bd7454eb916c8ebdd4be266
  only:
      - master
```
  Again, we take the already defined Postman tests, and execute them with Newman but using production configuration defined as Postman enviroment variables.

## local development
  
minishift start
minishift addon apply registry-route

Add minishift private registry to insecure registry list in docker configuration
  osascript -e 'quit app "Docker"'; open -a Docker ; while [ -z "$(docker info 2> /dev/null )" ]; do printf "."; sleep 1; done; echo ""
  sudo systemctl restart docker.service

make build PROJECT_NAME=userapi MINISHIFT_IP=$(minishift ip) -f makefile-local
make push PROJECT_NAME=userapi MINISHIFT_IP=$(minishift ip) -f makefile-local
make pre-deploy PROJECT_NAME=userapi -f makefile-local
make deploy PROJECT_NAME=userapi DEPLOYMENT_FILE=deployment-local.yml -f makefile-local