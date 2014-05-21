


Chapter 7. Linkage disequilbirum
=====

In this chapter we will formally test if populations are in linkage
disequilibrium or not. This test is useful to determine if populations are
clonal (where significant disequilibrium is expected) or sexual (where linkage
among loci is not expected). The null hypothesis tested is that alleles
observed at different loci are not linked if populations are sexual while
alleles recombine freely  into new genotypes during the process of sexual
reproduction. In molecular ecology we typically use the index of associaton or
related indices to test this phenomenon.

The index of association
-----

The index of association ($I_A$) was originally proposed by Brown et al. (<a href="">Brown et al. 1980</a>) and implemented in the *poppr* R package (<a href="http://dx.doi.org/10.7717/peerj.281">Kamvar et al. 2014</a>) using a permutation approach to assess if loci are linked as described prevously by Agapow and Burt (<a href="">Agapow & Burt, 2001</a>). Agapow and Burt also described the index $\bar{r}_d$ that accounts for the number of loci sampled that is less biased and will be used here. 


```r
library(poppr)
data(Pinf)
MX <- popsub(Pinf, "North America")  #subset population to North America
```


```r
ia(MX, sample=999)   # include 999 permutations
```


```
## |================================================================| 100%
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

```
##      Ia    p.Ia   rbarD    p.rD 
## 0.22261 0.02300 0.02396 0.01500
```


> I am switching these sections as it flows better to talk about the seed right after doing the permuatations. -Zhian

> **For advanced users:** Unless you set the seed using the `set.seed()` function before invoking `ia()` results will change for each permutation run.

We observe 48 individuals and see that $P = 0.015$ for $\bar{r}_d = 0.024$. We thus ~~accept the hypothesis~~ *reject the null hypothesis* of no linkage among markers. Notice, however, that the osbserved $\bar{r}_d$ falls on the right tail of the resampled distribution and the P value is close to $P = 0.01$. Could this samples have clones? We can find out by displaying the data.


```r
MX
```

```
## 
## This is a genclone object
## -------------------------
## Genotype information:
## 
##  43   multilocus genotypes
##  48   tetraploid individuals
##  11   codominant loci
## 
## Population information:
## 
##  2    population hierarchies - Continent Country
##  1    populations defined - North America
```


Indeed we observe 43 multilocus genotypes out of 48 samples. We thus are looking at partial clonality and need to ~~call~~ use clone-corrected data:


```r
MX.cc <- clonecorrect(MX, hier = ~Continent/Country, keep = 2) # remove clones from Mexican population
```


```r
ia(MX.cc, sample = 999)   # include 999 permutations
```


```
## |================================================================| 100%
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

```
##       Ia     p.Ia    rbarD     p.rD 
## 0.079811 0.215000 0.008569 0.200000
```


Now $\bar{r}_d$ is located more centrally in the distribution expected from unlinked loci. Note that P has improved and we ~~still accept~~ *fail to reject* the null hypothesis of no linkage among markers. Thus it apears that populations in Mexico are partially sexual. 

Next let's use the same process to evaluate the South American population:


```r
SA <- popsub(Pinf, "South America")
```


```r
ia(SA, sample = 999)   # include 999 permutations
```


```
## |================================================================| 100%
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

```
##     Ia   p.Ia  rbarD   p.rD 
## 2.8733 0.0010 0.3446 0.0010
```


Here we find singifanct support for the hypothesis that alleles are linked across loci with $P < 0.001$. The observed $\bar{r}_d = 0.345$ and falls outside of the distribution expected under no linkage. Let's look at the clone-corrected data and make sure this is not an artifact of clonality:


```r
SA.cc <- clonecorrect(SA, hier = ~Continent/Country, keep = 2)
```


```r
ia(SA.cc, sample=999)   # include 999 permutations
```


```
## |================================================================| 100%
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 

```
##     Ia   p.Ia  rbarD   p.rD 
## 2.6335 0.0010 0.3146 0.0010
```


Both clone-corrected ($N = 29$) and uncorrected data ($N = 38$) reject the hypothesis of no linkage among markers. We thus have support for populations in Mexico being sexual while those in South America are clonal. 

This approach has been applied to provide support for Mexico as the putative center of origin of the potato late blight pathogen *P. infestans* (<a href="">Goss et al. 2014</a>). At the center of origin this organism is expected to reproduce sexually, while South American populaiton are clonal . 

References
----------
Agapow P and Burt A (2001). "Indices of multilocus linkage
disequilibrium." _Molecular Ecology Notes_, *1*(1-2), pp. 101-102.

Brown A, Feldman M and Nevo E (1980). "Multilocus structure of
natural populations of Hordeum spontaneum." _Genetics_, *96*(2),
pp. 523-536.

Goss EM, Tabima JF, Cooke DEL, Restrepo S, Fry WE, Forbes GA,
Fieland VJ, Cardenas M and Grünwald NJ (2014). "The Irish famine
pathogen Phytophthora infestans originated in central Mexico
rather than the Andes." _Proceedings of the National Academy of
Sciences_, *##*(3), pp. in press.

Kamvar ZN, Tabima JF and Grünwald NJ (2014). "Poppr: an R package
for genetic analysis of populations with clonal, partially clonal,
and/or sexual reproduction." _PeerJ_, *2*, pp. e281. <URL:
http://dx.doi.org/10.7717/peerj.281>, <URL:
http://dx.doi.org/10.7717/peerj.281>.

