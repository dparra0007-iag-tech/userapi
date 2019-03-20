#!/bin/bash
set -e  

wget $GLOBALCONF -O env-global.sh
cat env-global.sh > .env
source /usr/src/app/.env

java -jar target/api-gateway-0.0.1-SNAPSHOT.jar