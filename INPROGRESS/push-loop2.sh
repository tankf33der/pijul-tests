#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init p1
pijul clone p1 p2
cd p2

touch a
pijul add a
pijul rec -am.

touch b
pijul add b
pijul rec -am.

pijul push --path a -a

echo "2" >> a
pijul rec -am.
echo "2" >> a
pijul rec -am.

echo "2" >> b
pijul rec -am.

echo "3" >> a
echo "3" >> b
pijul rec -am.

pijul push --path a -a
