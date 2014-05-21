


Chapter 1. Population genetics in R
====

Introduction
----

This primer provides a concise introduction to conducting applied analyses of population genetic data in R, with a special emphasis on non-model populations including clonal or partially clonal organisms. It is not meant to be a textbook on population genetics. Quite to the contrary, we refer the reader to several textbooks on population genetics (<a href="http://books.google.com/books?id=Iy08kgEACAAJ">Nielsen & Slatkin, 2013</a>; <a href="http://books.google.com/books?id=tJVreQjInt0C">Templeton, 2006</a>; <a href="http://books.google.com/books?id=SB1vQgAACAAJ">Hartl & Clark, 2007</a>). Likewise, this book will not replace books on theory and statistics of population genetics (<a href="http://books.google.com/books?id=e9QPAQAAMAAJ">Weir, 1996</a>). The reader is thus expected to have a basic understanding of population genetic theory and applications. Finally, this primer is focused on traditional population genetics based on allele frequencies, rather than more sophisticated coalescent approaches (<a href="http://books.google.com/books?id=x30RAgAACAAJ">Wakeley, 2009</a>; <a href="http://books.google.com/books?id=Iy08kgEACAAJ">Nielsen & Slatkin, 2013</a>; <a href="http://books.google.com/books?id=QBC\_SFOamksC">Hein et al. 2004</a>), although some of these aspects will be covered here too. In a nutshell, this primer provides a valuable resource for tackling the nitty-gritty analysis of populations that do not necessarily conform to textbook genetics and might or might not be in Hardy-Weinberg equilibrium and panmixia. 

This primer is geared towards biologists intersted in analyzing their populations. This primer does not reuqire extensive knowledge of programming in R, but the user is expected to install R and all ~~its dependent packages~~ <u>packages required for this book</u>. 

Why R?
-----

Until recently, one of the more tedious aspects of conducting a population genetic analysis was the need for repeated reformatting data to conduct different, complimentary analyses in different programs. Often, these programs only ran on one platform. Now, R provides a toolbox with its packages that allows analysis of most data conveniently without tedious reformatting on all major computing platforms including Microsoft Windows, Linux, and Apple's OS X. R is an open source statistical programming and graphing language that includes tools for statistical, population genetic, genomic, phylogenetic, and comparative genomic analyses. This primer is for those of us that want to conduct applied analyses of populations and make full use of the palette of tools available in R.

Note that the R user community is a very active and that both R and its packages are regularly updated, critically modified, and noted as deprecated (no longer updated). 

> Any R user needs to make sure all components are up-to-date and that versions are compatible. 

Population genetics
----

Traditional population genetics is based on analysis of observed allele frequencies compared to frequencies expected, assuming a population genetic model. For example, under a Wright-Fisher model you might expect to see populations of diploid individuals that reproduce sexually, with non-overlapping generations. This model ignores effects such as mutation, recombination, selection or changes in population size or structure. More complex models can incorporate different aspects of effects observed in real populations. However, most of these models assume that populations reproduce sexually. 

Some basic terminology before we get started
----

Although we briefly review some terminology, we expect that the reader has a basic understanding of theory and applications of population genetics. Now, let's review some useful terms.

A **locus** is a position in the genome where we can observe one or several alleles in different individuals. Although in phylogenetic analyses, loci are typically coding genes, in population genetics, a locus is not necessarily a coding gene. Loci used in population genetics are assumed to be selectively neutral and can be an anonymous or non-coding region such as a microsatellite locus (SSR), a single nucleotide polymorphism (SNP) or the presence/absence of a band on a gel. A **genotype** is the combination of alleles carried by a  given individual at a particular set of loci. Individuals carring the same set of alleles are considered to have the same **multilocus genotype** $MLG$. 

Basic metrics of interest in populations are polymorphisms, allele frequencies and genotype frequencies. Polymorphism can be estimated in several ways, such as the total number of loci observed that have more than one allele. The frequency of an allele is calculated as the number of allele copies observed in a population divided by the total number of individuals, times the ploidy ($N$ in haploids or $2N$ in diploids) in the population. For diploids we would observe frequency $f_{A}$ and $f_{a}$ for alleles $A$ and $a$, respectively:
 
$f_{A} = \frac{N_{A}}{2N}$ and $f_{a} = \frac{N_{a}}{2N}$

where $N_{A}$ are the numbers of allele $A$ segregating in the population genotyped. 

By definition, at a biallelic locus frequencies sum to 1: 

$f_{A} + f_{a} = 1$.

Genotype frequencies are the relative frequencies of each $MLG$ observed in a population. Thus, for diploids at a **biallelic locus** we can observe three genotypes: $AA$, $Aa$, and $aa$ and their respective frequencies:

$f_{AA} = \frac{N_{AA}}{2N}$ and $f_{Aa} = \frac{N_{Aa}}{2N}$ and $f_{aa} = \frac{N_{aa}}{2N}$ 

These frequencies again add up to 1. In diploid organisms we can also calculate the frequency of **homozygotes** ($AA$ or $aa$) or **heterozygotes** ($Aa$) as the proportion of individuals falling into each class.

Genetic differentiation of two populations occurs if we observe differences in polymorphism, allele frequencies, genotype frequencies, and heterozygosity. This is often measured by metrics such as $F_{st}$ or genetic distance.

> ADD MORE <<<<<<<<<<<<<<<<<<<<<<<<<<<

The special case of clonal organisms
----

Plants and microorganisms such as fungi, oomycetes, and bacteria often reproduce clonally or follow a mixed reproductive system, including various degrees of clonality and sexuality (<a href="">Halkett et al. 2005</a>). Traditional population genetic theory does not apply and these populations violate basic assumptions in the corresponding analyses. Thus, a different set of tools are required for analyses of clonal populations (<a href="">Anderson & Kohn, 1995</a>; <a href="">Balloux et al. 2003</a>; <a href="">Mee{\^u}s et al. 2006</a>; <a href="">Gr{\"u}nwald & Goss, 2011</a>; <a href="">Halkett et al. 2005</a>; <a href="">Milgroom, 1996</a>). Typically these focus on metrics that are model free and do not assume random mating or random sampling of alleles. Model free metrics suitable for analyzing these populations include measures of genotypic diversity and evenness, and using genetic distance to cluster populations. Additional useful measures include indices of linkage disequiblibrium among markers that are used to infer if populations are reproducing sexually or clonally. We will explore these analyses bit by bit throughout this primer. The *poppr* R package was specifically developped to facilitate analyses of clonal populations.

Marker systems, ploidy and other kinds of data
----

Population genetic data come in many shapes and forms and a good analysis needs to be tailored to the marker system, ploidy used and corresponding genetic models assumed (<a href="">Gr{\"u}nwald & Goss, 2011</a>). Organisms can be haploid, diploid with or without known phase, or polyploid and in the case of diploid species, marker systems can be dominant (AFLP, RFLP or RAPD data) or codominant (SSR, SNPs, allozymes) (<a href="">Gr{\"u}nwald et al. 2003</a>). A locus can have two alleles (0/1 for AFLP; C/T for SNPs) or many alleles per locus (A/B/C...N for SSRs or allozymes). In each case the data has to be coded and analyzed differently. Mutation rates can also differ for different markers systems (SSR: high; mitochondrial SNPs: moderate; nuclear SNPs: moderate) (<a href="">Gr{\"u}nwald & Goss, 2011</a>). 

Hierarchical analysis
----

To determine if populations show evidence of genetic structure they need to be sampled hierarchically to assess if allele frequencies in subpopulations differ from frequencies in the overall population and amongst each other. 

Applications of population genetic analyses
----

Population genetic analyses are tremendously valuable for answering questions ranging from determining best management practices to basic evolutionary questions (<a href="">Gr{\"u}nwald & Goss, 2011</a>). For example, a typical concern when finding a new, invasive organism is whether it is introduced to the area or emerged from a resident population. Other questions of interest might include: Where is the center of origin? Does this organism reproduce sexually? Is there evidence of recombination? Has the population gone through a genetic bottleneck? Are populations structured by region, geography, micro-environment? What is the source population of a newly introduced population? What are source and sink populations and what are the rates of migration? This primer will provide some of the basic tools needed to answer many of these questions for populations that are clonal or partially clonal. We hope you enjoy following along. 

References
----------
Anderson JB and Kohn LM (1995). "Clonality in soilborne,
plant-pathogenic fungi." _Annual Review of Phytopathology_,
*33*(1), pp. 369-391.

Balloux F, Lehmann L and Meeûs Td (2003). "The population genetics
of clonal and partially clonal diploids." _Genetics_, *164*(4),
pp. 1635-1644.

Meeûs TD, Lehmann L and Balloux F (2006). "Molecular epidemiology
of clonal diploids: a quick overview and a short DIY (do it
yourself) notice." _Infection, Genetics and Evolution_, *6*(2),
pp. 163-170.

Grünwald NJ, Goodwin SB, Milgroom MG and Fry WE (2003). "Analysis
of genotypic diversity data for populations of microorganisms."
_Phytopathology_, *93*(6), pp. 738-746. 682CATimes Cited:78Cited
References Count:47.

Grünwald NJ and Goss EM (2011). "Evolution and population genetics
of exotic and re-emerging pathogens: Novel tools and approaches."
_Annual Review of Phytopathology_, *49*, pp. 249-267.

Halkett F, Simon J and Balloux F (2005). "Tackling the population
genetics of clonal and partially clonal organisms." _Trends in
Ecology \& Evolution_, *20*(4), pp. 194-201.

Hartl D and Clark A (2007). _Principles of Population Genetics_.
Sinauer Associates, Incorporated. ISBN 9780878933082, <URL:
http://books.google.com/books?id=SB1vQgAACAAJ>.

Hein J, Schierup M and Wiuf C (2004). _Gene Genealogies, Variation
and Evolution: A primer in coalescent theory_. Oxford University
Press, USA. ISBN 9780191546150, <URL:
http://books.google.com/books?id=QBC\_SFOamksC>.

Milgroom MG (1996). "Recombination and the multilocus structure of
fungal populations." _Annual review of phytopathology_, *34*(1),
pp. 457-477.

Nielsen R and Slatkin M (2013). _An Introduction to Population
Genetics: Theory and Applications_. Sinauer Associates,
Incorporated. ISBN 9781605351537, <URL:
http://books.google.com/books?id=Iy08kgEACAAJ>.

Templeton A (2006). _Population Genetics and Microevolutionary
Theory_. Wiley. ISBN 9780470047217, <URL:
http://books.google.com/books?id=tJVreQjInt0C>.

Wakeley J (2009). _Coalescent Theory: An Introduction_. Roberts \&
Company Publishers. ISBN 9780974707754, <URL:
http://books.google.com/books?id=x30RAgAACAAJ>.

Weir B (1996). _Genetic data analysis 2_. Sinauer Associates. ISBN
9780878939022, <URL:
http://books.google.com/books?id=e9QPAQAAMAAJ>.

