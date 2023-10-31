#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
EXCLUDE="dummy" #"dicenets2"
if [ $# -ne 0 ]; then
    files="$*"_test.dart
else
    files=*_test.dart
fi
for file in $files
do
    puzzle=${file%_test.dart}
    dir=$ROOT/lib/$puzzle
    if [ -d "$dir" ]; then
        output=$dir/"$puzzle"_output.txt
        if [ -f "$output" ]; then
            if [ "$puzzle" == $EXCLUDE ]; then
                echo Eclude $puzzle
            else
                echo Diffing $puzzle
                result=/tmp/"$puzzle"_result.txt
                sedresult=/tmp/"$puzzle"_result.sed.txt
                sedoutput=/tmp/"$puzzle"_output.sed.txt
                cmp $sedoutput $sedresult >/dev/null 2>&1
                if [ "$?" == 1 ]; then
                    code --diff $sedoutput $sedresult
                else 
                    echo "OK"
                fi
            fi
        fi
    else
        echo Skip $puzzle
    fi
done