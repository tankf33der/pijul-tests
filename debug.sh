#!/usr/bin/env bash
set -x -e

source ./functions.sh

for _ in {0..50}
do
	pijul debug
	pijul record -am"."
done
