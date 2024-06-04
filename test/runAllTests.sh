#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
cd $ROOT/test
EXCLUDE="/Couplets/primecuts2/SumSquares/" # This is very slow
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
            if [[ "$EXCLUDE" =~ "/$puzzle/" ]]; then
                echo Exclude $puzzle
            else
                echo Running $puzzle
                result=/tmp/"$puzzle"_result.txt
                sedresult=/tmp/"$puzzle"_result.sed.txt
                S1='s/[0-9]:[0-9]+:[0-9]+\.[0-9]+/#.##.##.######/'
                S2='s/cartesianCount=[0-9]+/cartesianCount=#/'
                SED="$S1;$S2"
                dart run $ROOT/bin/crossnumber.dart $puzzle > $result 
                sed -r $SED < $result > $sedresult
                sedoutput=/tmp/"$puzzle"_output.sed.txt
                sed -r $SED $output > $sedoutput
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