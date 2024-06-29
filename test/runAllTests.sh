#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
export EXCLUDE="/Couplets/primecuts2/SumSquares/" # This is very slow
if [ $# -ne 0 ]; then
    files="$*"_test.dart
else
    # files=*_test.dart
    files=`dart run ../bin/crossnumber.dart | grep hardcoded | awk '{print $1;}'`
    echo $files
fi
./runTests.sh $files
