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

for f in $INPUT_IMAGENAMES
do
    makisu build \
           -f Dockerfile.${f}${INPUT_DOCKERFILESUFFIX}     \
           -t ${INPUT_IMAGETAGPREFIX}${f}${INPUT_IMAGETAGSUFFIX}    \
           --registry-config=/registry-config.yml \
           --push index.docker.io                      \
           .
done

if [[ -d $INPUT_KUSTOMIZEREPOPATH ]]
then
    cd $INPUT_KUSTOMIZEREPOPATH
    for f in $INPUTIMAGENAMES
    do
        kustomize edit set image $f=${INPUT_IMAGETAGPREFIX}${f}${INPUT_IMAGETAGSUFFIX}
    done
fi

git config user.name $INPUT_GITUSERNAME
git config user.email $INPUT_GITUSEREMAIL
git commit -am "Updating image tags for '${INPUT_IMAGE_NAMES}' using tag suffix ${INPUT_IMAGE_TAG_SUFFIX}"
