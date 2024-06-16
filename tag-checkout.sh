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

eval "$dd"
xz -fk p.dat
pijul add p.dat.xz
record

for _ in {0..128}; do
	eval "$dd"
	xz -fk p.dat
	record
	pijul tag create -m.
done

# milestone #1 "--to-channel"
for T in $(pijul tag | grep State | cut -f2 -d ' ' | shuf); do
	pijul tag checkout --to-channel mike "$T"
   	xz -t p.dat.xz
   	pijul channel switch mike
    xz -t p.dat.xz
	pijul channel switch main
	pijul channel delete mike
done

# milestone #2 "reset"
for T in $(pijul tag | grep State | tail -128 | cut -f2 -d ' ' | shuf); do
	pijul tag reset "$T"
	eq 1 "$(pijul diff -s | wc -l)"
	xz -t p.dat.xz
	pijul reset --force
done

# milestone #3
pijul channel new m
pijul channel switch m

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record
for i in {2..40}; do
	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	record

	pijul tag create -m.
	H="$(pijul tag | head -1 | awk '{print $2}')"
	pijul tag checkout "$H"
	zero "$(pijul diff --channel "$H" | wc -l)"
done


echo "OK--tag-checkout"
