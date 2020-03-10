#!/bin/bash

set -x

# INPUT_IMAGE_NAMES="first second"
# INPUT_IMAGE_TAG_PREFIX="origoss/github-actions-demo:test-"
# INPUT_IMAGE_TAG_SUFFIX="-$(date +%s)"
# INPUT_DOCKERFILE_SUFFIX=".kube"
# export INPUT_DOCKER_USERNAME=gregorigoss
# export INPUT_DOCKER_PASSWORD="dbfec147-2062-48f6-bb4c-281fe3924d1a"
# INPUT_KUSTOMIZE_REPO_PATH=kustomize-repo/manifests/overlays/staging-devops
# INPUT_GIT_USER_NAME="Github Actions"
# INPUT_GIT_USER_EMAIL="noreply@test.io"

cat /registry-config.yml.tmpl | envsubst | tee /registry-config.yml

cd /github/home

for f in $INPUT_IMAGE_NAMES
do
    makisu build \
           -f Dockerfile.${f}${INPUT_DOCKERFILE_SUFFIX}     \
           -t ${INPUT_IMAGE_TAG_PREFIX}${f}${INPUT_IMAGE_TAG_SUFFIX}    \
           --registry-config=/registry-config.yml \
           --push index.docker.io                      \
           .
done

if [[ -d $INPUT_KUSTOMIZE_REPO_PATH ]]
then
    cd $INPUT_KUSTOMIZE_REPO_PATH
    for f in $INPUT_IMAGE_NAMES
    do
        kustomize edit set image $f=${INPUT_IMAGE_TAG_PREFIX}${f}${INPUT_IMAGE_TAG_SUFFIX}
    done
fi

git config user.name $INPUT_GIT_USER_NAME
git config user.email $INPUT_GIT_USER_EMAIL
git commit -am "Updating image tags for '${INPUT_IMAGE_NAMES}' using tag suffix ${INPUT_IMAGE_TAG_SUFFIX}"
