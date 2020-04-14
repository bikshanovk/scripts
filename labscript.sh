#!/bin/bash

if [ -z $1 ] 
then
  echo error! no argument. Should be yes or no.
elif [ $1 = "yes" ] 
then  
  echo thats nice
elif [ $1 = "no" ]
then  
  echo im sorry to hear that
else 
  echo unknown argument provided;
fi
