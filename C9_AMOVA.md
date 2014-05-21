


Chapter 9. AMOVA
=====
In this chapter, we will utilize AMOVA to analyze our populations. AMOVA stands
for **A**nalysis of **MO**lecular **VA**riance and is a method for analyzing
population differentiation utilizing molecular markers (<a href="">Excoffier et al. 1992</a>). This procedure was initially implemented for DNA haplotypes, but applies to any marker system. AMOVA requires two very basic
components: A distance matrix derived from the data and a separate table used to
partition the data into different hierarchical levels. 

The distance matrix can be calcualted using any distance as long as it is euclidean. The distance that is used in the program **Arlequin** is the opposite of the Kronecker Delta function that counts the number of differences summed over $L$ loci:

$$
\delta_{l,m} = \begin{cases}
1 \text{ if } m = l,\\
0 \text{ if } m \neq l
\end{cases}
$$
$$
d_{i,j} = \sum_{L = 1}^L 1 - \delta_{i,j}
$$

To calculate AMOVA in *poppr*, one simply needs to supply a data set with
hierarchical levels. We will use the *Aphanomyces euteiches* data set from 
(<a href="">Gr{\"u}nwald & Hoheisel, 2006</a>).


```r
library(poppr)
data(Aeut)
Aeut <- as.genclone(Aeut)
Aeut
```

```
## 
## This is a genclone object
## -------------------------
## Genotype information:
## 
##  119   multilocus genotypes
##  187   diploid individuals
##  56    dominant loci
## 
## Population information:
## 
##  3     population hierarchies - Pop_Subpop Pop Subpop
##  2     populations defined - Athena Mt. Vernon
```

We can see that this data set contains clonal data and has three hierarchical levels (Really two, the first level is an artifact of the data import). We can take a look
at the different hierarchical levels, first populations and next subpopulations: 


```r
table(gethierarchy(Aeut, ~Pop))
```

```
## 
##     Athena Mt. Vernon 
##         97         90
```

```r
table(gethierarchy(Aeut, ~Pop/Subpop, combine = FALSE))
```

```
##             Subpop
## Pop           1 10  2  3  4  5  6  7  8  9
##   Athena      9  9 12 10 13 10  5 11  8 10
##   Mt. Vernon 10  0  6  8 12 17 12 12 13  0
```


In this example, we have a data set of 187 individuals sampled from two fields in regions Athena and Mt. Vernon over different 8 or 10 soil samples within each field. We want to see if most of the variance is observed at the sample, field or regional level. Let's invoke the AMOVA functions with and without clone correction:



```r
Aeutamova <- poppr.amova(Aeut, ~Pop/Subpop)
```

```
## 
##  No missing values detected.
```

```r
Aeutamovacc <- poppr.amova(Aeut, ~Pop/Subpop, clonecorrect = TRUE)
```

```
## 
##  No missing values detected.
```


We'll look at the AMOVA results for both analyses. 


```r
Aeutamova
```

```
## $call
## ade4::amova(samples = xtab, distances = xdist, structures = xstruct)
## 
## $results
##                             Df Sum Sq  Mean Sq
## Between Pop                  1 1051.2 1051.235
## Between samples Within Pop  16  273.5   17.091
## Within samples             169  576.5    3.411
## Total                      186 1901.2   10.221
## 
## $componentsofcovariance
##                                         Sigma       %
## Variations  Between Pop                11.063  70.007
## Variations  Between samples Within Pop  1.329   8.407
## Variations  Within samples              3.411  21.586
## Total variations                       15.803 100.000
## 
## $statphi
##                      Phi
## Phi-samples-total 0.7841
## Phi-samples-Pop   0.2803
## Phi-Pop-total     0.7001
```

```r
Aeutamovacc
```

```
## $call
## ade4::amova(samples = xtab, distances = xdist, structures = xstruct)
## 
## $results
##                             Df Sum Sq Mean Sq
## Between Pop                  1  742.0 741.987
## Between samples Within Pop  16  185.7  11.605
## Within samples             123  520.1   4.229
## Total                      140 1447.8  10.341
## 
## $componentsofcovariance
##                                          Sigma       %
## Variations  Between Pop                10.4132  66.778
## Variations  Between samples Within Pop  0.9521   6.105
## Variations  Within samples              4.2286  27.117
## Total variations                       15.5938 100.000
## 
## $statphi
##                      Phi
## Phi-samples-total 0.7288
## Phi-samples-Pop   0.1838
## Phi-Pop-total     0.6678
```


The first thing to look at are the `$results` element. The degrees of freedom
(the `Df` column) should match what we expect from our (not clone-corrected) data. The number in the `Total` row should equal 186 or $N - 1$. 

The `$componentsofcovariance` table shows how much
variance is detected at each hierarchical level. We expect variations within samples to 
give the greatest amount of variation for populations that are not significantly
differentiated. `Sigma` represents the variance, $\sigma$, for each hierarchical
level and to the right is the percent of the total. 

Finally, `$statphi` provides the $\phi$ population differentiation statistics. These are used ot test hypotheses about population differentiation. We would expect a higher $\phi$
statistic to represent a higer amount of differentiation. 

Note, if you want to make a table of any of these components, you can isolate them by using the `$` operator and then export it to a table with `write.table`. Here's an example with the components of covariance:


```r
write.table(Aeutamova$componentsofcovariance, sep = ",", file = "~/Documents/AeutiechesAMOVA.csv")
```


To test if populations are singificantly differentiated we perform a randomization test utilizing the function `randtest()` from the *ade4* package. This will randomly permute the sample matrices as described in (<a href="">Excoffier et al. 1992</a>).


```r
set.seed(1999)
Aeutsignif   <- randtest(Aeutamova, nrepet = 999)
Aeutccsignif <- randtest(Aeutamovacc, nrepet = 999)
```


```r
plot(Aeutsignif)
```

<img src="figure/Aeut_random_plot.png" title="plot of chunk Aeut_random_plot" alt="plot of chunk Aeut_random_plot" width="500px" />

```r
Aeutsignif
```

```
## class: krandtest 
## Monte-Carlo tests
## Call: randtest.amova(xtest = Aeutamova, nrepet = 999)
## 
## Number of tests:   3 
## 
## Adjustment method for multiple comparisons:   none 
## Permutation number:   999 
##                         Test    Obs Std.Obs   Alter Pvalue
## 1  Variations within samples  3.411  -31.56    less  0.001
## 2 Variations between samples  1.329   20.37 greater  0.001
## 3     Variations between Pop 11.063    9.74 greater  0.001
## 
## other elements: adj.method call
```

From this output, you can see three histograms representing the distribution of
the randomized hierarchy. The black line represents the observed data. You can 
see a table of observed results in the output showing that there is significant
population structure considering all levels of the population hierarchy. Of
course, this could be due to the presence of clones, so let's visualize the
results from the clone corrected data set below:


```r
plot(Aeutccsignif)
```

<img src="figure/Aeut_clonecorrect_random_plot.png" title="plot of chunk Aeut_clonecorrect_random_plot" alt="plot of chunk Aeut_clonecorrect_random_plot" width="500px" />

```r
Aeutccsignif
```

```
## class: krandtest 
## Monte-Carlo tests
## Call: randtest.amova(xtest = Aeutamovacc, nrepet = 999)
## 
## Number of tests:   3 
## 
## Adjustment method for multiple comparisons:   none 
## Permutation number:   999 
##                         Test     Obs Std.Obs   Alter Pvalue
## 1  Variations within samples  4.2286 -21.327    less  0.001
## 2 Variations between samples  0.9521   9.534 greater  0.001
## 3     Variations between Pop 10.4132  10.889 greater  0.001
## 
## other elements: adj.method call
```


The above graphs show significant population differentiation at all levels given that the observed $\phi$ does not fall within the distirbution expected from the permutation. Compare the results of our AMOVA analysis to those publsihed in (<a href="">Gr{\"u}nwald & Hoheisel, 2006</a>). They should be identical. 

Since AMOVA is used to detect whether or not there is significant population
structure, we can see what happens when we randomly shuffle the popualtion
assignments in our data. Here we will show what the populations look like before
and after shuffling:


```r
Aeut.new <- Aeut
head(gethierarchy(Aeut)[, -1])
```

```
##      Pop Subpop
## 1 Athena      1
## 2 Athena      1
## 3 Athena      1
## 4 Athena      1
## 5 Athena      1
## 6 Athena      1
```

```r
set.seed(9001)
head(gethierarchy(Aeut)[sample(nInd(Aeut)), -1])
```

```
##            Pop Subpop
## 44      Athena      4
## 177 Mt. Vernon      8
## 36      Athena      4
## 127 Mt. Vernon      4
## 8       Athena      1
## 39      Athena      4
```

Here we see that the populations are completely shuffled, so in the next step,
we will reassign the hierarchy with these newly shuffled populations and rerun
the amova analysis.


```r
set.seed(9001)
sethierarchy(Aeut.new) <- gethierarchy(Aeut)[sample(nInd(Aeut)), -1]
Aeut.new.amova         <- poppr.amova(Aeut.new, ~Pop/Subpop)
```

```
## 
##  No missing values detected.
```

```r
Aeut.new.amova
```

```
## $call
## ade4::amova(samples = xtab, distances = xdist, structures = xstruct)
## 
## $results
##                             Df  Sum Sq Mean Sq
## Between Pop                  1   23.21  23.206
## Between samples Within Pop  16  136.34   8.521
## Within samples             169 1741.65  10.306
## Total                      186 1901.20  10.221
## 
## $componentsofcovariance
##                                          Sigma       %
## Variations  Between Pop                 0.1589   1.544
## Variations  Between samples Within Pop -0.1733  -1.684
## Variations  Within samples             10.3056 100.140
## Total variations                       10.2912 100.000
## 
## $statphi
##                         Phi
## Phi-samples-total -0.001402
## Phi-samples-Pop   -0.017106
## Phi-Pop-total      0.015440
```

```r
Aeut.new.amova.test    <- randtest(Aeut.new.amova, nrepet = 999)
Aeut.new.amova.test
```

```
## class: krandtest 
## Monte-Carlo tests
## Call: randtest.amova(xtest = Aeut.new.amova, nrepet = 999)
## 
## Number of tests:   3 
## 
## Adjustment method for multiple comparisons:   none 
## Permutation number:   999 
##                         Test     Obs Std.Obs   Alter Pvalue
## 1  Variations within samples 10.3056  0.3553    less  0.619
## 2 Variations between samples -0.1733 -0.7657 greater  0.777
## 3     Variations between Pop  0.1589  1.3880 greater  0.103
## 
## other elements: adj.method call
```

```r
plot(Aeut.new.amova.test)
```

<img src="figure/randomized_hierarchy_plot.png" title="plot of chunk randomized_hierarchy_plot" alt="plot of chunk randomized_hierarchy_plot" width="500px" />


We see that there now is no significant population structure.

References
----------
Excoffier L, Smouse PE and Quattro JM (1992). "Analysis of
molecular variance inferred from metric distances among DNA
haplotypes: application to human mitochondrial DNA restriction
data." _Genetics_, *131*(2), pp. 479-491.

Grünwald NJ and Hoheisel G (2006). "Hierarchical analysis of
diversity, selfing, and genetic differentiation in populations of
the oomycete Aphanomyces euteiches." _Phytopathology_, *96*(10),
pp. 1134-1141.

