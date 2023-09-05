



#!/bin/bash

if [ -z $1 ]
then
    echo Error! No argument. Please insert minutes.
    echo Please enter duration in minutes:
        read MINUTES
    else
        MINUTES=$1
fi

((SECONDS=$MINUTES*60))
#SECONDS=2
echo Duration in seconds: $SECONDS

for ((counter=$SECONDS; counter>0; counter--));
do
if [ $counter -gt 1 ]
    then
        clear
        echo $counter seconds remaining
    else
        clear
        echo 1 second remaining
    fi
        sleep 1
done

echo Time is up
echo You are late

SECONDS=5
while [ $SECONDS -gt 1 ]
do
    let "SECONDS-=1"
    #SECONDS=$(( $SECONDS - 1 ))
    SECONDS=$((--SECONDS))
    echo $SECONDS
    sleep 1
done
