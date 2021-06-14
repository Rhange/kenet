#!/bin/sh -e

die() {
  message=$1
  [ -z "$message" ] && message="Died"
  echo "$message" >&2
  exit 1
}

cd "$(dirname "$0")"

trap 'sleep 1 && (jobs -p | xargs -r kill -9)' EXIT

export TZ=Asia/Seoul

rm -f result-*.txt

date >>result.txt
echo "* lsb_release -a"
lsb_release -a | tee -a result.txt || echo "N/A" >>result.txt
echo "" >>result.txt

echo "* /proc/cpuinfo"
tee -a result.txt </proc/cpuinfo || echo "N/A"
echo "" >>result.txt

./benchmark-2-memory-usage/build/install/benchmark-2-memory-usage/bin/benchmark-2-memory-usage &
sleep 0.5
./quit/build/install/quit/bin/quit
sleep 1

java -jar benchmark-3-execution-image-size/build/libs/benchmark-3-execution-image-size-all.jar &
sleep 0.5
./quit/build/install/quit/bin/quit
sleep 1
