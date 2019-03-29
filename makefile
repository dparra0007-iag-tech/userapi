VERSION := ${CI_PIPELINE_ID}

ifneq ($(FILE),)
	COMPOSE_FILE := -f $(FILE)
else
	COMPOSE_FILE :=
endif

.PHONY: build
build:
	$(BASH)s2i build ${PATH} iaghcp-docker-technical-architecture.jfrog.io/s2i-nodejs:1.0.0 ${SERVICE_REGISTRY}

.PHONY: compose
compose:
	$(BASH)docker rmi composed-greetingapi || true
	$(BASH)s2i build ./userapi iaghcp-docker-technical-architecture.jfrog.io/s2i-nodejs:1.0.0 composed-userapi
	$(BASH)docker-compose $(COMPOSE_FILE) up -d
	
.PHONY: push
push:
	$(BASH)echo "VERSION=${VERSION}"
	$(BASH)docker tag ${CONTAINER_SERVICE_IMAGE} ${CONTAINER_SERVICE_IMAGE}:${VERSION}
	$(BASH)jfrog rt config --url=${ARTIFACTORY_URL} --user=${ARTIFACTORY_USER} --password=${ARTIFACTORY_PASS}
	$(BASH)jfrog rt c show
	$(BASH)jfrog rt dp ${CONTAINER_SERVICE_IMAGE}:${VERSION} ${DOCKER_REPO_KEY} --build-name=${BUILD_NAME} --build-number=${CI_PIPELINE_ID}
	$(BASH)jfrog rt bce ${BUILD_NAME} ${CI_PIPELINE_ID}
	$(BASH)jfrog rt bp ${BUILD_NAME} ${CI_PIPELINE_ID}
	$(BASH)docker login -u ${ARTIFACTORY_USER} -p ${ARTIFACTORY_PASS} ${GLP_REGISTRY}
	$(BASH)docker push ${CONTAINER_SERVICE_IMAGE}
	$(BASH)docker logout ${GLP_REGISTRY}