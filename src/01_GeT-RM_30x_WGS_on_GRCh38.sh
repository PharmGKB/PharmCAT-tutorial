## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT tutorial using the GeT-RM samples that were part of the International Genome Sample Resource
##          30x WGS on GRCh38 datasets sequenced and prepared by the New York Genome Center

# work under the current tutorial directory
PROJECT_DIR="$PWD"
RAW_VCF_DIR="$PROJECT_DIR"/data/raw_vcf/
cd "$PROJECT_DIR"

# path to the tutorial GeT-RM sample list
TEST_SAMPLES=data/test_get-rm_samples.txt
# manually prepared PGx regions based on "PharmCAT/pharmcat_positions.vcf"
PGX_GENE_REGION_FILE=pharmcat_positions_w_1Mbp_padding_regions.txt

# define the desired VCF file name that will be used for the tutorial
TUTORIAL_VCF=PharmCAT_tutorial_get-rm_wgs_30x_grch38.vcf.gz

#######################################################
## 01. Extract PGx regions
#######################################################
TO_BE_CONCAT_FILE_LIST="$RAW_VCF_DIR"to_be_concatenated_file_list.txt
# remove if a $TO_BE_CONCAT_FILE_LIST already exists
if [ -f "$TO_BE_CONCAT_FILE_LIST" ]; then rm "$TO_BE_CONCAT_FILE_LIST"; fi
# list files
CHR_LIST=(1 2 4 6 7 10 12 13 16 19 22)
for CHR in "${CHR_LIST[@]}"; do
   bcftools view \
   -S "$TEST_SAMPLES" \
   -R "$PGX_GENE_REGION_FILE" \
   -no-version \
   -i 'FILTER="PASS"' \
   -Oz \
   -o "$RAW_VCF_DIR"20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr"$CHR".recalibrated_variants.get-rm.vcf.gz \
   "$RAW_VCF_DIR"20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr"$CHR".recalibrated_variants.vcf.gz

   echo "$RAW_VCF_DIR"20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr"$CHR".recalibrated_variants.get-rm.vcf.gz \
    >> "$TO_BE_CONCAT_FILE_LIST"
done

#######################################################
## 02. concatenate by-chromosome VCFs
#######################################################
# concatenate VCFs of different chromosomes into one
$BCFTOOLS concat \
--file-list "$TO_BE_CONCAT_FILE_LIST" \
-no-version \
-Oz \
-o "$TUTORIAL_VCF"
