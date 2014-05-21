


Chapter 2. Getting ready to use R
=====

R provides a unique environment for performing population genetic analyses. You will particularly enjoy not having to switch data formats and operating systems to execute a series of analyses, as was the case until now. Furthermore, R provides graphing capabilities that are ready for use in publications, with only a little bit of extra effort. But first, let's install R, install an integrated development environment, open R, and load R packages. 

Installing R
-----

1. Download and install the [R](http://www.r-project.org) statistical computing and graphing environment. This works cross-platform on Windows, OS X and Linux operating systems. 

2. Download and install the [Rstudio IDE](http://www.rstudio.com/ide/) that we recommend as an integrated development environment.

3. Download and install [poppr](http://grunwaldlab.cgrb.oregonstate.edu/poppr-r-package-population-genetics) and all its dependencies (<a href="http://dx.doi.org/10.7717/peerj.281">Kamvar et al. 2014</a>).

In your R console, type:


```r
install.packages("poppr")
```


*Poppr* is an R package. You can think of a package as a library of functions written and curated by someone in the R user community, which you can loaded into R for use. We wrote and actively maintain *poppr*.

Once you've installed *poppr*, you can invoke it by typing or cutting + pasting:


```r
library(poppr)
```


This will load poppr and all dependent packages, such as *adegenet* and *ade4*. You will recognize loading by the prompts written to your screen.

Congratulations. You should be all set for using R. Loading data and conducting your first analysis will be the topic of the next chapter. 

A quick introduction to R using Rstudio
----

First, let's review some of the basic features and functions of R. To start R, open the Rstudio application from your programs folder or start menu. This will initialize your R session. To exit R, simply close the Rstudio application. 

> Note that R is a case sensitive language!

Let's get comfortable with R by submitting the following command on the command line (where R prompts you with a `>` in the lower left Rstudio window pane) that will retrieve the current working directory on your machine:


```r
getwd()        # this command will print the current working directory
```


> Note that the symbol '#' is used to add comments to your code and you just type `getwd()` after the ">".

Other useful commands providing information on your system include:


```r
help(options)  # learn about available options
installed.packages()[,c("Package","Version")] #list packages & versions installed
data(<name>, package = "package") # load a specific data set from a specific package.
```


To quit R you can either use the Rstudio>Quit Rstudio pull-down menu command or execute ⌘+Q (OS X) or CTRL+Q (PC). 

Our primer is heavily based on the *poppr* and *adegenet* packages. To get help on any of their functions type a question mark before the empty function call as in:


```r
?mlg           # open the R documentiaon of the function mlg()
```



Some useful resources to learn R:
-----

*Free resources*:

 - [Code School Try R](https://www.codeschool.com/courses/try-r) is a nice interactive tutorial. 
 - [Quick R](http://www.statmethods.net/interface/help.html)
 - [R reference card](http://cran.r-project.org/doc/contrib/Short-refcard.pdf)

*Books*:

 - [R in a Nutshell](http://oreilly.com/catalog/9780596801717) 
 - [R cookbook]() is a nice quick reference and tutorial for general R use.
 - [ggplot2: Elegant Graphics for Data Analysis]() is a great reference if you want to customize graphs for publication. 

Packages and getting help
----

Some packages include vignettes that can have different formats such as being introductions, tutorials, or reference cards in PDF format. You can look at a list of vignettes in all packages by typing:


```r
browseVignettes()                     # see vignettes from all packages
browseVignettes(package = 'poppr')    # see vignettes from a specific package.
```



and to look at a specific vignette you can type:


```r
vignette('poppr_manual')
```


References
----------
<p> Z. Kamvar, J. Tabima, N. Gr&uuml;nwald,   (2014) Poppr: an R package for genetic analysis of populations with clonal, partially clonal, and/or sexual reproduction.  <em>PeerJ</em>  <strong>2</strong>  e281-NA  <a href="http://dx.doi.org/10.7717/peerj.281">10.7717/peerj.281</a></p>


