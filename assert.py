import sys

p = int(sys.argv[1])
f = open("A.txt", "r")
l = f.readlines()[p]
assert(p == l.index(str(p)))
