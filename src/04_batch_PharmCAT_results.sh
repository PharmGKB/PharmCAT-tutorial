## Author: Binglan Li
## Date: 03/23/02022
## Purpose: organize multiple PharmCAT results into a tabular file

# create a conda environment
conda env create -f src/environment.yml
conda activate json2tsv

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# Organize PharmCAT results
SCRIPT_PATH=src/json2tsv_pharmcat.py

PHARMCAT_ALL_DIR="$PROJECT_DIR"/results/pharmcat_all/
PHARMCAT_ALLELE_TRANSLATION_FILES='<path/to/PharmCAT/GitHub>/src/main/resources/org/pharmgkb/pharmcat/definition/alleles/*translation.json'

python3  "$SCRIPT_PATH"\
  -i "$PHARMCAT_ALL_DIR" \
  -a "$PHARMCAT_ALLELE_TRANSLATION_FILES" \
  -o "$PROJECT_DIR"