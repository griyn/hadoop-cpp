#参考：
#1. https://blog.csdn.net/yang63515074/article/details/80451420
#2. http://www.crazyant.net/1112.html

# 在mapper中输入两个文件A B，按照key排序输出到reducer流式json
# mapper负责将A B文件行分别打标记
# partition以哈希分片，并以key+mark排序
# reducer流式json，连续输入为A和Bmark且相同key则为可join数据 

${HADOOP_BIN} streaming \
    -conf ${HADOOP_CONF} \
    -jobconf mapred.job.map.capacity=8000 `# 配合 mapper 限流`\
    -jobconf mapred.job.map.over.capacity=false \
    -jobconf mapred.job.reduce.capacity=8000 \
    -jobconf mapred.reduce.tasks=5000 \
    -jobconf mapred.job.name=${JOB_NAME} \
    -jobconf mapred.job.priority=${PRIORITY} \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner `# 对mapper的结果用指定的key哈希输出到reducer`\
    -jobconf num.key.fields.for.partition=1 `设置第一个字段为partation key，字段默认\t分隔`\
    -jobconf stream.num.map.output.key.fields=2 `根据前两个字段排序`\
    -jobconf mapred.hce.replace.streaming=false \
    -jobconf mapred.reduce.memory.limit=8000 \
    -jobconf mapred.textoutputformat.ignoreseparator=true \
    -jobconf mapred.map.tasks.speculative.execution=false `# 禁止启动Task Attempts` \
    -jobconf mapred.max.map.failures.percent=1 `# 允许mapper失败` \
    -cacheArchive ${HADOOP_PYTHON_PATH} \
    -output $OUTPUT \
    -input $INPUT \
    -file "mapper_join.py" \
    -file "reducer_join.py" \
    -mapper "python mapper_join.py" \
    -reducer "python reducer_join.py"
