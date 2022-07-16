## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT VCF preprocessor on the 30x WGS GeT-RM samples

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# get the latest VCF preprocessor script
wget https://github.com/PharmGKB/PharmCAT/releases/latest/pharmcat-preprocessor-<latest_version>.tar.gz
tar -xvf pharmcat-preprocessor-<latest_version>.tar.gz
VCF_PREPROCESS_SCRIPT=preprocessor/PharmCAT_VCF_Preprocess.py
# install the required python libraries
pip3 install -r preprocessor/PharmCAT_VCF_Preprocess_py3_requirements.txt
# reference PGx positions used by the PharmCAT
REF_PGX_VCF=preprocessor/pharmcat_positions.vcf.bgz

# outputs
PREPROCESSED_DIR=results/pharmcat_ready/
mkdir -p "$PREPROCESSED_DIR"

######################################################
# Preprocess VCFs - single-sample VCFs
######################################################
for SINGLE_VCF in $(cat data/single_sample_vcf_list.txt)
do
    # run the PharmCAT VCF preprocessor
    python3 "$VCF_PREPROCESS_SCRIPT" \
      -vcf "$SINGLE_VCF" \
      -refVcf "$REF_PGX_VCF" \
      -o "$PREPROCESSED_DIR"
done

######################################################
# Preprocess VCFs - multi-sample VCF
######################################################
# input multi-sample VCF
TUTORIAL_VCF=data/PharmCAT_tutorial_get-rm_wgs_30x_grch38.vcf.bgz
# run the PharmCAT VCF preprocessor
python3 "$VCF_PREPROCESS_SCRIPT" \
  -vcf "$TUTORIAL_VCF" \
  -refVcf "$REF_PGX_VCF" \
  -o "$PREPROCESSED_DIR"

######################################################
# Preprocess VCFs - multiple VCFs divided by chromosomes or into genetic blocks
######################################################
INPUT_VCF_LIST=data/input_vcf_list.txt
python3 "$VCF_PREPROCESS_SCRIPT" \
  -vcf "$INPUT_VCF_LIST" \
  -refVcf "$REF_PGX_VCF" \
  -o "$PREPROCESSED_DIR"


