#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

# 2027 files, 121 dirs
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
eq 2143 "$(pijul ls | wc -l)"
record
zero "$(pijul diff --short | wc -l)"
eq 2143 "$(pijul ls | wc -l)"

echo "OK--add"
