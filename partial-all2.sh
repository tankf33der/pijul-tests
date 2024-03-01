#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

mkdir a
cd a
tar -xJf ../../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
	xzcat ../../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done

cd ..
mkdir b
cd b
tar -xJf ../../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
	xzcat ../../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done
cd ..
cd ..

# milestone #1
pijul clone --path a repo a
pijul clone --path b repo b
pijul log --hash-only --repository a > a.records
pijul log --hash-only --repository b > b.records
eq 41 "$(cat a.records | wc -l)"
eq 41 "$(cat b.records | wc -l)"
eq 1 "$(comm -12 <(sort a.records) <(sort b.records) | wc -l)"

# milestone #2
# expecting latest record for kernel 2.0.40
eq 1 "$(head a/a/Makefile | grep -c 40)"

# milestone #3
zero "$(diff -qr a/a b/b | wc -l)"
zero "$(diff -qr a/a repo/a | wc -l)"
zero "$(diff -qr a/a repo/b | wc -l)"

echo "OK--partial-all2"
