## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT VCF preprocessor on the 30x WGS GeT-RM samples

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# get VCF preprocessor script
wget https://github.com/PharmGKB/PharmCAT/releases/download/v1.5.1/pharmcat-preprocessor-1.5.1.tar.gz
tar -xvf pharmcat-preprocessor-1.5.1.tar.gz
VCF_PREPROCESS_SCRIPT=preprocessor/PharmCAT_VCF_Preprocess.py
# install the required python libraries
pip3 install -r preprocessor/PharmCAT_VCF_Preprocess_py3_requirements.txt

# input VCFs
# remove the header that says "##ALT=<NON_REF>...", a visage of gVCF
TUTORIAL_VCF=PharmCAT_tutorial_get-rm_wgs_30x_grch38.vcf.gz

# reference materials
REF_PGX_VCF=preprocessor/pharmcat_positions.vcf.bgz

# outputs
PREPROCESSED_DIR=results/pharmcat_ready/
PHARMCAT_READY_PREFIX=pharmcat_ready
mkdir -p "$PREPROCESSED_DIR"

######################################################
# Preprocess VCFs
######################################################
python3 "$VCF_PREPROCESS_SCRIPT" \
--input_vcf "$TUTORIAL_VCF" \
--ref_pgx_vcf "$REF_PGX_VCF" \
--output_folder "$PREPROCESSED_DIR" \
--output_prefix "$PHARMCAT_READY_PREFIX"


