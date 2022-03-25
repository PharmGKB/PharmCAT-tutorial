#!/bin/bash
#SBATCH --job-name=dl_vcf
#SBATCH --time=1-
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --output=dl_vcf.%A_%a.log
#SBATCH --array=0-10

## Author:Binglan Li
## Date: 03/04/2022
## Purpose: Download 30x whole-genome sequencing data on GRCh38 for the GeT-RM samples
## Website: https://www.internationalgenome.org/data-portal/data-collection/30x-grch38
## Paper: https://www.biorxiv.org/content/10.1101/2021.02.06.430068v2.full

# work under the current tutorial directory
PROJECT_DIR="$PWD"
RAW_VCF_DIR="$PROJECT_DIR"/data/raw_vcf/
mkdir -p "$RAW_VCF_DIR"
cd "$RAW_VCF_DIR"

#######################################################
## 01. Download VCFs
#######################################################
CHR_LIST=(chr1 chr2 chr4 chr6 chr7 chr10 chr12 chr13 chr16 chr19 others)
FTP_SITE=ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_raw_GT_with_annot/
wget "$FTP_SITE"20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_"${CHR_LIST["$SLURM_ARRAY_TASK_ID"]}".recalibrated_variants.vcf.gz
wget "$FTP_SITE"20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_"${CHR_LIST["$SLURM_ARRAY_TASK_ID"]}".recalibrated_variants.vcf.gz.tbi



