#!/usr/bin/env bash
set -x -e

cd ..
rm -rf pjtemp

for _ in {0..10}; do
	pijul clone https://nest.pijul.com/pijul/pijul pjtemp
	rm -rf pjtemp
done

echo "OK--clone-loop"
