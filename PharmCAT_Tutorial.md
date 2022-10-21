# A Tutorial for Pharmacogenomics Clinical Annotation Tool (PharmCAT)

https://github.com/luong-komorebi/Markdown-Tutorial

This tutorial teaches you how to run PharmCAT. And this repository provides genetic data and other materials that you need to familiarize yourself with PharmCAT v2.0.

> **Citing PharmCAT**: 
> 1. Klein, T. E. & Ritchie, M. D. PharmCAT: A Pharmacogenomics Clinical Annotation Tool. Clin Pharmacol Ther 104, 19–22 (2018).
> 2. Sangkuhl, K. et al. Pharmacogenomics Clinical Annotation Tool (PharmCAT). Clin Pharmacol Ther 107, 203–210 (2020).

*******
Table of contents
1. [Intro to PharmCAT](#introToPharmcat)
2. [Why use PharmCAT](#whyPhramcat)
3. Format of the tutorial
4. Run the PharmCAT VCF preprocessor (strongly recommended)
5. Run PharmCAT
   1. The whole PharmCAT
   2. Individual PharmCAT modules
   3. Outside PGx calls
   4. Batch-annotation on multiple individuals
*******

<div id='introToPharmcat'/> 

## Intro to PharmCAT 

Pharmacogenomics Clinical Annotation Tool (PharmCAT) is a software tool that serves the global pharmacogenomics (PGx) and clinical communities and promotes clinical implementation of PGx. PharmCAT digests an individual's genetic data in a VCF file (a common genetic data file format), infers PGx information (PGx alleles, diplotypes, and phenotypes), and generates a drug prescribing recommendation report for the individual. 


You can find more information about the PharmCAT project and tool on [pharmcat.org](https://pharmcat.org/).


figures of PharmCAT workflow


<div id='whyPhramcat'/> 

## Why use PharmCAT

PGx is the low-hanging fruit of precision medicine and a research field that we are likely to witness near-term success of individualized clinical care. 

PharmCAT addresses two primary issues in clinical implementation of PGx. 

(1) **Scalability**. 

To achieve scalable clinical implementation of PGx, there needs to be an automated system for end-to-end reporting (_i.e._, from genotypes to drug prescribing guidance). Mapping patient genotypes to the guideline recommendations is resource intensive. PharmCAT mitigates this resource-intensive task by providing scalable, automated end-to-end annotations from genotypes in a VCF file to drug prescribing recommendations based on the CPIC guidelines and PharmGKB-curated DPWG guidelines. 

(2) **Standardization** in PGx annotation. 

Individual genetic tests and labs often detect and report on a limited subset of PGx positions that are most prevalent, even though the genetic positions omitted from PGx testing panels occurs at a nontrivial frequency and carry actionable indications for drug dosage adjustments. The result is different PGx results from different labs or commercial testing companies. To tackle this issue, PharmCAT provides standardized, reproducible, and transparent interpretation of PGx testing results. PharmCAT generates reports based on all genetic positions included in the drug prescribing recommendation guidelines and clearly informs users of results that are based on limited genetic positions in user-provided file.

In addition, PharmCAT is a versatile tool that allows outside annotations of PGx diplotypes, phenotypes, or activity scores from other PGx annotation tools.

PharmCAT is also scalable in a way that it can handle biobank-scale analysis.


## Set up


## the PharmCAT VCF preprocessor
