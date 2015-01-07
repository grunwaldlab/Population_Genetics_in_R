#!/bin/bash

collate="$1"
redirect="$2"

while read line
do
    name=$line
    newname=`printf $name | cut -d _ -f 2-`
    printf "====================\n"
   	if [[ $name != $newname ]]
   	then
   		oldrmd=`printf $name | cut -d \. -f 1`
   		newrmd=`printf $newname | cut -d \. -f 1`
   		cachedir="cache"
   		oldcache=${oldrmd}_${cachedir}
   		newcache=${newrmd}_${cachedir}
   		filesdir="files"
   		oldfiles=${oldrmd}_${filesdir}
   		newfiles=${newrmd}_${filesdir}   		
   		printf "cp $name -> $newname\n"
   		cp $name $newname
   		printf "cp $oldrmd.Rmd -> $newrmd.Rmd\n"
   		cp $oldrmd.Rmd $newrmd.Rmd
   		printf "cp $name -> old/$name\n"
   		cp $name old/$name
   		printf "mv $oldrmd.Rmd -> old/$oldrmd.Rmd\n"
   		mv $oldrmd.Rmd old/$oldrmd.Rmd
   		printf "mv $oldcache/ -> $newcache/\n"
   		mv $oldcache/ $newcache/
   		printf "mv $oldfiles/ -> $newfiles/\n"
   		mv $oldfiles/ $newfiles/
   		printf "redirect $name -> $newname\n"
   		cp $redirect $name
	   	perl -p -i -e 's/http:.+?in_R\//'$newname'/g' $name
	   	perl -p -i -e 's/(A|C)[[:digit:]]+?_//g' $newrmd.Rmd
   	else
   		printf "$name\n"
   	fi
    
done < $collate

printf "$collate\t$redirect\n"