#!/bin/bash

set -x

cat /registry-config.yml.tmpl | envsubst | tee /registry-config.yml

cd /github/workspace

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
    for f in $INPUT_IMAGENAMES
    do
        kustomize edit set image $f=${INPUT_IMAGETAGPREFIX}${f}${INPUT_IMAGETAGSUFFIX}
    done
fi

git config user.name $INPUT_GITUSERNAME
git config user.email $INPUT_GITUSEREMAIL
git commit -am "Updating image tags for '${INPUT_IMAGENAMES}' using tag suffix ${INPUT_IMAGETAGSUFFIX}"
