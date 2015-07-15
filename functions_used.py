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
	funklist = list()
	for funk in funks:
		if not re.match('\$|\[|\<|\+', funk):
			funklist.append(funk)
	pkgdict[package] = funklist



# make another loop through pkgdict and write the appendix by package.

# Read in toc.txt
toc = io.open("toc.txt")
chapters = dict()
startin = False
for line in toc:
	line.strip()
	if re.match("Introduction", line):
		startin = True
	if not line.strip():
		startin = False
		next
	if startin == True:
		chapters[line.strip()] = list()

toc.close()

# Scan through files and save the code chunks in list
for chapter in chapters.keys():
	chapter_file = io.open(chapter + u'.Rmd')
	its_a_chunk = False
	for line in chapter_file:
		chunk_start = re.match(r'```\{r', line)
		chunk_hide = re.match(r'```\{r.+?echo\s*\=\s*FALSE', line)
		chunk_end = re.match(r'```\n', line)
		if chunk_start and not chunk_hide:
			its_a_chunk = True

		if its_a_chunk and chunk_end: 
			its_a_chunk = False

		if its_a_chunk:
			chapters[chapter].append(line.strip())

	chapter_file.close()

funpendix = io.open("funpendix.Rmd", "w")
funpendix.writelines([u'---\n', u'title: A2: Function Glossary\n', u'---\n'])
for chapter in chapters.keys():
	funpendix.writelines(u'# ' + chapter + u'\n\n')
	for line in chapters[chapter]:
		if re.match("^\#", line):
			next
		for package in pkgdict.keys():
			for funk in pkgdict[package]:
				if re.match(funk, line):
					funpendix.writelines(u' - ' + funk + u'\n')
	funpendix.writelines(u'\n')

funpendix.close()
# for package in pkgdict.keys():
# 	pkg = pkgdict[package]
# 	print(pkg.keys())