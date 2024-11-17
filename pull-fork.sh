#!/usr/bin/env bash
set -x -e

p='patch'
u=$(uname)
if [ "$u" = "FreeBSD" ] || [ "$u" = "NetBSD" ]; then
	p='gpatch'
fi

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

cd ../repo2
pijul pull -a
cd ../repo

for i in {2..40}; do
    xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | "$p" -Esp1
    add
    record

    cd ../repo2
    pijul fork "$i"
    pijul pull -a --from-channel main --to-channel "$i"
    pijul channel switch "$i"
    H="$(pijul log --hash-only | head -1)"
    pijul apply "$H" --channel main
    pijul channel switch main
    cd ../repo
done

cd ../repo2
eq 40 "$(pijul channel | wc -l)"

cd ..
eqfiles repo/Makefile repo2/Makefile

echo "OK--pull-fork"
