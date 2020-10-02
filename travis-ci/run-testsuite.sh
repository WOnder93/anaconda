#!/usr/bin/env bash
# SPDX-License-Identifier: MIT

# Based on SELinux userspace CI scripts from:
# https://github.com/SELinuxProject/selinux

set -ex

#
# Move to the selinux testsuite directory.
#
cd "$HOME/anaconda"

./scripts/testing/dependency_solver.py | xargs -d '\n' \
	dnf install -y make 'python3dist(polib)' 'python3dist(pocketlint)' \
		'python3dist(pylint)' 'python3dist(rpmfluff)'

ln -sf /usr/bin/python3 /usr/bin/python

./autogen.sh
./configure
make -j$(nproc)
make ci || {
	cat tests/test-suite.log
	exit 1
}
