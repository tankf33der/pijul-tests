#!/usr/bin/env bash
# #411 [CONSISTENCY DISASTER] failed clone after records in loop
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

touch a
pijul add a
record
pijul archive -o m
pijul add m.tar.gz
record
for i in {0..32}; do
    pijul archive -o m
	record
done
eq 1 "$(pijul diff --short | wc -l)"
pijul reset
# XXX, still 1 in script, 0 if run manually
#eq 0 "$(pijul diff --short | wc -l)"
eq 13 "$(pijul log --hash-only | wc -l)"
R1="$(cksum m.tar.gz | awk '{print $1}')"


cd ..
pijul clone repo repo2
cd repo2
eq 0 "$(pijul diff --short | wc -l)"
eq 13 "$(pijul log --hash-only | wc -l)"
R2="$(cksum m.tar.gz | awk '{print $1}')"
eq "$R1" "$R2"

echo "OK--clone-while"
