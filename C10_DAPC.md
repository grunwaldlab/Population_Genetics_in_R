


Chapter 10. Discriminant Analysis of Principal Components
=====

Often we want to infer population structure by determining the number of clusters (groups) observed without prior knowledge. Several appraoches can be used to infer groupssuch as for example K-means clustering, Bayesian clustering using STRUCTURE, and multivariate methods such as Discriminant Analysis of Pricnicapl Componenets (DAPC) (<a href="">Jombart et al. 2010</a>; <a href="">Pritchard et al. 2000</a>; <a href="">Gr{\"u}nwald & Goss, 2011</a>). A STRUCTURE-like approach assumes that markers are not linked and that populations are panmictic (<a href="">Pritchard et al. 2000</a>). To use model-free methods K-means clustering based on genetic distance or DAPC are more convenient approaches for populations that are clonal or partially clonal. Here we explore clustering and DAPC further.

K-means clustering based on genetic distance
-----

K-means clustering is a method that can be used to explore genetic grouping. We will use the seasonal influenza dataset H3N2 data containing 1903 isolates genotyped for 125 SNPs located in the hemagglutinin segment. This dataset as well as the `find.clusters()` function are part of the [*adegenet*](http://adegenet.r-forge.r-project.org) package. 


```r
# DAPC requires the adegenet package. Let's load this package:
library(adegenet)
data(H3N2)      # load the H3N2 inflluenza data. Type ?H3N2 for more info on data.
pop(H3N2) <- H3N2$other$epid
grpp <- kmeans(H3N2, 10)
```

```
## Error: NA/NaN/Inf in foreign function call (arg 1)
```




DAPC analysis of the H3N2 influenza strains
----

DAPC was pioneered by Jombart and colleagues (<a href="">Jombart et al. 2010</a>) and can be used to infer the number of genetic clusters of genetically related individuals. In this multivariate statistical approach variance in the sample is partitioned into a between-group and within-group component in an effort to maximize discrimination between groups. In DAPC, data is first transformed using a principal components analysis (PCA) and subsequently clusters are identified using discriminant analysis (DA). This tutorial is based on the [vignette](http://cran.at.r-project.org/web/packages/adegenet/vignettes/adegenet-dapc.pdf) written by Thibaut Jombart. We encourage the user to explore this vignette further.

We will use the seasonal influenza dataset H3N2 data containing 1903 isolates genotyped for 125 SNPs located in the hemagglutinin segment. This dataset as well as the `find.clusters()` function are part of the [*adegenet*](http://adegenet.r-forge.r-project.org) package. 


```r
# DAPC requires the adegenet package. Let's load this package:
library(adegenet)
data(H3N2)      # load the H3N2 inflluenza data. Tye ?H3N2 for more info.
pop(H3N2) <- H3N2$other$epid
dapc.flu <- dapc(H3N2, n.pca=30,n.da=10)
```


The `dapc() variables refer to:

- the dataset H3N2
- `m.pca` is the number of axes retained in the Principal Component Analysis (PCA). If set to NULL selection is interactive, which we avoid here but can be explored by the user.
- `n.da` -  number of axes retained in the Discriminant Analysis. If set to NULL selection is interactive, which we avoid here but can be explored by the user.

Next, we will define a color palette using the *grDevices* function `colorRampPalette` to set color ramps for graphing. The *ade4* `scatter()` plot function is used to visualize relationships:


```r
myPal <- colorRampPalette(c("red","orange","blue"))
scatter(dapc.flu, col=transp(myPal(6)), scree.da=FALSE, cell=1.5, cex=2, bg="white",cstar=0)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 


As you can see, each year between 2001 to 2005 is a cluster of H3N2 strains separated by axis 1. In contrast, axis 2 separates the strains observed in the 2006 cluster from the clusters observed during 2001-5, indicating that the strains observed in 2006 are genetically distinct.

DAPC analysis is inherently interactive and cannot be scripted *a priori*. Please refer to the [vignette](http://cran.at.r-project.org/web/packages/adegenet/vignettes/adegenet-dapc.pdf) written by Thibaut Jombart for a more interactive analysis.

Conclusions
----

DAPC is a wonderful tool for exploring structure of populations based on PCA and DA without making assumptions of panmixia. Thus, this technique provides a great alternative to Bayesian clustering methods like STRUCTURE (<a href="">Pritchard et al. 2000</a>) that should not be used for clonal or patially clonal populations.

References
----------
Grünwald NJ and Goss EM (2011). "Evolution and population genetics
of exotic and re-emerging pathogens: Novel tools and approaches."
_Annual Review of Phytopathology_, *49*, pp. 249-267.

Jombart T, Devillard S and Balloux F (2010). "Discriminant
analysis of principal components: a new method for the analysis of
genetically structured populations." _BMC genetics_, *11*(1), pp.
94.

Pritchard JK, Stephens M and Donnelly P (2000). "Inference of
population structure using multilocus genotype data." _Genetics_,
*155*(2), pp. 945-959.

