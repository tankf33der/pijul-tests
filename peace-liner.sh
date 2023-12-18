#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

# ready!
cp ../../pijul-tests/liner.py .
cp ../../pijul-tests/peace-and-war.txt .

# step 1
pijul add peace-and-war.txt
record

for _ in {0..128}; do
	./liner.py
	record
done

# step 2
cd ..
pijul clone repo repo2
cd repo2
pijul pull -a

cd ..
pijul clone repo2 repo3
cd repo3
pijul pull -a

# step 3, delete file and push
cd ..
cd repo3
pijul remove peace-and-war.txt
record
pijul push -a

# final step, push second bulk of records
cd ..
cd repo
for _ in {0..128}; do
	./liner.py
	record
done
cd ..
cd repo2
pijul pull -a
# the fin

echo "OK--peace-liner"
