#!/usr/bin/env bash
set -x -e


#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

mkdir a
cd a
for _ in {0..15}; do
   touch "$(mktemp mike-XXXX)"
   add
   record
done
cd ..
cd ..

pijul clone --path a repo a

echo "OK--clone-loop"
