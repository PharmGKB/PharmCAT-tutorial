## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT VCF preprocessor on the 30x WGS GeT-RM samples

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# get the latest VCF preprocessor script
wget https://github.com/PharmGKB/PharmCAT/releases/download/v1.6.0/pharmcat-preprocessor-1.6.0.tar.gz
tar -xvf pharmcat-preprocessor-1.6.0.tar.gz
VCF_PREPROCESS_SCRIPT=preprocessor/PharmCAT_VCF_Preprocess.py
# install the required python libraries
pip3 install -r preprocessor/PharmCAT_VCF_Preprocess_py3_requirements.txt
# reference PGx positions used by the PharmCAT
REF_PGX_VCF=preprocessor/pharmcat_positions.vcf.bgz

# outputs
PREPROCESSED_DIR=results/pharmcat_ready/
PHARMCAT_READY_PREFIX=pharmcat_ready
mkdir -p "$PREPROCESSED_DIR"

######################################################
# Preprocess VCFs - single-sample VCFs
######################################################
for SINGLE_VCF in $(cat data/single_sample_vcf_list.txt)
do
    # run the PharmCAT VCF preprocessor
    python3 "$VCF_PREPROCESS_SCRIPT" \
      --input_vcf "$SINGLE_VCF" \
      --ref_pgx_vcf "$REF_PGX_VCF" \
      --output_folder "$PREPROCESSED_DIR" \
      --output_prefix "$PHARMCAT_READY_PREFIX"
done

######################################################
# Preprocess VCFs - multi-sample VCF
######################################################
# input multi-sample VCF
TUTORIAL_VCF=data/PharmCAT_tutorial_get-rm_wgs_30x_grch38.vcf.gz
# run the PharmCAT VCF preprocessor
python3 "$VCF_PREPROCESS_SCRIPT" \
  --input_vcf "$TUTORIAL_VCF" \
  --ref_pgx_vcf "$REF_PGX_VCF" \
  --output_folder "$PREPROCESSED_DIR" \
  --output_prefix "$PHARMCAT_READY_PREFIX"


######################################################
# Preprocess VCFs - multiple VCFs divided by chromosomes or into genetic blocks
######################################################
INPUT_VCF_LIST=data/input_vcf_list.txt
python3 "$VCF_PREPROCESS_SCRIPT" \
  --input_list "$INPUT_VCF_LIST" \
  --ref_pgx_vcf "$REF_PGX_VCF" \
  --output_folder "$PREPROCESSED_DIR" \
  --output_prefix "$PHARMCAT_READY_PREFIX"


