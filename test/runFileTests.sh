#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
export EXCLUDE="/Couplets/primecuts2/SumSquares/" # This is very slow
if [ $# -ne 0 ]; then
    files="$*"_test.dart
    export EXCLUDE=
else
    files=*_test.dart
    echo $files
fi
./runTests.sh $files
