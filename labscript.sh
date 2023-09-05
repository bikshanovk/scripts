#!/bin/bash

if [ -z $1 ] 
then
  echo Error! No argument. Should be yes or no.
elif [ $1 = "yes" ] 
then  
  echo thats nice
elif [ $1 = "no" ]
then  
  echo I\'m sorry to hear that
else 
  echo "Unknown first argument provided; Should be yes or no."
fi

echo ---

if [ $# -gt 1 ] # $# - counting the number of arguments
then
 k=1            # string number variable
 echo Addition info about arguments:
 echo You have entered $# arguments:
 for i in $@    # $@ - collection of arguments
 do
    echo $k. $i
    ((k=k+1))
 done
 echo ---
fi



