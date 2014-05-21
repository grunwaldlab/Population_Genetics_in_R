


Appendix 2. Function glossary
=====

To quit R you can either use the Rstudio>Quit Rstudio pulldown menu command or execute ⌘+Q (OS X) or CTRL+Q (PC). 

Navigation in R
----


```r
getwd()        # this command will print the current working directory
ls()           # list objects in the current workspace
help(options)  # learn about available options
history()      # viewing your command history
data(*dsname*) # access builtin database *dsname*; must have pacakge loaded containing it
q()            # quit your R session

# default for saving history is ".Rhistory"
savehistory(file="myfile")  # save your command history for whole session
loadhistory(file= "myfile") # recall command history save

# Package specific information
installed.packages()[,c("Package","Version")] #list packages & versions installed
browseVignettes()                     # see vignettes from all packages

#Help on functions
help(functionname)     # Display documentation for a function
args(functionname)     # What are the arguments for a given function
example(functionname)  # see examples of function calls
```



*Poppr* functions
----

Our primer is heavily based on the *poppr* and *adegenet* packages. To get help on any of their functions type a question mark before the empty function call as in:


```r
# Information on pacakges or functions
browseVignettes(package = 'poppr')    # see vignettes for poppr
vignette('poppr_manual')              # see manual for poppr
?mlg()           # open the R documentiaon of the function mlg()

# Poppr functions
help(package="poppr")   # shows all functions contained in poppr package

```



References
----------


