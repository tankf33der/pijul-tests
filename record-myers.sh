#!/usr/bin/env bash
set -x -e

python='python3'
u=$(uname)
if [ "$u" = "NetBSD" ]; then
	python='python3.12'
fi

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
"$python" ./utf8-sum.py utf8.txt
add
record

for _ in {0..128}; do
	"$python" ./utf8-shuffle.py utf8.txt
	mv utf8-2.txt utf8.txt
	record

	cd ..
	pijul clone repo repo2
	cd repo2
	"$python" ./utf8-sum.py utf8.txt
	cd ..
	rm -rf repo2
	cd repo
done

# clone
cd ..
pijul clone repo repo2
cd repo2
"$python" ./utf8-sum.py utf8.txt

# fork
cd ../repo
pijul fork fork1
pijul channel switch fork1
"$python" ./utf8-sum.py utf8.txt
pijul channel switch main

# channel new
pijul channel new new1
pijul channel switch new1
"$python" ./utf8-sum.py utf8.txt
pijul channel switch main

# tag
pijul tag create -m"."
LAST="$(pijul tag  | grep State | awk '{print $2}')"
pijul tag checkout "$LAST"
pijul channel switch "$LAST"
"$python" ./utf8-sum.py utf8.txt

echo "OK--record-myers"
