#!/usr/bin/env bash

set -x -e

dd='dd if=/dev/urandom of=A.dat bs=1024 count=512'

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo2

touch A.dat
cksum A.dat | awk '{print $1}' > A.meta
add
record
for _ in {0..128}; do
pijul push -a
cd ../repo

name=$(cat A.meta)
str "$name" "$(cksum A.dat | awk '{print $1}')"
cd ../repo2
eval "$dd"
cksum A.dat | awk '{print $1}' > A.meta
record
done

echo "OK--b-pushmeta"
