#!/usr/bin/python
#coding:utf-8

import sys
import os

# 获取文件夹名字
filepath = os.environ["map_input_file"]
filename = os.path.split(filepath)[0].split('/')[-1] 
sys.stderr.write("filepath:%s\n" % filepath)
sys.stderr.write("filename:%s\n" % filename)

for line in sys.stdin:
    line = line.strip()
    if len(line) == 0:
        continue
    if filename == "join_input_test1":
        # 解析方式和文件内容的格式有关，这里 line 就是 key
        sys.stdout.write("%s\t%s\n" % (line, "0"))
    elif filename == "join_input_test2":
        sys.stdout.write("%s\t%s\n" % (line, "1"))
    else:
        sys.stderr.write("error filename\n")
