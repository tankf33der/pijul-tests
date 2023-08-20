#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/424
set -x -e

source ./functions.sh

T=$(date +%s)

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul fork Empty
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   pijul record --timestamp "$T" -am"." 1> /dev/null
done
cd Documentation
find . -type f -exec bash -c 'echo "mike" >> "$1"' _ {} \;
cd ..
echo "mike" >> Makefile
sed -i 's/SUBLEVEL/mike/g' Makefile

pijul record --timestamp "$T" -am"." 1> /dev/null
H="$(pijul log --hash-only | head -1)"

pijul apply "$H" --channel Empty
C="$(cksum Makefile | awk '{print $1}')"
pijul channel switch Empty
eq "$C" "$(cksum Makefile | awk '{print $1}')"

echo "OK--apply-every"
