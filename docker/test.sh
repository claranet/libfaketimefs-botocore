#!/usr/bin/env bash

# The old version of libfaketime used in this test does not support
# the environment variables FAKETIME_TIMESTAMP_FILE and FAKETIME_NO_CACHE
# but they are required to use libfaketimefs. Use them here as an example
# more than anything.

echo '+3 days' > /etc/faketimerc
echo $(date +%s) > /etc/realtime

export LD_PRELOAD=/usr/lib64/faketime/libfaketime.so.1
export FAKETIME_TIMESTAMP_FILE=/etc/faketimerc
export FAKETIME_REALTIME_FILE=/etc/realtime
export FAKETIME_NO_CACHE=1

python test.py
