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

functions = dict()
for package in pkgs:
	# print('Package: ' + package + '\n==========\n')
	funks = robjects.r[package + '.funks']
	# print(funks)
	for funk in funks:
		if not re.match('\$|\[|\<|\+|(^plot$)', funk, re.UNICODE):
			if not functions.has_key(funk):
				functions[funk] = package

def find_functions(line, functions, outset):
	words = line.strip().split(u' ')
	# print(words)
	for word in words:
		if len(word) < 1:
			next
		funks = word.split(u'(')
		if len(funks) > 1:
			for funk in funks:
				if functions.has_key(funk):
					pkg = functions[funk]
					funk_out = u'**`' + funk + u'`** | [*' + pkg + u'*](http://cran.r-project.org/package=' + pkg + u') |'
					# print(funk_out)
					outset.add(funk_out)
		else:
			next
	return(outset)

def get_chapter_title(chapter):
	chapfile = io.open(chapter + u'.Rmd')
	got_it = False
	for line in chapfile:
		if re.match(r'title: ', line, re.UNICODE):
			the_line = line.strip()
			the_line = line.split("'")
			if (len(the_line)) == 1:
				the_line = line.split("\"")
			the_line = the_line[1]
			break
	chapfile.close()
	return(the_line)

# make another loop through functions and write the appendix by package.

# Read in toc.txt
toc = io.open("toc.txt")
chapters = dict()
chapterlist = list()
startin = False
for line in toc:
	line.strip()
	if re.match("Introduction", line):
		startin = True
	if not line.strip():
		startin = False
		next
	if startin == True:
		the_chapter = line.strip()
		chapters[the_chapter] = list()
		chapterlist.append(the_chapter)

toc.close()

# Scan through files and save the code chunks in list
for chapter in chapters.keys():
	chapter_file = io.open(chapter + u'.Rmd')
	its_a_chunk = False
	for line in chapter_file:
		chunk_start = re.match(r'```\{r', line, re.UNICODE)
		chunk_hide = re.match(r'```\{r.+?echo\s*\=\s*FALSE', line, re.UNICODE)
		chunk_end = re.match(r'```\n', line, re.UNICODE)

		if chunk_start and not chunk_hide and not its_a_chunk:
			its_a_chunk = True

		if its_a_chunk and chunk_end: 
			its_a_chunk = False

		if its_a_chunk and not chunk_start:
			chapters[chapter].append(line.strip())

	chapter_file.close()

table_of_fun = dict()
for chapter in chapters.keys():
	funset = set()
	for line in chapters[chapter]:
		if re.match("^\#", line):
			next
		else:
			funlist = find_functions(line, functions, funset)
	table_of_fun[chapter] = funset

funpendix = io.open("funpendix.Rmd", "w")
funpendix.writelines([u'---\n', u'title: "A2: Function Glossary"\n', u'---\n'])
funpendix.writelines([u'\n\nBelow are functions that were utilized in the making ',
					u'of this primer with links to their respective packages.', 
					u' Note that this list was automatically generated and might '
					u'be missing some functions.', u'\n\n'])
for chapter in chapterlist:
	the_title = get_chapter_title(chapter)
	funpendix.writelines(u'### [' + the_title + u'](' + chapter + u'.html)\n\n')
	funlist = list(table_of_fun[chapter])
	funlist.sort()
	if len(funlist) > 0:
		funpendix.writelines([u' | **Function** | **Package** |\n',
							  u' |--------------|-------------|\n'])
		for function in funlist:
			# print(function)
			funpendix.writelines(u' | ' + function + u'\n')
	else:
		funpendix.writelines(u'No functions used in this chapter.\n')
	funpendix.writelines(u'\n')

funpendix.close()
# for package in pkgdict.keys():
# 	pkg = pkgdict[package]
# 	print(pkg.keys())