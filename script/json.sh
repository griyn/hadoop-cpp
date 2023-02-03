# 输入seqfile，转换为json输出

${HADOOP_BIN} ustreaming \
    -conf ${HADOOP_CONF} \
    -jobconf mapred.job.map.capacity=5000 `# 控制并发`\
    -jobconf mapred.job.reduce.capacity=1 \
    -jobconf mapred.output.compress=true `# 压缩产出结果`\
    -jobconf mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec `# gz格式压缩，10~6:1`\
    -jobconf mapred.reduce.tasks=1 \
    -jobconf mapred.job.name=${JOB_NAME} \
    -jobconf mapred.job.priority=${PRIORITY} \
    -jobconf mapred.hce.replace.streaming=false \
    -jobconf mapred.reduce.memory.limit=8000 \
    -jobconf mapred.textoutputformat.ignoreseparator=true \
    -jobconf mapred.map.tasks.speculative.execution=false `# 禁止启动Task Attempts` \
    -jobconf mapred.max.map.failures.percent=1 `# 允许mapper失败` \
    -cacheArchive ${HADOOP_PYTHON_PATH} \
    -output $OUTPUT \
    -input $INPUT \
    -inputformat org.apache.hadoop.mapred.SequenceFileAsBinaryInputFormat `# input seqfile`\
    -outputformat org.apache.hadoop.mapred.TextOutputFormat `# output text`\
    -file "seq2json" \
    -file "baidu_product" \
    -mapper "./seq2json" \
    -reducer "NONE" \
    -mapinstream binary \
    -mapoutstream text

# 把mapper的数据汇用reducer总到一个文件
-jobconf mapred.reduce.tasks=1
-reducer "cat"
