#!/usr/bin/env python3

import sys, random

def get_next_character(f):
    c = f.read(1)
    while c:
        yield c
        c = f.read(1)

d = []

with open(sys.argv[1], encoding="utf-8") as f:
    for c in get_next_character(f):
        d.append(ord(c))
f.close()

random.shuffle(d)

with open("utf8-2.txt", "a", encoding="utf-8") as f:
    for c in d:
        f.write(chr(c))
f.close()
