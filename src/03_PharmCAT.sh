## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT on the preprocessed high-coverage WGS GeT-RM samples

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# download pharmcat
PHARMCAT_JAR=pharmcat-latest-version-all.jar

# reference materials
TEST_SAMPLES="$PROJECT_DIR"/data/test_get-rm_samples.txt
# one way to generate such a list of samples is via bcftools
bcftools query -l "$PROJECT_DIR"/data/pharmcat_tutorial_get-rm_wgs_30x_grch38.vcf.bgz > "$TEST_SAMPLES"

# input VCFs
PREPROCESSED_DIR="$PROJECT_DIR"/results/pharmcat_ready/

# outputs directories
PHARMCAT_ALL_DIR="$PROJECT_DIR"/results/pharmcat_all/
MATCHER_DIR="$PROJECT_DIR"/results/pharmcat_matcher/
PHENOTYPER_DIR="$PROJECT_DIR"/results/pharmcat_phenotyper/
REPORTER_DIR="$PROJECT_DIR"/results/pharmcat_reporter/
RESEARCH_DIR="$PROJECT_DIR"/results/pharmcat_for_research/
mkdir -p "$PHARMCAT_ALL_DIR" "$MATCHER_DIR" "$PHENOTYPER_DIR" "$REPORTER_DIR" "$RESEARCH_DIR"

######################################################
# PharmCAT - whole
######################################################
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" \
  -vcf "$PREPROCESSED_DIR""$SINGLE_SAMPLE".preprocessed.vcf \
  -po data/outside_calls_from_get-rm."$SINGLE_SAMPLE".txt \
  -o "$PHARMCAT_ALL_DIR"
done

######################################################
# PharmCAT - Named Allele Matcher
######################################################
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" -matcher -matcherHtml \
      -vcf "$PREPROCESSED_DIR""$SINGLE_SAMPLE".preprocessed.vcf \
      -o "$MATCHER_DIR"
done

######################################################
# PharmCAT - Phenotyper
######################################################
# use the JSON data from the Named Allele Matcher
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" -phenotyper \
      -pi "$MATCHER_DIR""$SINGLE_SAMPLE".preprocessed.match.json \
      -po data/outside_calls_from_get-rm."$SINGLE_SAMPLE".txt \
      -o "$PHENOTYPER_DIR"
done

# use VCF
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" -matcher -phenotyper \
      -vcf "$PREPROCESSED_DIR""$SINGLE_SAMPLE".preprocessed.vcf \
      -po data/outside_calls_from_get-rm."$SINGLE_SAMPLE".txt \
      -o "$PHENOTYPER_DIR"
done

######################################################
# PharmCAT - Reporter
######################################################
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" -reporter \
      -ri "$PHENOTYPER_DIR""$SINGLE_SAMPLE".preprocessed.phenotype.json \
      -o "$REPORTER_DIR" \
      -rt 'Report for '"$SINGLE_SAMPLE"
done

######################################################
# PharmCAT - Combination or Partial Alleles
######################################################
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" \
  -research combinations \
  -vcf "$PREPROCESSED_DIR""$SINGLE_SAMPLE".preprocessed.vcf \
  -o "$RESEARCH_DIR" \
  -bf "$SINGLE_SAMPLE".combinations
done

######################################################
# PharmCAT - CYP2D6
######################################################
for SINGLE_SAMPLE in $(cat "$TEST_SAMPLES")
do
  java -jar "$PHARMCAT_JAR" \
  -research cyp2d6 \
  -vcf "$PREPROCESSED_DIR""$SINGLE_SAMPLE".preprocessed.vcf \
  -o "$RESEARCH_DIR" \
  -bf "$SINGLE_SAMPLE".cyp2d6
done

