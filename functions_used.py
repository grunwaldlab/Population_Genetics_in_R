#!/usr/bin/env python2.7

import io
import sys 
import re 
import getopt 
import os
import rpy2
import rpy2.robjects as robjects
import rpy2.robjects.packages as rpackages

poppr = rpackages.importr('poppr')
pegas = rpackages.importr('pegas')
adegenet = rpackages.importr('adegenet')
ape = rpackages.importr('ape')
mmod = rpackages.importr('mmod')
magrittr = rpackages.importr('magrittr')
treemap = rpackages.importr('treemap')

pkgs = ["poppr", "pegas", "adegenet", "ape", "mmod", "magrittr", "treemap"]

robjects.r('''
        poppr.funks <- ls('package:poppr')
        pegas.funks <- ls('package:pegas')
		adegenet.funks <- ls('package:adegenet')
		ape.funks <- ls('package:ape')
		mmod.funks <- ls('package:mmod')
		magrittr.funks <- ls('package:magrittr')
		treemap.funks <- ls('package:treemap')
        ''')

pkgdict = dict()
for package in pkgs:
	print('Package: ' + package + '\n==========\n')
	funks = robjects.r[package + '.funks']
	print(funks)
	funkdict = dict()
	for funk in funks:
		funkdict[funk] = 0
	pkgdict[package] = funkdict


# Scan through files and save the code chunks in list
# make another loop through pkgdict and write the appendix by package.

# Read in toc.txt
toc = io.open("toc.txt")
tocdict = dict()
startin = False
for line in toc:
	line.strip()
	if re.match("Introduction", line):
		startin = True
	if not line.strip():
		startin = False
		next
	if startin == True:
		tocdict[line.strip()] = list()

toc.close()

for chapter in tocdict.keys():
	chapter_file = io.open(chapter + u'.Rmd')
	is_chunk = False
	for line in chapter_file:
		chunk_start = re.match(r'```\{r', line)
		chunk_end = re.match(r'```\n', line)
		if chunk_start:
			is_chunk = True

		if is_chunk and chunk_end: 
			is_chunk = False

		if is_chunk:
			tocdict[chapter].append(line.strip())

	chapter_file.close()


# for package in pkgdict.keys():
# 	pkg = pkgdict[package]
# 	print(pkg.keys())