
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))

all: clean toc appendix html

toc:
	perl update_toc.pl -t toc.txt -v -html include/before_body.html

appendix:
	python make_appendix.py -v

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
