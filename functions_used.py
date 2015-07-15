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
ggplot2 = rpackages.importr('ggplot2')
mmod = rpackages.importr('mmod')
magrittr = rpackages.importr('magrittr')
treemap = rpackages.importr('treemap')

pkgs = ["poppr", "pegas", "adegenet", "ape", "ggplot2", "mmod", "magrittr", "treemap"]

robjects.r('''
        poppr.funks <- ls('package:poppr')
        pegas.funks <- ls('package:pegas')
		adegenet.funks <- ls('package:adegenet')
		ape.funks <- ls('package:ape')
		ggplot2.funks <- ls('package:ggplot2')
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

for package in pkgdict.keys():
	pkg = pkgdict[package]
	print(pkg.keys())

# make list of lists
# add functions to list by grabbing with robjects.r['package.funks']
