#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
EXCLUDE="/dummy/" #"dicenets2"
if [ $# -ne 0 ]; then
    files="$*"_test.dart
else
    files=*_test.dart
    echo $files
fi
./runTests.sh $files