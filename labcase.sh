#!/bin/bash

if [ -z $1 ] 
then
  echo error! no argument. Should be yes or no.
  exit 6

fi

#to lower case:
TEXT=$(echo $1 | tr [:upper:] [:lower:])

case $TEXT in 
yes)  
  echo that\'s nice
;;
no)
  echo im sorry to hear that
;;
*)
  echo unknown argument provided;
esac
