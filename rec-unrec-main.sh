#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/401
set -x -e

sed='sed'
p='patch'
u=$(uname)
if [ "$u" = "FreeBSD" ]; then
	sed='gsed'
	p='gpatch'
elif [ "$u" = "Darwin" ]; then
	sed='gsed'
fi


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

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | "$p" -sp1
   add
   record
done

# milestone #1
eq 0 "$(pijul diff --short | wc -l)"

pijul fork m1
pijul channel switch m1
for i in {0..38}; do
	H=$(pijul log --hash-only | head -1)
	pijul unrecord "$H" --reset
done
eq 386 "$(pijul diff -su | wc -l)"

# milestone #2
pijul channel switch main
eq 6 "$(pijul diff -su | wc -l)"

pijul channel switch m1
eq 386 "$(pijul diff -su | wc -l)"
H=$(pijul log --hash-only | head -1)
pijul unrecord "$H" --reset
eq 2529 "$(pijul diff -su | wc -l)"

# milestone #3
pijul channel switch main
eq 45 "$(pijul diff -su | wc -l)"

# milestone #4
H="$(pijul log --hash-only | tail -2 | head -1)"
pijul apply "$H" --channel m1
pijul channel switch m1
echo "MIKEMIKE" >> mike
cat Makefile >> mike
mv mike Makefile
echo "MIKEMIKE" >> mike
record
$sed -i '1d;$d' Makefile
record
crc Makefile 322996445

# milestone #5
pijul channel switch main
H="$(pijul log --hash-only | head -1)"
pijul apply "$H" --channel m1
pijul channel switch m1
crc Makefile 2090994418

echo "OK--rec-unrec-main"
