#!/bin/bash
set -e  

make build PROJECT_NAME=userapi MINISHIFT_IP=$(minishift ip) -f makefile-local
make push PROJECT_NAME=userapi MINISHIFT_IP=$(minishift ip) -f makefile-local
make pre-deploy PROJECT_NAME=userapi -f makefile-local
make deploy PROJECT_NAME=userapi DEPLOYMENT_FILE=deployment-local.yml -f makefile-local