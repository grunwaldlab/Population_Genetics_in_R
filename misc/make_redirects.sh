#!/bin/bash

collate="$1"
redirect="$2"

while read line
do
    name=$line
    newname=`printf $name | cut -d _ -f 2-`
    if [[ "$newname" != "$name" ]]
    then
    	cp $redirect $name
    	printf "$name -> $newname\n"
	   	perl -p -i -e 's/http:.+?in_R\//'$newname'/g' $name
	else
		printf "$name\n"
	fi
    
done < $collate