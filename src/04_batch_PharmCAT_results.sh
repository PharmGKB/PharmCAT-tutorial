## Author: Binglan Li
## Date: 03/23/02022
## Purpose: organize multiple PharmCAT results into a tabular file

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

###############################
## Organize Named Allele Matcher results
###############################
SCRIPT_PATH=src/organize_pharmcat_named_allele_matcher_results.R

MATCHER_DIR="$PROJECT_DIR"results/pharmcat_matcher/
MATCHER_PATTERN=pharmcat_named_allele_matcher.*json

Rscript  "$SCRIPT_PATH"\
  --input-dir "$MATCHER_DIR" \
  --input-file-pattern "$MATCHER_PREFIX" \
  --output-dir "$PROJECT_DIR"

###############################
## Organize phenotyper results
###############################
SCRIPT_PATH=src/organize_pharmcat_phenotyper_results.R

PHENOTYPER_DIR="$PROJECT_DIR"results/pharmcat_phenotyper/
PHENOTYPER_PATTERN=pharmcat_phenotyper.*json

Rscript  "$SCRIPT_PATH" \
  --input-dir "$PHENOTYPER_DIR" \
  --input-file-pattern "$PHENOTYPER_PATTERN" \
  --output-dir "$PROJECT_DIR"
