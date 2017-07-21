

# Get the names of all Rmarkdown files in the directory.
myRmd <- list.files('.', pattern = '.Rmd$')

# Omit child files.
myChildren <- system('grep "r child" *.Rmd', intern = TRUE)
myChildren <- unlist(lapply(strsplit(myChildren, "r child = "), function(x){x[2]}))
myChildren <- gsub("eval=F", "", myChildren)
myChildren <- gsub("[[:space:]]", "", myChildren)
myChildren <- gsub("[}\\']", "", myChildren)
myChildren <- unique(myChildren)

myRmd <- myRmd[!myRmd %in% myChildren]



# Get library calls
# This is necessary for NCmisc::list.functions.in.file
# to assign a function to a package.
myPacks <- system('grep "library(" *.Rmd', intern = TRUE)
# Omit comments
myPacks <- unlist(lapply(strsplit(myPacks, "#"), function(x){x[1]}))
myPacks <- grep("library", myPacks, value = TRUE)

# Sanitize
myPacks <- unlist(lapply(strsplit(myPacks, "library\\("), function(x){x[2]}))
myPacks <- gsub("\"", "", myPacks, fixed = TRUE)
myPacks <- gsub("[[:space:]]", "", myPacks)
myPacks <- gsub(")", "", myPacks)
myPacks <- gsub("\\'", "", myPacks)

myPacks <- sort(unique(myPacks))
# Things I didn't catch.
myPacks <- grep("loadslibraries,inthiscase", myPacks, invert = TRUE, value = TRUE)
myPacks <- grep("intern=TRUE", myPacks, invert = TRUE, value = TRUE)

lapply(myPacks, require, character.only = TRUE)

# Collect functions

# Initialize from first file.
tmp <- tempfile()
myFile <- knitr::purl(myRmd[1], tmp, quiet = TRUE)
myFunc_all <- suppressWarnings( NCmisc::list.functions.in.file(myFile) )  

cat_list <- function(base_list, new_list){
  myNames <- names(new_list)
  for(i in 1:length(myNames)){
    base_list[[ myNames[i] ]] <- c(base_list[[ myNames[i] ]], new_list[[ myNames[i] ]])
    base_list[[ myNames[i] ]] <- unique(base_list[[ myNames[i] ]])
  }
  base_list
}

#for(i in 2:4){
#
for(i in 2:length(myRmd)){
  myFile <- knitr::purl(myRmd[i], tmp, quiet = TRUE)
  myFunc <- suppressWarnings( NCmisc::list.functions.in.file(myFile) )
  if( length(myFunc) > 0 ){
    myFunc_all <- cat_list(myFunc_all, myFunc)
  }
  print(paste("myRmd ", i, ": ", length(unlist(myFunc_all)), sep = ""))
}

# Omit character(0)
myFunc_all <- myFunc_all[-1]
# Omit base and utils
myFunc_all <- myFunc_all[grep('base|utils', names(myFunc_all), invert = TRUE)]
# Omit plot
myFunc_all <- myFunc_all[-1]


names(myFunc_all) <- sub("package:", "", names(myFunc_all))

myFunc_all <- myFunc_all[order(names(myFunc_all))]
names(myFunc_all)

# Print
for(i in 1:length(myFunc_all)){
  cat("## ")
  cat(names(myFunc_all)[i])
  cat("\n")
  myFunc_all[[i]]
  write(myFunc_all[[i]], file = "")
  cat("\n")
}

