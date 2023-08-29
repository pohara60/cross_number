#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
for puzzle in $*
do
    dir=$ROOT/lib/$puzzle
    if [ -d "$dir" ]; then
        output=$dir/"$puzzle"_output.txt
        if [ -f "$output" ]; then
            result=/tmp/"$puzzle"_result.txt
            if [ -f "$result" ]; then
                #dart run $ROOT/bin/crossnumber.dart $puzzle $result 
                cp $result $output
                echo Copied $puzzle
            fi
        fi
    fi
done