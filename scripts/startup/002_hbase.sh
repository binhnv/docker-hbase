#!/usr/bin/env bash

g_schema_dir=${HBASE_SCHEMA_DIR}
g_keytab_file=${KRB_KEYTAB_DIR}/${MY_USER}.keytab

h_name=`hostname`
# wait for master service
my_tcp_wait ${h_name} ${HBASE_MASTER_PORT}
# wait for thrift service
my_tcp_wait ${h_name} ${HBASE_THRIFT_PORT}
# Hadoop is ready when we reach here so no need to wait for Kerberos
# it should be ready already
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
