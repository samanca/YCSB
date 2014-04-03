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

echo "==================== mongod --journal (x1) ==================="
./run_all.sh "$MODE" "$FS" "journal" 1
sleep 10s

echo "==================== mongod --journal (x4) ==================="
./run_all.sh "$MODE" "$FS" "journal" 4
sleep 10s

echo "==================== mongod --journal (x16) ==================="
./run_all.sh "$MODE" "$FS" "journal" 16
echo "Exit mongod and run it with --nojournal, then press any key for x1"
read -n 1

echo "=================== mongod --nojournal (x1) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 1
sleep 10s

echo "=================== mongod --nojournal (x4) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 4
sleep 10s

echo "=================== mongod --nojournal (x16) =================="
./run_all.sh "$MODE" "$FS" "nojournal" 16
