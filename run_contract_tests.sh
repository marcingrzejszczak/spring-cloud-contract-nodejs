#!/bin/bash

set -o errexit

SC_CONTRACT_DOCKER_VERSION="${SC_CONTRACT_DOCKER_VERSION:-2.0.0.RELEASE}"
APP_IP="$( ./whats_my_ip.sh )"
APP_PORT="${APP_PORT:-3000}"
ARTIFACTORY_PORT="${ARTIFACTORY_PORT:-8081}"
APPLICATION_BASE_URL="http://${APP_IP}:${APP_PORT}"
ARTIFACTORY_URL="${REPO_WITH_BINARIES_FOR_UPLOAD}"
CURRENT_DIR="$( pwd )"
PROJECT_NAME="${PROJECT_NAME:-bookstore}"
PROJECT_GROUP="${PROJECT_GROUP:-com.example}"
PROJECT_VERSION="${PROJECT_VERSION:-0.0.1.RELEASE}"

echo "Sc Contract Version [${SC_CONTRACT_DOCKER_VERSION}]"
echo "Application URL [${APPLICATION_BASE_URL}]"
echo "Artifactory URL [${ARTIFACTORY_URL}]"
echo "Project Version [${PROJECT_VERSION}]"

REPO_WITH_BINARIES_USERNAME="${M2_SETTINGS_REPO_USERNAME}"
REPO_WITH_BINARIES_PASSWORD="${M2_SETTINGS_REPO_PASSWORD}"

mkdir -p build/spring-cloud-contract/output
docker run  --rm -e "APPLICATION_BASE_URL=${APPLICATION_BASE_URL}" -e "PUBLISH_ARTIFACTS=true" -e "PROJECT_NAME=${PROJECT_NAME}" -e "PROJECT_GROUP=${PROJECT_GROUP}" -e "REPO_WITH_BINARIES_URL=${ARTIFACTORY_URL}" -e "PROJECT_VERSION=${PROJECT_VERSION}" -e "REPO_WITH_BINARIES_USERNAME=${REPO_WITH_BINARIES_USERNAME}" -e "REPO_WITH_BINARIES_PASSWORD=${REPO_WITH_BINARIES_PASSWORD}" -v "${CURRENT_DIR}/contracts/:/contracts:ro" -v "${CURRENT_DIR}/build/spring-cloud-contract/output:/spring-cloud-contract-output/" springcloud/spring-cloud-contract:"${SC_CONTRACT_DOCKER_VERSION}"

docker run --rm -v "${CURRENT_DIR}/build/spring-cloud-contract/output:/spring-cloud-contract-output/" springcloud/spring-cloud-contract:"${SC_CONTRACT_DOCKER_VERSION}" chown -R $(id -u):$(id -g) "/spring-cloud-contract-output/"
