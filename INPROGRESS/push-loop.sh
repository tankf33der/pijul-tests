#!/usr/bin/env bash
set -x -e

source ./../functions.sh

cd ../..
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
