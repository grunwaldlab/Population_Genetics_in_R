
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))

all: clean toc html

toc:
	perl update_toc.pl -t toc.txt -v -html include/before_body.html

html: $(HTML_FILES)

oldrmd:
	R --slave -e "devtools::install_github('rstudio/rmarkdown', ref = 'b96214b9ac86b437067a0aa21442203f52face83')"

newrmd:
	R --slave -e "install.packages('rmarkdown', repo = 'http://cran.at.r-project.org')"

%.html: %.Rmd
	R --slave -e "rmarkdown::render('$<')"

# Render a single Rmd file. 
# $ make render f=myFile.Rmd
render: $(f) 
	R --slave -e "rmarkdown::render('$<')"

.PHONY: clean
clean:
	$(RM) $(HTML_FILES)

poppr_two:
	R --slave -e 'local({r <- getOption("repos"); r["CRAN"] <- "http://cran.at.r-project.org"; options(repos = r)}); devtools::install_github(c("emmanuelparadis/pegas/pegas", "thibautjombart/adegenet", "grunwaldlab/poppr@2.0-rc"))';
	
poppr_one:
	R --slave -e 'local({r <- getOption("repos"); r["CRAN"] <- "http://cran.at.r-project.org"; options(repos = r)}); install.packages(c("pegas", "adegenet", "poppr"))';