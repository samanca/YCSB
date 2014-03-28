#!/bin/bash
WL="workload"
DB="test"
./bin/ycsb load mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB"
./bin/ycsb run mongodb -s -P "$WL" -p mongodb.url=localhost:27018,localhost:27019 -p mongodb.database="$DB"
