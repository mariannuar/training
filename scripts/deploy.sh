#!/usr/bin/env bash
BRANCH=$1
MESSAGE=$2
REPO=$PLATFORM_GIT_REPO
CLONEFOLDER=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1`
git clone --branch $BRANCH $REPO $CLONEFOLDER || git clone $REPO $CLONEFOLDER
cd $CLONEFOLDER
git branch $BRANCH ; git checkout $BRANCH
shopt -s extglob
rm -rf ./!(.git|.|..)
cd ../
cp -r .platform config drush files modules settings themes web $CLONEFOLDER/
cp ./{.environment,.platform.app.yaml,composer.json,composer.lock,composer.patches.json,install-redis.sh,package.json,package-lock.json} $CLONEFOLDER/
cd $CLONEFOLDER
# Change CUSTOMTHEME by your own theme folder.
if [ -f ./themes/custom/CUSTOMTHEME/package.json ]; then
  cd ./themes/custom/CUSTOMTHEME
  if [ ! -d ./node_modules ]; then npm install; fi
  npm run build
  cd ../../../
fi
git add --all .
git commit -m "$MESSAGE"
git push origin $BRANCH
cd ../
rm -rf $CLONEFOLDER
