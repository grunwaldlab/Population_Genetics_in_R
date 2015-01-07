#!/bin/bash

collate="$1"
redirect="$2"

while read line
do
    name=$line
    cp $redirect $name
    newname=`printf $name | cut -d _ -f 2-`
    printf "$newname\n"
   	perl -p -i -e 's/http:.+?in_R\//'$newname'/g' $name
    
done < $collate