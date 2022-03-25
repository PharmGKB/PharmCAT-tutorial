## Author:Binglan Li
## Date: 03/23/2022
## Purpose: PharmCAT on the preprocessed high-coverage WGS GeT-RM samples

# work under the current tutorial directory
PROJECT_DIR="$PWD"
cd "$PROJECT_DIR"

# download pharmcat
wget https://github.com/PharmGKB/PharmCAT/releases/download/v1.5.1/pharmcat-1.5.1-all.jar
PHARMCAT_JAR=pharmcat-1.5.1-all.jar

# reference materials
TEST_SAMPLES=data/test_get-rm_samples.txt
# load sample list from a file to a variable
mapfile -t SAMPLE_LIST < "$TEST_SAMPLES"

# input VCFs
PREPROCESSED_DIR=results/pharmcat_ready/
PHARMCAT_READY_PREFIX=pharmcat_ready

# outputs
PHARMCAT_ALL_DIR=results/pharmcat_all/
MATCHER_DIR=results/pharmcat_matcher/
PHENOTYPER_DIR=results/pharmcat_phenotyper/
REPORTER_DIR=results/pharmcat_reporter/
mkdir -p "$PHARMCAT_ALL_DIR" "$MATCHER_DIR" "$PHENOTYPER_DIR" "$REPORTER_DIR"

######################################################
# PharmCAT - whole
######################################################
PHARMCAT_PREFIX=pharmcat
for SINGLE_SAMPLE in "${SAMPLE_LIST[@]}"; do
  $JAVA -jar "$PHARMCAT_JAR" \
  -vcf "$PREPROCESSED_DIR""$PHARMCAT_READY_PREFIX"."$SINGLE_SAMPLE".vcf \
  -o "$PHARMCAT_ALL_DIR" \
  -f "$PHARMCAT_PREFIX"."$SINGLE_SAMPLE" \
  -k -pj -j
done

######################################################
# PharmCAT - Named Allele Matcher
######################################################
MATCHER_PREFIX=pharmcat_named_allele_matcher
for SINGLE_SAMPLE in "${SAMPLE_LIST[@]}"; do
  $JAVA -cp "$PHARMCAT_JAR" org.pharmgkb.pharmcat.haplotype.NamedAlleleMatcher \
      -vcf "$PREPROCESSED_DIR""$PHARMCAT_READY_PREFIX"."$SINGLE_SAMPLE".vcf \
      -json "$MATCHER_DIR""$MATCHER_PREFIX"."$SINGLE_SAMPLE".json
done

######################################################
# PharmCAT - Phenotyper
######################################################
PHENOTYPER_PREFIX=pharmcat_phenotyper
# use the JSON data from the Named Allele Matcher
for SINGLE_SAMPLE in "${SAMPLE_LIST[@]}"; do
  $JAVA -cp "$PHARMCAT_JAR" org.pharmgkb.pharmcat.phenotype.Phenotyper \
      -c "$MATCHER_DIR""$OUTPUT_PREFIX"."$SINGLE_SAMPLE".json \
      -f "$PHENOTYPER_DIR""$PHENOTYPER_PREFIX"."$SINGLE_SAMPLE".json
done

# use VCF
for SINGLE_SAMPLE in "${SAMPLE_LIST[@]}"; do
  $JAVA -cp "$PHARMCAT_JAR" org.pharmgkb.pharmcat.phenotype.Phenotyper \
      -vcf "$PREPROCESSED_DIR""$PHARMCAT_READY_PREFIX"."$SINGLE_SAMPLE".vcf \
      -f "$PHENOTYPER_DIR""$PHENOTYPER_PREFIX"."$SINGLE_SAMPLE".json
done

######################################################
# PharmCAT - Reporter
######################################################
REPORTER_PREFIX=pharmcat_reporter
for SINGLE_SAMPLE in "${SAMPLE_LIST[@]}"; do
  $JAVA -cp "$PHARMCAT_JAR" org.pharmgkb.pharmcat.reporter.Reporter \
      -p "$PHENOTYPER_DIR""$PHENOTYPER_PREFIX"."$SINGLE_SAMPLE".json \
      -o "$REPORTER_DIR""$REPORTER_PREFIX"."$SINGLE_SAMPLE".html \
      -j "$REPORTER_DIR""$REPORTER_PREFIX"."$SINGLE_SAMPLE".json \
      -t 'Report for '"$SINGLE_SAMPLE"
done
