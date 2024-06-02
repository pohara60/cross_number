#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
if [ $# -ne 0 ]; then
    files="$*"_test.dart
else
    # files=*_test.dart
    files=`dart run ../bin/crossnumber.dart | grep hardcoded | awk '{print $1;}'`
    echo $files
fi
for file in $files
do
    puzzle=${file%_test.dart}
    dir=$ROOT/lib/$puzzle
    if [ -d "$dir" ]; then
        output=$dir/"$puzzle"_output.txt
        if [ -f "$output" ]; then
            result=/tmp/"$puzzle"_result.txt
            if [ -f "$result" ]; then
                sedresult=/tmp/"$puzzle"_result.sed.txt
                sedoutput=/tmp/"$puzzle"_output.sed.txt
                cmp $sedoutput $sedresult >/dev/null 2>&1
                if [ "$?" == 1 ]; then
                    cp $result $output
                    cp $sedresult $sedoutput
                    echo Copied $puzzle
                fi
            fi
        fi
    else
        echo Skip $puzzle
    fi
done