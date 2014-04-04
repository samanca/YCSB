#!/bin/bash
if [ ! -z $1 ]; then
    PRIMARY_PORT=$1
else
    PRIMARY_PORT=27019
fi

if [ ! -z $2 ] && [ "$2" == "safe" ]; then
    SIGNAL=1
else
    SIGNAL=9
fi

PRIMARY_PID=`netstat -tlpn "$PRIMARY_PORT" | grep :"$PRIMARY_PORT" | awk '{ print $7 }' | grep /mongod | awk -F\/ '{ print $1 }'`
kill -"$SIGNAL" $PRIMARY_PID
echo "killing mongod process: $PRIMARY_PID"
