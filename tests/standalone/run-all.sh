#!/bin/bash
#
# Copyright (C) 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# 
# Copyright (c) 2013 Dmitry Moskalchuk <dm@crystax.net>.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 
#    2. Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY Dmitry Moskalchuk ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dmitry Moskalchuk OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation
# are those of the authors and should not be interpreted as representing
# official policies, either expressed or implied, of Dmitry Moskalchuk.
# 

# The code for this test is borrowed from $NDK/test/run-tests-all.sh
#

# This simple script will create standalone toolchains for all supported
# GCC versions and for all supported CPU architectures and then it will
# run all required tests.
#

PROGDIR=`dirname $0`
NDK=`cd $PROGDIR/../.. && pwd`
NDK_BUILDTOOLS_PATH=$NDK/build/tools
. $NDK/build/core/ndk-common.sh
. $NDK/build/tools/prebuilt-common.sh

TAGS=$HOST_TAG32

#
# Run standalone tests
#
STANDALONE_TMPDIR=$NDK_TMPDIR

# $1: Host tag
# $2: API level
# $3: Arch
# $4: GCC version
standalone_path ()
{
    local TAG=$1
    local API=$2
    local ARCH=$3
    local GCC_VERSION=$4

    echo ${STANDALONE_TMPDIR}/android-ndk-api${API}-${ARCH}-${TAG}-${GCC_VERSION}
}

# $1: Host tag
# $2: API level
# $3: Arch
# $4: GCC version
# $5: LLVM version
make_standalone ()
{
    local TAG=$1
    local API=$2
    local ARCH=$3
    local GCC_VERSION=$4
    local LLVM_VERSION=$5

    (cd $NDK && \
     ./build/tools/make-standalone-toolchain.sh \
        --platform=android-$API \
        --install-dir=$(standalone_path $TAG $API $ARCH $GCC_VERSION) \
        --llvm-version=$LLVM_VERSION \
        --toolchain=$(get_toolchain_name_for_arch $ARCH $GCC_VERSION) \
        --system=$TAG)
}

API=14
LLVM_VERSION=$DEFAULT_LLVM_VERSION

echo "DEFAULT_ARCHS            =  $DEFAULT_ARCHS"
echo "DEFAULT_GCC_VERSION_LIST =  $DEFAULT_GCC_VERSION_LIST"
echo "LLVM_VERSION             =  $LLVM_VERSION"
echo "TAGS                     =  $TAGS"

for ARCH in $(commas_to_spaces $DEFAULT_ARCHS); do
    for GCC_VERSION in $(commas_to_spaces $DEFAULT_GCC_VERSION_LIST); do
        for TAG in $TAGS; do
            ####dump "### [$TAG] Testing $ARCH gcc-$GCC_VERSION toolchain with --sysroot"
            ####(cd $NDK && \
            ####    ./tests/standalone/run.sh --prefix=$(get_toolchain_binprefix_for_arch $ARCH $GCC_VERSION $TAG)-gcc)
            dump "### [$TAG] Making $ARCH gcc-$GCC_VERSION standalone toolchain"
            make_standalone $TAG $API $ARCH $GCC_VERSION $LLVM_VERSION
            dump "### [$TAG] Testing $ARCH gcc-$GCC_VERSION standalone toolchain"
            (cd $NDK && \
                ./tests/standalone/run.sh --no-sysroot \
                    --prefix=$(standalone_path $TAG $API $ARCH $GCC_VERSION)/bin/$(get_default_toolchain_prefix_for_arch $ARCH)-gcc)
            dump "### [$TAG] Testing clang in $ARCH gcc-$GCC_VERSION standalone toolchain"
            (cd $NDK && \
                ./tests/standalone/run.sh --no-sysroot \
                    --prefix=$(standalone_path $TAG $API $ARCH $GCC_VERSION)/bin/clang)
	    rm -rf $(standalone_path $TAG $API $ARCH $GCC_VERSION)
        done
    done
done

# clean up
rm -rf $STANDALONE_TMPDIR