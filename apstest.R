
myFile <- "apstest.txt"

writeLines(capture.output(sessionInfo()), myFile)
writeLines(capture.output(sessionInfo()))
cat("\n", file = myFile, append = TRUE)
cat("\n", file = myFile, append = TRUE)
cat("\n")
cat("\n")

myString <- "Testing to see if you are ready for the Population Genomics in R Workshop!"

cat(myString)
cat("\n")
cat("\n")
cat(myString, file = myFile, append = TRUE)
cat("\n", file = myFile, append = TRUE)
cat("\n", file = myFile, append = TRUE)

pkgTest <- function(x){
  if( suppressPackageStartupMessages( require(x, quietly = TRUE, character.only = TRUE)) ){
    myString <- paste(x, "is installed.")
#    print(myString)
#    write(myString)
    cat(myString)
    cat("\n")
    cat(myString, file = myFile, append = TRUE)
    cat("\n", file = myFile, append = TRUE)
  } else {
    myString <- paste(x, "is not installed.")
    cat(myString)
    cat("\n")
    cat(myString, file = myFile, append = TRUE)
    cat("\n", file = myFile, append = TRUE)
  }
  flush.console() 
}


myPackages <- c("adegenet", "ape", "cowplot", "dplyr", "ggplot2", "hierfstat", 
"igraph", "knitr", "lattice", "magrittr", "mmod", "pegas", "pinfsc50", 
"poppr", "RColorBrewer", "reshape2", "treemap", "vcfR", "vegan", 
"viridisLite")


for(i in 1:length(myPackages)){
  pkgTest(myPackages[i])
}

cat("\n", file = myFile, append = TRUE)

myString <- "Testing to see if you can load your data."


cat("\n")
#cat("\n")
cat(myString)
cat("\n")
cat(myString, file = myFile, append = TRUE)
cat("\n", file = myFile, append = TRUE)
#cat("\n", file = myFile, append = TRUE)


dataTest <- function(x){
  vcf <- read.vcfR(x, verbose = FALSE)
  myShow <- capture.output(vcf)
  cat("\n")
  cat("\n", file = myFile, append = TRUE)
  for(i in 1:length(myShow)){
    cat(myShow[i])
    cat("\n")
    cat(myShow[i], file = myFile, append = TRUE)
    cat("\n", file = myFile, append = TRUE)
  }
}

myData <- c("pinfsc50_filtered.vcf.gz", "prubi_gbs.vcf.gz")

for(i in 1:length(myData)){
  dataTest(myData[i])
}

