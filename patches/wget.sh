#!/usr/bin/env bash
set -x -e

for i in {2..3}; do
    wget https://cdn.kernel.org/pub/linux/kernel/v4.x/patch-4.14.${i}.tar.xz
done
