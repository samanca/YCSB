#!/bin/bash
if [ ! -z $1 ]; then
    WL=$1
else
    WL="workloads/insert_only"
fi

if [ ! -z $2 ]; then
    DB=$2
else
    DB="test"
fi

if [ ! -z $3 ] && [ "$3" = "single" ]; then
    echo "Single mode"
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" 2>err.txt 1>histogram_load.txt
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" 2>>err.txt 1>histogram_run.txt
    sleep 5s
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="{$DB}_2" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_load.txt
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="{$DB}_2" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_run.txt
else
    echo "Replica-Set mode"
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>err.txt 1>histogram_load.txt
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>>err.txt 1>>histogram_run.txt
    sleep 5s
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="{$DB}_2" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_load.txt
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="{$DB}_2" -p measurementtype=timeseries -p timeseries.granularity=5  2>>err.txt 1>>timeseries_run.txt
fi
