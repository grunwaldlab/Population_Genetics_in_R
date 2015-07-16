#!/usr/bin/env python2.7


'''
Description:

	functions_used.py is a script designed specifically for the Population
	Genetics in R webpage. It has no guarantee of doing anything remotely useful
	outside of this page.

Motivation: 

	Create a script that will find all of the user-facing function calls within
	the Rmd documents and render an Rmd document to serve as an appendix of all
	the functions used in the primer.

Execution:
	
	This utilizes rpy2 in order to import the R packages and get a list of
	objects in their respective namespaces. It then compiles a dictionary where
	the keys are function names and the values are the packages where they were
	first found. This means that overlapping namespaces will take the first
	package always. After this, it reads the toc.txt file and grabs all of the
	main chapters, placing them into a list and a dictionary. Each dictionary
	will contain a list in which all the lines within code chunks will be
	stored. After the code chunks are stored in the chapter dictionary, it is
	once more iterated over and each line not starting with an escape is
	analyzed with find_functions. Functions are detected by searching for an
	opening round brace. These are placed into a set as a markdown table row
	with the function name and the link to the R package. Each chapter is added
	to another dictionary for the chapters and then the chapter list is iterated
	over in order and the functions are written to a table in the output file.
'''

import getopt
import sys
import io 
import re 
import rpy2
import rpy2.robjects as robjects
import rpy2.robjects.packages as rpackages

def usage():
	print("\n%s by Zhian N. Kamvar, 2015-07-15" % sys.argv[0])
	print("Software comes with no warranty.")
	print("Usage:\n\tpython %s [-vh]" % sys.argv[0])
	print("Optional:")
	print("\t-v = verbose")
	print("\t-v = show this help and exit")
	print("")
	sys.exit(2)

'''
Try to find all the functions in a line of code.

line      - a unicode string of code
functions - a dictionary containing keys of function names and package names as
			values
outset	  - a set in which to add the output
'''
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

'''
Enter into an Rmd file and grab the name of the chapter.

chapter - the name of the Rmd file without extension.
'''
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

if __name__ == '__main__':

	verbose = False
	myopts, args = getopt.getopt(sys.argv[1:2], "vh")
	for opt, arg in myopts:
		if opt == "-v":
			verbose = True
		if opt == "-h":
			usage()

	# Load all of the R packages and grab their namespaces
	#-------------------------------------|
	if verbose:
		print("Importing packages ...")
	poppr = rpackages.importr('poppr')
	pegas = rpackages.importr('pegas')
	adegenet = rpackages.importr('adegenet')
	ape = rpackages.importr('ape')
	mmod = rpackages.importr('mmod')
	magrittr = rpackages.importr('magrittr')
	treemap = rpackages.importr('treemap')

	pkgs = ["poppr", 
			"pegas", 
			"adegenet", 
			"ape", 
			"mmod", 
			"magrittr", 
			"treemap"]

	if verbose:
		print("Gathering functions ...")
	robjects.r('''
			poppr.funks    <- ls('package:poppr')
			pegas.funks    <- ls('package:pegas')
			adegenet.funks <- ls('package:adegenet')
			ape.funks      <- ls('package:ape')
			mmod.funks     <- ls('package:mmod')
			magrittr.funks <- ls('package:magrittr')
			treemap.funks  <- ls('package:treemap')
	        ''')
	if verbose:
		print("Creating function dictionary ...")
	functions = dict()
	for package in pkgs:
		# print('Package: ' + package + '\n==========\n')
		funks = robjects.r[package + '.funks']
		# print(funks)
		for funk in funks:
			if not re.match('\$|\[|\<|\+|(^plot$)', funk, re.UNICODE):
				if not functions.has_key(funk):
					functions[funk] = package

	# Read in toc.txt
	#-------------------------------------|

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
	#-------------------------------------|
	if verbose:
		print("Scanning chapters for code chunks ...")
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

	# Create a dictionary of the functions for each chapter
	#-------------------------------------|
	if verbose:
		print("Extracting functions ...")
	table_of_fun = dict()
	for chapter in chapters.keys():
		funset = set()
		for line in chapters[chapter]:
			if re.match("^\#", line):
				next
			else:
				funlist = find_functions(line, functions, funset)
		table_of_fun[chapter] = funset

	# Open a new file and write the header
	#-------------------------------------|
	if verbose:
		print("Writing funpendix.Rmd ...")
	funpendix = io.open("funpendix.Rmd", "w")
	funpendix.writelines([u'---\n', u'title: "A2: Function Glossary"\n', u'---\n'])
	funpendix.writelines([u'\n\nBelow are functions that were utilized in the making ',
				u'of this primer with links to their respective packages.', 
				u' Note that this list was automatically generated and might '
				u'be missing some functions.', u'\n\n'])

	# Move through the chapters in order and print the section header with the
	# function table.
	#-------------------------------------|
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
	if verbose:
		print("Done.")
