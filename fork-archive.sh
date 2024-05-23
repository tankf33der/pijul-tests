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
eq 2143 "$(pijul ls | wc -l)"

for i in {2..40}; do
	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done

#1 milestone 
pijul fork try
pijul archive --channel try --prefix try -o try
mv try.tar.gz ..
cd ..
tar zxf try.tar.gz
eq 1 "$(diff -ur try repo | wc -l)"

#2 milestone
cd repo
pijul diff --channel try -su
pijul channel switch try
rm -rf net
record
zero "$(pijul diff -su | wc -l)"
eq 1 "$(pijul diff --channel main -su | wc -l)"
pijul channel switch main
eq 133 "$(pijul diff --channel try -su | wc -l)"

echo "OK--fork-archive"
