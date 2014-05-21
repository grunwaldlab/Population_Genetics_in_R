


Chapter 5. Locus stats, heterozygosity, HWE, Information index
=====

This chapter concerns analyzing statistics on a per-locus level. Remember that,
in population genetics, loci are unlinked and are therefore independent. While
there are statistics that analyze populations across loci, it is important to 
analyse each locus independently to make sure that one locus is not introducing
bias in the analysis. 

> **Note:** Many of these statistics are best for codominant data. 

## Locus Summary Statistics

A quick way to assess the quality of your loci is to asess the number, diversity,
expected heterozygosity, and evenness of the alleles at each locus. For an 
example, we'll use a data set of *P. infestans* from (<a href="">Goss et al. 2014</a>). First, we'll use the function `locus_table` to get all of the statistics
mentioned above. For documentation, use `?locus_table`.


```r
library(poppr) # Make sure poppr is loaded if you haven't done so already.
data(Pinf) # P. infestans data set from Mexico and South America
locus_table(Pinf)
```

```
## 
##  allele = Number of observed alleles
##  1-D = Simpson index
##  Hexp = Nei's 1978 expected heterozygosity
## ------------------------------------------
```

```
##       summary
## locus  allele    1-D   Hexp Evenness
##   Pi02 10.000  0.633  0.703    0.663
##   D13  25.000  0.884  0.921    0.587
##   Pi33  2.000  0.012  0.023    0.322
##   Pi04  4.000  0.578  0.771    0.785
##   Pi4B  7.000  0.669  0.780    0.707
##   Pi16  6.000  0.403  0.484    0.507
##   G11  21.000  0.839  0.881    0.544
##   Pi56  3.000  0.361  0.541    0.707
##   Pi63  3.000  0.413  0.619    0.641
##   Pi70  3.000  0.279  0.419    0.580
##   Pi89 11.000  0.615  0.677    0.578
##   mean  8.636  0.517  0.620    0.602
```


We can see here that we have widely variable number of alleles per locus and 
that we actually have a single locus that only has two alleles, 
Pi33. 
What's more is that this locus has low diversity, low expected heterozygosity
and is very uneven. This is a sign that this might be a phylogenetically
uninformative locus, where we have two alleles and one is ocurring at a minor
frequency. We should explore data analysis with and without this locus. Let's
first see if both of these alleles exist in both populations of this data set.


```r
locus_table(Pinf, pop = "North America")
```

```
## 
##  allele = Number of observed alleles
##  1-D = Simpson index
##  Hexp = Nei's 1978 expected heterozygosity
## ------------------------------------------
```

```
##       summary
## locus  allele    1-D   Hexp Evenness
##   Pi02  9.000  0.690  0.776    0.653
##   D13  21.000  0.895  0.940    0.684
##   Pi33  2.000  0.021  0.041    0.353
##   Pi04  4.000  0.545  0.727    0.764
##   Pi4B  5.000  0.596  0.745    0.736
##   Pi16  6.000  0.425  0.510    0.498
##   G11  15.000  0.824  0.883    0.625
##   Pi56  3.000  0.335  0.502    0.647
##   Pi63  3.000  0.310  0.465    0.568
##   Pi70  2.000  0.203  0.406    0.595
##   Pi89 11.000  0.627  0.690    0.549
##   mean  7.364  0.497  0.608    0.607
```

```r
locus_table(Pinf, pop = "South America")
```

```
## 
##  allele = Number of observed alleles
##  1-D = Simpson index
##  Hexp = Nei's 1978 expected heterozygosity
## ------------------------------------------
```

```
##       summary
## locus  allele   1-D  Hexp Evenness
##   Pi02   5.00  0.54  0.67     0.83
##   D13   13.00  0.83  0.90     0.67
##   Pi33   1.00  0.00               
##   Pi04   4.00  0.61  0.81     0.81
##   Pi4B   7.00  0.70  0.82     0.78
##   Pi16   3.00  0.35  0.53     0.69
##   G11   14.00  0.80  0.87     0.63
##   Pi56   2.00  0.39  0.78     0.81
##   Pi63   3.00  0.50  0.75     0.73
##   Pi70   3.00  0.37  0.55     0.62
##   Pi89   2.00  0.48  0.97     0.97
##   mean   5.18  0.51  0.76     0.75
```


## Phylogenetically Uninformative Loci

We can see that the South American populations are fixed for this allele, thus 
it would not be a bad idea to remove that locus from downstream analyses. We can
do this using the function `informloci`. This will remove loci that contain less
than a given percentage of divergent individuals (the default is $2/N$, where 
$N$ equals the number of individuals in the data set). 


```r
nLoc(Pinf)  # Let's look at our data set, note how many loci we have.
```

```
## [1] 11
```

```r
iPinf <- informloci(Pinf)
```

```
## cutoff value: 2.326 percent ( 2 individuals ).
## 1 uninformative locus found: Pi33
```

```r
nLoc(iPinf) # Note that we have 1 less locus
```

```
## [1] 10
```


So, how does this affect multi-locus based statistics? We can see immediately 
that it didn't affect the number of multilocus genotypes, let's take a look at
the index of association:


```r
poppr(Pinf)
```

```
## | South America 
## | North America 
## | Total
```

```
##             Pop  N MLG eMLG    SE    H    G  Hexp   E.5    Ia  rbarD File
## 1 South America 38  29 29.0 0.000 3.27 23.3 0.983 0.883 2.873 0.3446 Pinf
## 2 North America 48  43 34.5 0.989 3.69 34.9 0.992 0.871 0.223 0.0240 Pinf
## 3         Total 86  72 34.6 1.529 4.19 57.8 0.994 0.875 0.652 0.0717 Pinf
```

```r
poppr(iPinf)
```

```
## | South America 
## | North America 
## | Total
```

```
##             Pop  N MLG eMLG    SE    H    G  Hexp   E.5    Ia  rbarD  File
## 1 South America 38  29 29.0 0.000 3.27 23.3 0.983 0.883 2.873 0.3446 iPinf
## 2 North America 48  43 34.5 0.989 3.69 34.9 0.992 0.871 0.225 0.0255 iPinf
## 3         Total 86  72 34.6 1.529 4.19 57.8 0.994 0.875 0.655 0.0750 iPinf
```


We can see that it increased ever so slightly.

## Missing Data

It's often important to asses the percentage of missing data in your data set. 
The poppr function `missing_table` will help you visualize that so you can figure
out how to treat it using `missingno`. For this example, we will use the nancycats
data set. 


```r
data(nancycats)
missing_table(nancycats, plot = TRUE)
```

<img src="figure/missing_table.png" title="plot of chunk missing_table" alt="plot of chunk missing_table" width="700px" />

```
##           Locus
## Population  fca8 fca23 fca43 fca45 fca77 fca78 fca90 fca96 fca37  Mean
##      1     0.200 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.022
##      2     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      3     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      4     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      5     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      6     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      7     0.357 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.040
##      8     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      9     0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      10    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      11    0.150 0.000 0.000 0.400 0.000 0.000 0.000 0.050 0.000 0.067
##      12    0.214 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.024
##      13    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      14    0.412 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.046
##      15    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      16    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000
##      17    0.000 0.000 0.000 1.000 0.000 0.000 0.000 0.615 0.000 0.179
##      Total 0.084 0.000 0.000 0.089 0.000 0.000 0.000 0.038 0.000 0.023
```


Here we see a few things. The data set has an average of 2.34% missing data
overall. More alarming, perhaps is the fact that popualtion 17 has not been 
genotyped at locus fca45 at all and that locus fca8 has poor resolution across
many populations. Many analyses in poppr can be performed with missing data in
place as it will be either considered an extra allele (in the case of) MLG
calculation or will be interpolated to not contribute to the distance measure
used for the index of association. If you want to specifically treat missing data,
you can use the function `missingno` to remove loci or individuals, or replace 
missing data with zeroes or the average values of the locus. 

### Removing Loci and Genotypes

When removing loci or genotypes, you can specify a cutoff representing the percent missing to be removed. The default is `0.05` (5%).

```r
nanloc <- missingno(nancycats, "loci") # Removing loci with greater than 5% missing.
```

```
## 
##  Found 617 missing values.
##  2 loci contained missing values greater than 5%.
##  Removing 2 loci : fca8 fca45
```

```r
miss <- missing_table(nanloc, plot = TRUE)
```

<img src="figure/unnamed-chunk-2.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="700px" />


We only removed two loci. If we wanted to make sure we removed everything, we
could set `cutoff = 0`.


```r
nanloc <- missingno(nancycats, "loci", cutoff = 0)
```

```
## 
##  Found 617 missing values.
##  3 loci contained missing values greater than 0%.
##  Removing 3 loci : fca8 fca45 fca96
```

```r
miss <- missing_table(nanloc, plot = TRUE)
```

```
## No Missing Data Found!
```


> **Note:** Removing loci can reduce the number of observed multilocus genotypes.

Again, removing individuals is also relatively easy:


```r
nanind <- missingno(nancycats, "geno")
```

```
## 
##  Found 617 missing values.
##  38 genotypes contained missing values greater than 5%.
##  Removing 38 genotypes : N215 N216 N188 N189 N190 N191 N192 N298 N299 N300 
## N301 N302 N303 N304 N310 N195 N197 N198 N199 N200 N201 N206 N182 N184 N186 N282 
## N283 N288 N291 N292 N293 N294 N295 N296 N297 N281 N289 N290
```

```r
miss <- missing_table(nanind, plot = TRUE)
```

```
## No Missing Data Found!
```

```r
nanind <- missingno(nancycats, "geno", cutoff = 0)
```

```
## 
##  Found 617 missing values.
##  38 genotypes contained missing values greater than 0%.
##  Removing 38 genotypes : N215 N216 N188 N189 N190 N191 N192 N298 N299 N300 
## N301 N302 N303 N304 N310 N195 N197 N198 N199 N200 N201 N206 N182 N184 N186 N282 
## N283 N288 N291 N292 N293 N294 N295 N296 N297 N281 N289 N290
```

```r
miss <- missing_table(nanind, plot = TRUE) 
```

```
## No Missing Data Found!
```


Missingno removes individuals based on the percent of missing data relative to
the number of loci. Let's remove all individuals with 2 missing loci:


```r
nanind <- missingno(nancycats, "geno", cutoff = 2/nLoc(nancycats))
```

```
## 
##  Found 617 missing values.
##  1 genotype contained missing values greater than 22.2222222222222%.
##  Removing 1 genotype : N310
```

```r
miss <- missing_table(nanind, plot = TRUE) 
```

<img src="figure/unnamed-chunk-5.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="700px" />

We only found one individual in population 11.

### Replacing Missing Data

Replacement of missing data ocurrs at the allele-level. It will replace all missing data in your data set. There are two options for this: replacement of
missing data with zeroes, indicating that there are mysterious, unsequenced
alleles in your data or replacement of missing data with the average allele 
frequency. 

For these, note that the first population in the data set has 20% missing data
in the first locus. We will be looking at the results of that. Here's the 
un-replaced data for reference 

```r
nan1 <- popsub(nancycats, 1, drop = TRUE) # Dropping alleles not in that population.
nan1[loc = "L1"]@tab
```

```
##    L1.1 L1.2 L1.3 L1.4
## 01   NA   NA   NA   NA
## 02   NA   NA   NA   NA
## 03  0.0  0.5  0.0  0.5
## 04  0.5  0.5  0.0  0.0
## 05  0.5  0.5  0.0  0.0
## 06  0.0  0.5  0.0  0.5
## 07  0.0  1.0  0.0  0.0
## 08  0.0  0.5  0.0  0.5
## 09  0.0  0.0  0.5  0.5
## 10  0.0  1.0  0.0  0.0
```




```r
nanzero <- missingno(nancycats, "zero")
```

```
## 
##  Replaced 617 missing values
```

```r
popsub(nanzero, 1, drop = TRUE)[loc = "L1"]@tab
```

```
##    L1.1 L1.2 L1.3 L1.4
## 01  0.0  0.0  0.0  0.0
## 02  0.0  0.0  0.0  0.0
## 03  0.0  0.5  0.0  0.5
## 04  0.5  0.5  0.0  0.0
## 05  0.5  0.5  0.0  0.0
## 06  0.0  0.5  0.0  0.5
## 07  0.0  1.0  0.0  0.0
## 08  0.0  0.5  0.0  0.5
## 09  0.0  0.0  0.5  0.5
## 10  0.0  1.0  0.0  0.0
```


The `NA`s have been replaced with zeroes. Now let's look at what happens when we
replace with `"mean"`.


```r
nanmean <- missingno(nancycats, "mean")
```

```
## 
##  Replaced 617 missing values
```

```r
popsub(nanmean, 1, drop = TRUE)[loc = "L1"]@tab
```

```
##       L1.01    L1.02   L1.03   L1.04    L1.05   L1.06   L1.07   L1.08
## 01 0.002304 0.002304 0.01382 0.06682 0.002304 0.04608 0.05069 0.07604
## 02 0.002304 0.002304 0.01382 0.06682 0.002304 0.04608 0.05069 0.07604
## 03 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
## 04 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.50000
## 05 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.50000
## 06 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
## 07 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
## 08 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
## 09 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
## 10 0.000000 0.000000 0.00000 0.00000 0.000000 0.00000 0.00000 0.00000
##     L1.09  L1.10   L1.11   L1.12  L1.13   L1.14    L1.15   L1.16
## 01 0.2419 0.1912 0.06221 0.09447 0.1014 0.02535 0.006912 0.01613
## 02 0.2419 0.1912 0.06221 0.09447 0.1014 0.02535 0.006912 0.01613
## 03 0.5000 0.0000 0.00000 0.00000 0.5000 0.00000 0.000000 0.00000
## 04 0.5000 0.0000 0.00000 0.00000 0.0000 0.00000 0.000000 0.00000
## 05 0.5000 0.0000 0.00000 0.00000 0.0000 0.00000 0.000000 0.00000
## 06 0.5000 0.0000 0.00000 0.00000 0.5000 0.00000 0.000000 0.00000
## 07 1.0000 0.0000 0.00000 0.00000 0.0000 0.00000 0.000000 0.00000
## 08 0.5000 0.0000 0.00000 0.00000 0.5000 0.00000 0.000000 0.00000
## 09 0.0000 0.5000 0.00000 0.00000 0.5000 0.00000 0.000000 0.00000
## 10 1.0000 0.0000 0.00000 0.00000 0.0000 0.00000 0.000000 0.00000
```


Notice that there are a lot more alleles than there were originally. This is
because the procedure is performed over the entire data set, not by population.
Let's look at what happens if we perform the same routine on the subsetted data.


```r
nan1mean <- missingno(nan1, "mean")
```

```
## 
##  Replaced 8 missing values
```

```r
nan1mean[loc = "L1"]@tab
```

```
##     L1.1   L1.2   L1.3 L1.4
## 01 0.125 0.5625 0.0625 0.25
## 02 0.125 0.5625 0.0625 0.25
## 03 0.000 0.5000 0.0000 0.50
## 04 0.500 0.5000 0.0000 0.00
## 05 0.500 0.5000 0.0000 0.00
## 06 0.000 0.5000 0.0000 0.50
## 07 0.000 1.0000 0.0000 0.00
## 08 0.000 0.5000 0.0000 0.50
## 09 0.000 0.0000 0.5000 0.50
## 10 0.000 1.0000 0.0000 0.00
```


## Hardy-Weinberg Equilibrium

As HWE is one of the first things people learn about in population genetics, it
is safe to assume that a function for testing HWE has already been written. This
is how you perform it for genind objects. We will again use the nancycats data.


```r
library(genetics)
nanhwe.full <- HWE.test.genind(nancycats) # returns a list
nanhwe.mat  <- HWE.test.genind(nancycats, res.type = "matrix") # returns a matrix
```


The full report will give us a list of loci, each containing a list of 
populations, where each population is the result of a $\Chi^2$ test. For
example, we can see that at locus1 (fca8), we have no good evidence to reject
the null hypothesis that population 1 is not in HWE, but we have evidence that
that population 2 is not in HWE.


```r
nanhwe.full$fca8$P01
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  tab
## X-squared = 5.136, df = 6, p-value = 0.5265
```

```r
nanhwe.full$fca8$P02
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  tab
## X-squared = 29.86, df = 15, p-value = 0.01243
```


Of course, checking all of these is a pain in the butt. We can look at the matrix,
but that's still a bit taxing:


```r
nanhwe.mat
```

```
##         fca8     fca23     fca43   fca45     fca77    fca78     fca90
## P01 0.526517 3.674e-03 0.2280402 0.43751 0.0208150 1.000000 1.765e-01
## P02 0.012427 9.955e-03 0.0001328 0.66252 0.0002153 0.073976 9.040e-07
## P03 0.008042 1.916e-02 0.5099205 0.90711 0.3460930 0.007422 4.882e-01
## P04 0.030857 3.234e-01 0.7685881 0.18515 0.0259008 0.134971 2.425e-04
## P05 0.395499 1.851e-01 0.2095530 0.65080 0.5544311 0.001087 4.948e-02
## P06 0.035773 3.720e-02 0.3933427 0.02992 0.0564054 0.166577 1.441e-01
## P07 0.001015 1.269e-02 0.9591441 0.45935 0.4482332 0.000760 2.556e-01
## P08 0.916112 3.966e-01 0.0919880 0.31833 0.0087894 0.032459 3.067e-01
## P09 0.315106 2.874e-02 0.6457715 0.16271 0.7313058 0.123889 1.948e-02
## P10 0.058729 8.743e-01 0.3820891 0.25979 0.0051378 0.152917 3.720e-02
## P11 0.155066 8.492e-02 0.1718178 0.46374 0.0535610 0.131432 6.895e-03
## P12 0.164120 2.434e-02 0.0014486 0.99994 0.2473303 0.394489 1.450e-01
## P13 0.263065 7.554e-04 0.0166925 0.69861 0.0782627 0.463145 6.731e-02
## P14 0.425618 1.298e-05 0.0613204 0.63565 0.0237132 0.020968 8.541e-02
## P15 0.705557 5.149e-01 0.5669695 0.78928 0.7006925 0.004625 2.563e-01
## P16 0.281227 4.745e-02 0.4923883 0.43651 0.2143387 0.002940 1.088e-01
## P17 0.105208 3.870e-01 0.0147464      NA 0.2844190 0.622681 3.508e-01
##         fca96     fca37
## P01 3.808e-01 1.728e-02
## P02 4.067e-13 5.889e-01
## P03 5.619e-01 3.600e-02
## P04 8.593e-01 5.750e-01
## P05 4.642e-01 3.896e-05
## P06 3.200e-01 7.168e-01
## P07 6.791e-01 1.943e-01
## P08 6.613e-01 4.085e-02
## P09 8.324e-01 7.067e-01
## P10 8.985e-01 6.182e-01
## P11 7.234e-02 7.412e-02
## P12 9.953e-01 5.611e-02
## P13 4.214e-01 1.385e-01
## P14 1.129e-02 9.212e-01
## P15 3.299e-02 5.719e-02
## P16 6.018e-02 5.609e-01
## P17 1.000e+00 1.648e-01
```


Here's a trick.


```r
alpha <- 0.05
newmat <- nanhwe.mat
newmat[newmat > alpha] <- 1
library(reshape2)
library(ggplot2)
ggplot(melt(newmat)) +
  geom_tile(aes(x = Var2, y = Var1, fill = value)) +
  scale_fill_gradient(low = "red", high = "blue")
```

<img src="figure/unnamed-chunk-12.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" width="700px" />






References
----------
Goss EM, Tabima JF, Cooke DEL, Restrepo S, Fry WE, Forbes GA,
Fieland VJ, Cardenas M and Grünwald NJ (2014). "The Irish famine
pathogen Phytophthora infestans originated in central Mexico
rather than the Andes." _Proceedings of the National Academy of
Sciences_, *##*(3), pp. in press.

