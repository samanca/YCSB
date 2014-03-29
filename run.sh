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
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" 2>err.txt 1>out.txt
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27017 -p mongodb.database="$DB" 2>>err.txt 1>>out.txt
else
    #./bin/ycsb load mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>/dev/null
    #./bin/ycsb load mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB"
    ./bin/ycsb load mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>err.txt 1>out.txt
    #./bin/ycsb run mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>/dev/null
    #./bin/ycsb run mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB"
    ./bin/ycsb run mongodb -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB" 2>>err.txt 1>>out.txt
fi
