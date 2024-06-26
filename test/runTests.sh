#!/bin/bash
ROOT=~/Documents/Development/Dart/cross_number
EXCLUDED=
for file in $*
do
    puzzle=${file%_test.dart}
    dir=$ROOT/lib/$puzzle
    if [ -d "$dir" ]; then
        output=$dir/"$puzzle"_output.txt
        if [ -f "$output" ]; then
            if [[ "$EXCLUDE" =~ "/$puzzle/" ]]; then
                echo Exclude $puzzle
                EXCLUDED=$EXCLUDED" $puzzle"
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
if [ -n "$EXCLUDED" ]; then
    echo Excluded $EXCLUDE
fi