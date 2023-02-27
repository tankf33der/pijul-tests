#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

pijul fork 2
pijul channel switch 2
tar -xJf ../../pijul-tests/kernel/linux-2.0.2.tar.xz --strip-components=1
add
record
eq 2324121175 "$(cksum Makefile | awk '{print $1}')"

pijul channel switch main
eq 1115719611 "$(cksum Makefile | awk '{print $1}')"

echo "OK--fork-kernels"
