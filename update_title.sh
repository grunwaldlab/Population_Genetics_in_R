#!/bin/bash
#
# Note that this script is to be called by update_toc.pl
# Written by Zhian N. Kamvar
# License: GPLv3

rmd="$1"
html="$2"
num="$3"
prefix="$4"

# Change the number in the title section of the Rmd file.
perl -p -i -e 's/(title\: [[:punct:]]'$prefix')[[:digit:]]*[[:punct:]]\s*/${1}'$num': /g' "$rmd.Rmd"

# Change the number of the TOC dropdown menu.
perl -p -i -e 's/('$rmd'\.html\">)[[:digit:]]+?\.\s*/${1}'$num'. /' $html | grep $rmd