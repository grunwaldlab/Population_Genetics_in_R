Population Genetics in R
---

*Niklaus J. Gr&uuml;nwald, Zhian N. Kamvar, and Sydney E. Everhart*

Welcome! This primer provides a concise introduction to conducting applied
analyses of population genetic data in R, with a special emphasis on non-model
populations including clonal or partially clonal organisms. It provides a
valuable resource for tackling the nitty-gritty analysis of populations that do
not necessarily conform to textbook genetics and might or might not be in Hardy-
Weinberg equilibrium and panmixia. While this primer does not require extensive
knowledge of programming in R, the user is expected to install R and all
packages required for this primer.

Please note that this primer is still being written and will be changing as we
continue writing it. Please provide us feedback on any errors you might find or
suggestions for improvement. The primer is currently published
[here](http://grunwaldlab.github.io/Population_Genetics_in_R/).


&copy; 2015, Corvallis, Oregon, USA

>*I was really impressed with what you've accomplished with [poppr], it is very thoughtful and addressed a number of things I never considered but which many pop gen folks that I know deal with all the time and complain about.  I think it is going to be very well received by the community.* 

-- Andy Jones, Assistant Professor, Oregon State University, Corvallis, OR, 2014.


Technical details
=========

This website was set up much in the same manner as the [rmarkdown
website](http://rmarkdown.rstudio.org). All files are written and executed
within the main directory of this repository.

Setup
=========

In order to compile the website, a few things are needed:

1. The most recent R version
1. The [Rstudio IDE](http://rstudio.org)
2. The [Rmarkdown package](http://rmarkdown.rstudio.com)
3. The [knitcitations package](https://github.com/cboettig/knitcitations)
2. This script to run the content of the website: 
    - `install.packages(c("poppr", "mmod", "genetics", "magrittr"))`
3. perl

Once all things are installed, you can edit the `*.Rmd` files and then run:

```sh
make all
```

If everything is installed correctly, the website should compile perfectly and
you can view it by opening `index.html`.

Adding a new page
==========

If you want to add a new page to the website, there are a couple of steps
needed:

1. Add your page in Rmarkdown format (`*.Rmd`).
2. Add the basename of the new page to `toc.txt` in the appropriate place
   (preface, body, or appendix).
3. Add the proper HTML list tag to `include/before_body.html`.

For example, if you wanted to add a new chapter called "Mantel Tests" after the
Population Structure chapter, you would do the following:

- Name the file `Mantel_Test.Rmd`
- In `toc.txt`, add the name of the file (Note, Arrows added for emphasis.):

```
prefix:
start:i
Preface

prefix:
start:1
Introduction
Getting_ready_to_use_R
Data_Preparation
First_Steps
Population_Hierarchies
Locus_Stats
Genotypic_EvenRichDiv
Linkage_disequilibrium
Pop_Structure
>>> Mantel_Test <<<
AMOVA
DAPC

prefix:A
start:1
Data_sets
Function_Glossary
Intro_to_R
```

- Modify `include/before_body.html` and run `make all`:

```html
<!-- Some stuff up here -->
               <li><a href="Linkage_disequilibrium.html">8. Linkage disequilibrium</a></li>
               <li><a href="Pop_Structure.html">9. Population structure</a></li>
<!-- HERE >--> <li><a href="Mantel_Test.html">9. Mantel Tests</a></li> <!-- <<<<<<<< HERE -->
               <li><a href="AMOVA.html">10. AMOVA</a></li>
<!-- more stuff down here -->
```

Note that you don't need to change the number, when you run `make all`, the perl
script `update_toc.pl` will automatically update the HTML from the table of
contents.