#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

cp ../../pijul-tests/utf8.txt .
cp ../../pijul-tests/utf8-sum.py .
cp ../../pijul-tests/utf8-shuffle.py .

# ready!
./utf8-sum.py utf8.txt
add
record

for _ in {0..8}; do
	./utf8-shuffle.py utf8.txt
	mv utf8-2.txt utf8.txt
	record
done

# clone
cd ..
pijul clone repo repo2
cd repo2
./utf8-sum.py utf8.txt

# fork
cd ../repo
pijul fork fork1
pijul channel switch fork1
./utf8-sum.py utf8.txt
pijul channel switch main

# channel new
pijul channel new new1
pijul channel switch new1
./utf8-sum.py utf8.txt
pijul channel switch main

# tag
pijul tag create -m"."
LAST="$(pijul tag  | grep State | awk '{print $2}')"
pijul tag checkout "$LAST"
pijul channel switch "$LAST"
./utf8-sum.py utf8.txt

echo "OK--utf8"
