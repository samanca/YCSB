#!/bin/bash
if [ ! -z $1 ]; then
    FS=$1
else 
    FS="pmfs"
fi

if [ ! -z $2 ]; then
    MODE=$2
else
    MODE="single"
fi

# TODO support for replica-sets should be considered

# record start time
BEG=`date +%s`

# remove db log file if exists
rm -f /root/mongodb/db.log

# start mongod with --journal
./../mongo/mongod --dbpath=/mnt/pmfs/db --journal --fork --logpath=/root/mongodb/db.log --logappend

# running tests
echo "==================== mongod --journal (x1) ==================="
./run_all.sh "$MODE" "$FS" "journal" 1
sleep 10s

echo "==================== mongod --journal (x4) ==================="
./run_all.sh "$MODE" "$FS" "journal" 4
sleep 10s

echo "==================== mongod --journal (x16) ==================="
./run_all.sh "$MODE" "$FS" "journal" 16

# stop running mongod instance
./kill_mongod.sh 27017 safe
sleep 5s

# cleaning data directory
echo "clean up ..."
rm -rf /mnt/pmfs/db/*

# start mongod with --nojournal
./../mongo/mongod --dbpath=/mnt/pmfs/db --nojournal --fork --logpath=/root/mongodb/db.log --logappend

# running tests
echo "=================== mongod --nojournal (x1) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 1
sleep 10s

echo "=================== mongod --nojournal (x4) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 4
sleep 10s

echo "=================== mongod --nojournal (x16) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 16

# stop running mongod instance
./kill_mongod.sh 27017 safe

# print execution time
END=`date +%s`
let EXECTIME="$END - $BEG"
echo "Total execution time = ${EXECTIME}s"
