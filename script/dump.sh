# 按行输入文件，每个mapper获得一行作为输入
# 输出seqfile

${HADOOP_BIN} ustreaming \
    -conf ${HADOOP_CONF} \
    -jobconf mapred.job.map.capacity=30 `# 控制并发`\
    -jobconf mapred.job.map.over.capacity=false `# 限制并发在30内。hadoop会在资源空闲的时候超并发执行`\
    -jobconf mapred.map.over.capacity.allowed=false `# 同上，配合使用`\
    -jobconf mapred.job.reduce.capacity=1 \
    -jobconf mapred.reduce.tasks=1 \
    -jobconf mapred.job.name=${JOB_NAME} \
    -jobconf mapred.job.priority=${PRIORITY} \
    -jobconf mapred.hce.replace.streaming=false `# ?`\
    -jobconf mapred.reduce.memory.limit=8000 \
    -jobconf mapred.textoutputformat.ignoreseparator=true `# streaming以kv形式组织输出，当mapper输出只有key时，避免在末尾自动添加\t`\
    -jobconf mapred.map.tasks.speculative.execution=false `# 禁止启动Task Attempts` \
    -jobconf mapred.max.map.failures.percent=1 `# 允许mapper失败比例` \
    -cacheArchive ${HADOOP_PYTHON_PATH} \
    -output $OUTPUT \
    -input $INPUT \
    -inputformat org.apache.hadoop.mapred.lib.NLineInputFormat `# input task per line` \
    -outputformat org.apache.hadoop.mapred.SequenceFileAsBinaryOutputFormat `# output seqfile`\
    -file "tera_dump" \
    -file "tera.flag" \
    -file "mapper_pc_deadlink_dump.sh" \
    -mapper "sh mapper_pc_deadlink_dump.sh" \
    -reducer "NONE" \
    -mapinstream text \
    -mapoutstream binary
