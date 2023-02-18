#!/usr/bin/env bash

set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

for _ in {0..128}; do
   touch "$(mktemp mike-XXXXX)"
   add
   record
done

pijul tag create -m "mike"
LAST="$(pijul tag  | grep State | head -1 | awk '{print $2}')"
pijul tag checkout "$LAST"
pijul channel switch "$LAST"
eq 129 "$(find . -name "mike-*" | wc -l)"

echo "OK--tag-mktemp"
