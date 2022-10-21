# A Tutorial for Pharmacogenomics Clinical Annotation Tool (PharmCAT)

<div id='pageTop'/> 

https://github.com/luong-komorebi/Markdown-Tutorial

This tutorial teaches you how to run PharmCAT. And this repository provides genetic data and other materials that you need to familiarize yourself with PharmCAT v2.0.

> **Citing PharmCAT**: 
> 1. Klein, T. E. & Ritchie, M. D. PharmCAT: A Pharmacogenomics Clinical Annotation Tool. Clin Pharmacol Ther 104, 19–22 (2018).
> 2. Sangkuhl, K. et al. Pharmacogenomics Clinical Annotation Tool (PharmCAT). Clin Pharmacol Ther 107, 203–210 (2020).

*******
Table of contents
1. [Intro to PharmCAT](#introToPharmcat)
2. [Why use PharmCAT](#whyPhramcat)
3. [Set up the environment for the tutorial](#setupEnv)
4. [Run the PharmCAT VCF preprocessor (strongly recommended)](#vcfPreprocessor)
5. [Run PharmCAT](#runPharmcat)
   1. [The whole PharmCAT](#runPharmcat)
   2. [Individual PharmCAT modules](#individualModule)
   3. [Outside PGx calls](#outsideCall)
   4. [Batch-annotation on multiple individuals](#batchAnalysis)
*******

<div id='introToPharmcat'/> 

## Intro to PharmCAT 

Pharmacogenomics Clinical Annotation Tool (PharmCAT) is a software tool that serves the global pharmacogenomics (PGx) and clinical communities and promotes clinical implementation of PGx. PharmCAT digests an individual's genetic data in a VCF file (a common genetic data file format), infers PGx information (PGx alleles, diplotypes, and phenotypes), and generates a drug prescribing recommendation report for the individual. 


You can find more information about the PharmCAT project and tool on [pharmcat.org](https://pharmcat.org/).


figures of PharmCAT workflow

[Back to Top](#pageTop)
<div id='whyPhramcat'/> 

## Why use PharmCAT

PGx is the low-hanging fruit of precision medicine and a research field that we are likely to witness near-term success of individualized clinical care. 

PharmCAT has the following features that make it a desired tool for PGx implementation in clinical care. 

(1) **Scalability** as an automated end-to-end annotation tool.

(2) **Standardization** in end-to-end PGx annotation from genotypes to drug prescribing recommendations. 

(3) **Flexibility** as PharmCAT takes various types of PGx calls from other PGx annotation tools to provide guideline-based recommendations.

(4) **Modularization** of functional parts that meet different clinical and research purposes.

[Back to Top](#pageTop)
<div id='setupEnv'/> 

## Setup of the tutorial

This tutorial is going to use a pre-prepared Docker image that comes with all pre-requisite software and dependencies for you to successfully run PharmCAT without worries at the first try. 

To run a Docker image on your computer, you need to [download Docker here](https://docs.docker.com/get-docker/). 

Once you finish the download, open Docker.

If you don't want to use the pre-prepared Docker image, make sure you have the following software and dependencies in your system:
1. java 17 or higher, _e.g._, [OpenJDK by Adoptium](https://adoptium.net)
2. PharmCAT Jar file from [the PharmCAT webpage](https://pharmcat.org/) or [the PharmCAT GitHub repository releases page](https://github.com/PharmGKB/PharmCAT/releases/latest).
3. PharmCAT's VCF preprocessor
   1. Downloadable from [the PharmCAT GitHub repository releases page](https://github.com/PharmGKB/PharmCAT/releases/latest)
   2. Python >= 3.9
   3. [bcftools >= 1.16](http://www.htslib.org/download/)
   4. [bgzip >= 1.16](http://www.htslib.org/download/)
   5. Python3 package: pandas >= 1.4.2
   6. Python3 package: scikit-allell >= 1.3.5
4. JSON to TSV
   1. [R >= 4.0.4](https://www.r-project.org/)
   2. rjson >= 0.2.20
   3. optparse >= 1.6.6
   4. tidyverse >= 1.3.0
   5. foreach >= 1.5.2
   6. doParallel >= 1.0.17

[Back to Top](#pageTop)
<div id='vcfPreprocessor'/> 

## Run the PharmCAT VCF preprocessor

The PharmCAT VCF preprocessor, written in python 3, makes sure the input VCF file(s) meet PharmCAT’s VCF requirements.



[Back to Top](#pageTop)
<div id='runPharmcat'/> 

## Run PharmCAT


[Back to Top](#pageTop)
<div id='individualModule'/> 

### Run individual PharmCAT modules

[Back to Top](#pageTop)
<div id='outsideCalls'/> 

### Incorporate outside PGx calls

[Back to Top](#pageTop)
<div id='batchAnalysis'/> 

### Batch-annotation on multiple individuals


[Back to Top](#pageTop)

