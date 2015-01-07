#!/bin/bash

collate="$1"
redirect="$2"

while read line
do
    name=$line
    newname=`printf $name | cut -d _ -f 2-`
    printf "$newname\n"
   	cp $name $newname
   	if [[ $name != $newname ]]
   	then
   		mv $name old
   	fi
    
done < $collate