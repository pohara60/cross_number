#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
export EXCLUDE="/Couplets/primecuts2/SumSquares/" # This is very slow
if [ $# -ne 0 ]; then
    files="$*"_test.dart
else
    # files=*_test.dart
    allfiles=`dart run ../bin/crossnumber.dart | grep hardcoded | awk '{print $1;}'`
    files=""
    for file in $allfiles
    do
        if [ ! -f ${file}_test.dart ]; then
            files=$files" $file"
        fi
    done
    echo $files
fi
./runTests.sh $files
