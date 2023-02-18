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
pijul archive -o archive

mkdir -p ../new
tar -xzf archive.tar.gz -C "../new"

mkdir -p ../old
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz -C "../old" --strip-components=1

eq 1 "$(diff -qr ../old ../new | wc -l)"

pijul fork a
pijul archive -o a --channel a
mkdir -p ../a
tar -xzf a.tar.gz -C "../a"
zero "$(diff -qr ../new ../a | wc -l)"

rm -rf ../old ../new ../a

echo "OK--archive"
