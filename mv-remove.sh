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

touch a
pijul add a
record
pijul mv a b
record
pijul remove b
record

pijul mv drivers mike1
record
pijul mv mike1 drivers
record
zero "$(pijul ls | grep -c mike1)"
eq 2143 "$(pijul ls | wc -l)"

pijul fork remove
pijul channel switch remove
rm -rf drivers
record
zero "$(pijul ls | grep -c mike1)"
eq 1607 "$(pijul ls | wc -l)"

echo "OK--mv-remove"
