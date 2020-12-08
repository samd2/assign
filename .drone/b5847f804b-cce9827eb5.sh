#!/bin/bash

set -ex
export TRAVIS_BUILD_DIR=$(pwd)
export TRAVIS_BRANCH=$DRONE_BRANCH
export VCS_COMMIT_ID=$DRONE_COMMIT
export GIT_COMMIT=$DRONE_COMMIT
export DRONE_CURRENT_BUILD_DIR=$(pwd)
export PATH=~/.local/bin:$PATH

echo '==================================> BEFORE_INSTALL'

. .drone/before-install.sh

echo '==================================> INSTALL'

git clone https://github.com/boostorg/boost-ci.git boost-ci
cp -pr boost-ci/ci boost-ci/.codecov.yml .

if [ "$DRONE_STAGE_OS" = "darwin" ]; then
    unset -f cd
fi

export SELF=`basename $DRONE_REPO`
export BOOST_CI_TARGET_BRANCH="$DRONE_COMMIT_BRANCH"
export BOOST_CI_SRC_FOLDER=$(pwd)

. ./ci/common_install.sh

echo '==================================> COMPILE'

if  [ -n "${COVERITY_SCAN_NOTIFICATION_EMAIL}" -a \( "$DRONE_BRANCH" = "develop" -o "$DRONE_BRANCH" = "master" \) -a "$DRONE_BUILD_EVENT" = "push" ] ; then
cd $BOOST_ROOT/libs/$SELF
ci/travis/coverity.sh
fi

echo '==================================> AFTER_SUCCESS'

cd $DRONE_CURRENT_BUILD_DIR
. .drone/after-success.sh
