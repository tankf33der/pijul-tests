#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo2

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record
eq 2143 "$(pijul ls | wc -l)"

for i in {2..40}; do
	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done
pijul push -a

# milestone 1
cd ..
eq "$(cksum repo/Makefile | awk '{print $1}')" "$(cksum repo2/Makefile | awk '{print $1}')"

# milestone 2
cd repo
pijul channel new milestone2
cd ../repo2
# shellcheck disable=SC2006,SC2046
pijul push ../repo --to-channel milestone2 -- `pijul log --hash-only | sort -R`
cd ../repo
pijul channel switch milestone2
eq 2090994418 "$(cksum Makefile | awk '{print $1}')"

echo "OK--push"
