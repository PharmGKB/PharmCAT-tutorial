# PharmCAT tutorial
This repository contains the tutorial materials for the PharmCAT v1.6.0 as of March 31, 2022.

For more information about the PharmCAT project and tool, please visit [pharmcat.org](https://pharmcat.org/).

## Reference
Please cite:
1. Klein, T. E. & Ritchie, M. D. PharmCAT: A Pharmacogenomics Clinical Annotation Tool. Clin Pharmacol Ther 104, 19–22 (2018).
2. Sangkuhl, K. et al. Pharmacogenomics Clinical Annotation Tool (PharmCAT). Clin Pharmacol Ther 107, 203–210 (2020).


## Pre-requisite
- bcftools >= 1.15
- tabix >= 1.15
- bgzip >= 1.15
- python3

To download and compile bcftools, tabix and bgzip, please check out the instructions on the [Samtools Download website](http://www.htslib.org/download/). 

## Tutorial

To generate PGx annotations using the PharmCAT, it is recommended to run the PharmCAT VCF preprocessor before running the PharmCAT. We recommend the users to follow the order of the analyses below.

- 02_VCF_preprocessing.sh
  - Preprocessing the VCF for the PharmCAT
- 03_PharmCAT.sh
  - Running PharmCAT
    - The whole PharmCAT
    - Alternatively, individual components- Named Allele Matcher, Phenotyper, or Reporter
  - This script shows examples of how to run PharmCAT through multiple samples. 
- 04_batch_PharmCAT_results.sh
  - Scripts and commands to organize PharmCAT results from JSON files to a tabular TXT file

Additional scripts:
- 00_download_vcf.sh
  - Data source for the three GeT-RM samples (NA18526, NA18565, NA18861) used in this tutorial
  - The original VCFs were the 30x whole-genome sequencing data on 3202 samples from the 1000 Genomes Project sample collection, including GeT-RM samples. The sequencing was conducted by the New York Genome Center and Supported by the NHGRI.
- 01_GeT-RM_30x_WGS_on_GRCh38.sh
  - Commands to extract the tutorial samples from the downloaded VCFs.


## Acknowledgement
PharmCAT is managed at Stanford University & University of Pennsylvania (NHGRI U24HG010862).