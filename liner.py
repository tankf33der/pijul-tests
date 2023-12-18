#!/usr/bin/env python3

import random

with open('mike', 'r') as f:
    lines = []

    for line in f:
        line = line.strip()
        lines.append(list(line))

random.shuffle(lines[random.randint(0, len(lines)-1)])

with open('mike', 'a') as f:
    f.seek(0)
    f.truncate()

    for line in lines:
        f.write(f"{''.join(line)}\n")
