#!/usr/bin/python
#coding:utf-8
import sys

last_key0 = None
last_key1 = None

for line in sys.stdin:
    line = line.strip()
    if len(line) == 0:
        continue
    fields = line.split('\t')
    if fields[1] == "0":
        last_key0 = fields[0]
    elif fields[1] == "1":
        if fields[0] == last_key0:
            sys.stdout.write("joined:%s\n" % last_key0)
    else:
        sys.stderr.write("error fields[1]:%s\n" % fields[1])
