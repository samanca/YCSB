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

if [ ! -z $3 ]; then
    WrConc=$3
else
    WrConc="safe"
fi

if [ ! -z $4 ]; then
    $THREADS=$4
else
    $THREADS=1
fi

if [ ! -z $3 ] && [ "$3" = "single" ]; then
    echo "Single mode"
    ./bin/ycsb load mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" -p mongodb.writeConcern="$WrConc" 2>err.txt 1>histogram_load.txt
    echo "H-Load complete"
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" -p mongodb.writeConcern="$WrConc" 2>>err.txt 1>histogram_run.txt
    echo "H-Run complete"
    sleep 5s
    ./bin/ycsb load mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27017 -p mongodb.database="{$DB}_2" -p mongodb.writeConcern="$WrConc" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_load.txt
    echo "T-Load complete"
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27017 -p mongodb.database="{$DB}_2" -p mongodb.writeConcern="$WrConc" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_run.txt
    echo "T-Run complete"
else
    echo "Replica-Set mode"
    ./bin/ycsb load mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" -p mongodb.writeConcern="$WrConc" 2>err.txt 1>histogram_load.txt
    echo "H-Load complete"
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" -p mongodb.writeConcern="$WrConc" 2>>err.txt 1>>histogram_run.txt
    echo "H-Run complete"
    sleep 5s
    ./bin/ycsb load mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="${DB}_2" -p mongodb.writeConcern="$WrConc" -p measurementtype=timeseries -p timeseries.granularity=5 2>>err.txt 1>timeseries_load.txt
    echo "T-Load complete"
    sleep 3s
    ./bin/ycsb run mongodb -P "$WL" -threads "$THREADS" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="${DB}_2" -p mongodb.writeConcern="$WrConc" -p measurementtype=timeseries -p timeseries.granularity=5  2>>err.txt 1>>timeseries_run.txt
    echo "T-Run complete"
fi
