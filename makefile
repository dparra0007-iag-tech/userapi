#PREVIOUS := $$(curl -u ${ARTIFACTORY_USER}:${ARTIFACTORY_PASS} -L -s ${URL_BA_REGISTRY}/tags/list |jq '."tags"[]' | sort -n | tail -n 2 | sort -r | tail -n 1)
#FILTERED := $(shell echo $(PREVIOUS) | tr -d \" | cut -d'-' -f 1)
#SEMVER_EXPRESSION := semver bump prerel ${CI_PIPELINE_ID} ${FILTERED}
#VERSION := $(shell $(SEMVER_EXPRESSION))

#ifeq ($(findstring *PATCH*,$(CI_COMMIT_MESSAGE)),*PATCH*)
#	SEMVER_EXPRESSION := semver bump patch ${FILTERED}
#	VERSION := $(shell $(SEMVER_EXPRESSION))
#endif

#ifeq ($(findstring *MINOR*,$(CI_COMMIT_MESSAGE)),*MINOR*)
#	SEMVER_EXPRESSION := semver bump minor ${FILTERED}
#	VERSION := $(shell $(SEMVER_EXPRESSION))
#endif

#ifeq ($(findstring *MAJOR*,$(CI_COMMIT_MESSAGE)),*MAJOR*)
#	SEMVER_EXPRESSION := semver bump major ${FILTERED}
#	VERSION := $(shell $(SEMVER_EXPRESSION))
#endif
VERSION := ${CI_PIPELINE_ID}
	
push:
	echo "VERSION=${VERSION}"
	docker tag ${CONTAINER_SERVICE_IMAGE} ${CONTAINER_SERVICE_IMAGE}:${VERSION}
	jfrog rt config --url=${ARTIFACTORY_URL} --user=${ARTIFACTORY_USER} --password=${ARTIFACTORY_PASS}
	jfrog rt c show
	jfrog rt dp ${CONTAINER_SERVICE_IMAGE}:${VERSION} ${DOCKER_REPO_KEY} --build-name=${BUILD_NAME} --build-number=${CI_PIPELINE_ID}
	jfrog rt bce ${BUILD_NAME} ${CI_PIPELINE_ID}
	jfrog rt bp ${BUILD_NAME} ${CI_PIPELINE_ID}
	docker login -u ${ARTIFACTORY_USER} -p ${ARTIFACTORY_PASS} ${GLP_REGISTRY}
	docker push ${CONTAINER_SERVICE_IMAGE}
	docker logout ${BA_REGISTRY}