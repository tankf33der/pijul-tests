#!/usr/bin/env bash
set -x -e

# shuf
u=$(uname)
if [ "$u" = "NetBSD" ]; then
	exit 0;
fi

dd='dd if=/dev/urandom of=p.dat bs=1024 count=1024'

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

for _ in {0..128}; do
	eval "$dd"
	xz -fk p.dat
	pijul add p.dat.xz
	record
	pijul tag create -m.
done

# milestone #1 "--to-channel"
for T in $(pijul tag | grep State | cut -f2 -d ' ' | shuf); do
	pijul tag checkout --to-channel mike "$T"
	xz -t p.dat.xz
	pijul channel switch main
	pijul channel delete mike
done

# milestone #2 "reset"
for T in $(pijul tag | grep State | cut -f2 -d ' ' | shuf); do
	pijul tag reset "$T"
	xz -t p.dat.xz
	pijul reset --force
done

echo "OK--tag-checkout"
