#!/bin/bash

set -ex

echo ">>>>> APT: REPO.."
for i in {1..3}; do sudo -E apt-add-repository -y "ppa:ubuntu-toolchain-r/test" && break || sleep 2; done

# Moved to Docker
#
# if [[ $CXX =~ ^clang || $TOOLSET =~ ^clang || $B2_TOOLSET =~ ^clang || $COMPILER =~ ^clang ]]; then
#     Default Travis Installation of clang-7
#     Newer method (need to update OS version info)
#     DEFAULT_LLVM_OS=$(awk -F= '$1=="DISTRIB_RELEASE" { print $2 ;}' /etc/lsb-release)
#     DEFAULT_LLVM_VER="7.0.1"
#     wget https://releases.llvm.org/$DEFAULT_LLVM_VER/clang+llvm-$DEFAULT_LLVM_VER-x86_64-linux-gnu-ubuntu-$DEFAULT_LLVM_OS.tar.xz
#     apt-get -o Acquire::Retries=3 update && apt-get -o Acquire::Retries=3 -y install git
#     mkdir -p /usr/local/clang+llvm-7.0.1 && tar xf clang+llvm-$DEFAULT_LLVM_VER-x86_64-linux-gnu-ubuntu-$DEFAULT_LLVM_OS.tar.xz -C  /usr/local/clang+llvm-$DEFAULT_LLVM_VER --strip-components=1
#     export PATH="/usr/local/clang+llvm-$DEFAULT_LLVM_VER/bin:$PATH"
# fi

if test -n "${LLVM_OS}" ; then
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
    if test -n "${LLVM_VER}" ; then
	sudo -E apt-add-repository "deb http://apt.llvm.org/${LLVM_OS}/ llvm-toolchain-${LLVM_OS}-${LLVM_VER} main"
    else
        # Snapshot (i.e. trunk) build of clang
	sudo -E apt-add-repository "deb http://apt.llvm.org/${LLVM_OS}/ llvm-toolchain-${LLVM_OS} main"
    fi
fi

echo ">>>>> APT: UPDATE.."
sudo -E apt-get -o Acquire::Retries=3 update
echo ">>>>> APT: INSTALL ${PACKAGES}.."
sudo -E apt-get -o Acquire::Retries=3 -y --no-install-suggests --no-install-recommends install ${PACKAGES}

# Moved to Docker
#
# MAJOR_VERSION=$(lsb_release -r -s | cut -c 1-2)
# if [ "$MAJOR_VERSION" -lt "20" ]; then
#     sudo -E apt-get -o Acquire::Retries=3 -y install python python-pip
# fi
# 
# if [ "$MAJOR_VERSION" -gt "18" ]; then
#     sudo -E apt-get -o Acquire::Retries=3 -y install python3 python3-pip
#     ln -s /usr/bin/python3 /usr/bin/python
#     ln -s /usr/bin/pip3 /usr/bin/pip
# fi
# 
# # Install pip packages
# 
# if [ "$MAJOR_VERSION" -gt "14" ]; then
#     pip install cmake
# fi
