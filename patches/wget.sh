#!/usr/bin/env bash
set -x -e

for i in {1..335}; do
    wget https://cdn.kernel.org/pub/linux/kernel/v4.x/incr/patch-4.14.${i}-$((i+1)).xz
done

