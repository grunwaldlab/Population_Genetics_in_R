#!/bin/bash

collate="$1"
redirect="$2"

while read line
do
    name=$line
    newname=`printf $name | cut -d _ -f 2-`
    printf "$newname\n"
   	if [[ $name != $newname ]]
   	then
   		printf "$name -> old/$name\n"
   		newrmd=`printf $newname | cut -d \. -f 1`
   		printf "$newrmd.Rmd\n"
   		cp $name $newname
   		cp $name old/$name
   		cd old
   		pwd
   		cp ../$redirect $name
    	printf "$name -> $newname\n"
	   	perl -p -i -e 's/http:.+?in_R\//'$newname'/g' $name
	   	cd ..
	   	pwd
   	else
   		printf "$name\n"
   	fi
    
done < $collate

printf "../$redirect\t../$collate\n"