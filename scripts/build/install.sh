#!/usr/bin/env bash

set -e

mkdir -p ${HBASE_PID_DIR} ${HBASE_LOG_DIR}
chown ${HBASE_USER} ${HBASE_PID_DIR} ${HBASE_LOG_DIR}
