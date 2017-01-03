#!/usr/bin/env bash

g_schema_dir=${HBASE_SCHEMA_DIR}
g_keytab_file=${KRB_KEYTAB_DIR}/${MY_USER}.keytab

h_name=`hostname`
# Wait HBase master and Thrift
while true; do
    dockerize \
        -wait tcp://${h_name}:${HBASE_MASTER_PORT} \
        -wait tcp://${h_name}:${HBASE_THRIFT_PORT} \
        -timeout 2s
    if [[ $? -eq 0 ]]; then
        break
    fi
done

kinit -kt ${g_keytab_file} ${MY_USER}

echo "Creating HBase schema..."
# execute all .sh
for fp in `ls ${g_schema_dir}/*.sh`; do
    if [[ -f ${fp} ]]; then
        ${fp}
    fi
done
# execute all *.txt files
for fp in `ls ${g_schema_dir}/*.txt`; do
    if [[ -f ${fp} ]]; then
        hbase shell ${fp}
    fi
done

my_service "register" ${HBASE_SERVICE_NAME}
