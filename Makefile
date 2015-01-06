
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))

all: clean html


html: $(HTML_FILES)

oldrmd:
	R -e "devtools::install_github('rstudio/rmarkdown', ref = 'b96214b9ac86b437067a0aa21442203f52face83')"

newrmd:
	R -e "install.packages('rmarkdown', repo = 'http://cran.at.r-project.org')"

%.html: %.Rmd
	R --slave -e "rmarkdown::render('$<')"


.PHONY: clean
clean:
	$(RM) $(HTML_FILES)
