#!/bin/bash

set -ex
export TRAVIS_BUILD_DIR=$(pwd)
export TRAVIS_BRANCH=${TRAVIS_BRANCH:-$(echo $GITHUB_REF | awk 'BEGIN { FS = "/" } ; { print $3 }')}
export TRAVIS_OS_NAME=${GHA_JOB_OS_NAME:-linux}
export VCS_COMMIT_ID=$GITHUB_SHA
export GIT_COMMIT=$GITHUB_SHA
export DRONE_CURRENT_BUILD_DIR=$(pwd)
export GHA_BUILD_DIR=$(pwd)
export PATH=~/.local/bin:/usr/local/bin:$PATH

echo '==================================> BEFORE_INSTALL'

. .drone/before-install.sh

echo '==================================> INSTALL'

git clone https://github.com/boostorg/boost-ci.git boost-ci
cp -pr boost-ci/ci boost-ci/.codecov.yml .

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    unset -f cd
fi

export SELF=`basename $TRAVIS_BUILD_DIR`
export BOOST_CI_TARGET_BRANCH="$TRAVIS_BRANCH"
export BOOST_CI_SRC_FOLDER=$(pwd)

. ./ci/common_install.sh

echo '==================================> BEFORE_SCRIPT'

. $DRONE_CURRENT_BUILD_DIR/.drone/before-script.sh

echo '==================================> SCRIPT'

cd $BOOST_ROOT/libs/$SELF
ci/travis/cppcheck.sh

echo '==================================> AFTER_SUCCESS'

. $DRONE_CURRENT_BUILD_DIR/.drone/after-success.sh
