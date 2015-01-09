
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))

all: clean html

toc:
	perl update_toc.pl -t toc.txt -v -html include/before_body.html

html: $(HTML_FILES)

%.html: %.Rmd
	R --slave -e "rmarkdown::render('$<')"


.PHONY: clean
clean:
	$(RM) $(HTML_FILES)
