## Author: Binglan Li
## Date: 11/10/2022
## Purpose: Organize PharmCAT Named Allele Matcher Results


############################################
## Menu
## Load necessary libraries and scripts
## Read files
## Organize results
## Output
############################################

############################################
## Load necessary libraries and scripts
############################################
suppressMessages(if (!require(rjson, quietly=T)) {install.packages("rjson"); library(rjson, quietly = T)})
suppressMessages(if (!require(optparse, quietly=T)) {install.packages("optparse"); library(optparse, quietly = T)})
suppressMessages(if (!require(tidyverse, quietly=T)) {install.packages("tidyr"); library(tidyr, quietly = T)})
suppressMessages(if (!require(foreach, quietly=T)) {install.packages("foreach"); library(foreach, quietly = T)})
suppressMessages(if (!require(doParallel, quietly=T)) {install.packages("doParallel"); library(doParallel, quietly = T)})

# read external parameters
opt_list <- list(
  make_option("--input-dir", type="character", default = getwd(), help="Full path to the input file directory"),
  make_option("--input-file-pattern", type="character", default="*match.json", help="Pattern of the input file"),
  make_option("--output-dir", type="character", default= getwd(), help="Output directory"),
  make_option("--prefix-output-file", type="character", default="pharmcat_named_allele_matcher_results", help="prefix of the output file"),
  make_option("--core", type="numeric", default=1, help="Number of cores to run parallel tasks (default = %default)")
)
opts <- parse_args(OptionParser(option_list=opt_list))
# parse values
input_dir <- opts$`input-dir`
input_dir <- paste0(input_dir, "/")
input_file_pattern <- opts$`input-file-pattern`
output_dir <- opts$`output-dir`
output_dir <- paste0(output_dir, "/")
output_prefix <- opts$`prefix-output-file`

# parallel cores
numCores <- opts$core
print(paste0("numCores=", numCores))

############################################
## Read files
############################################
# list json files from the PharmCAT Named Allele Matcher module
input_file_list <- list.files(path = input_dir, pattern = input_file_pattern, full.names = TRUE)


############################################
## Organize results
############################################
# print headers
headers <- paste(c("samples", "gene", "diplotype", "haplotype_1", "haplotype_2", "haplotype_1_variants", "haplotype_2_variants", "missing_positions"),
                 collapse = "\t")
write.table(headers, file = paste0(output_dir, output_prefix, ".tsv"), sep = "\t",
            quote = FALSE, row.names = FALSE, col.names = FALSE)

# start parallelization
bgt <- Sys.time()
registerDoParallel(numCores)

# read result json files one by one
foreach_output <- data.frame()
foreach_output <- foreach(i=1:length(input_file_list), .combine = rbind) %dopar% {
  single_file <- input_file_list[i]
  summary_results <- data.frame()

  single_file_name_fields <- unlist(strsplit(basename(single_file), split = "[.]"))
  sample_id <- single_file_name_fields[length(single_file_name_fields) - 3]

  # read in json
  single_file_data <- fromJSON(file = single_file)
  single_file_data <- single_file_data$results

  for (i in 1:length(single_file_data)){
    # read haplotypes
    single_gene_results <- single_file_data[[i]] %>% {
      tibble(
        sample_id = sample_id,
        gene = .$gene,
        diplotype = .$diplotypes %>% map_chr(., "name", .default = "NULL"),
        hap_1 = .$diplotypes %>% map_chr(., c("haplotype1", "name"), .default = "NULL"),
        hap_2 = .$diplotypes %>% map_chr(., c("haplotype2", "name"), .default = "NULL")
      )
    }

    # read missing positions
    missing_pos <- single_file_data[[i]] %>% {
      tibble(
        sample_id = sample_id,
        gene = .$gene,
        missing_positions = .$matchData$missingPositions %>% map_dbl(., "position")
      )
    }
    # collapse rows of missing positions
    missing_pos <- missing_pos %>%
      transmute(sample_id, gene, missing_positions = paste0(missing_positions, collapse = ";")) %>%
      unique

    # read variants from diplotype field if available
    # otherwise, read from the variants field
    # if SLCO1B1 = no call, extract alts anyway
    if (nrow(single_gene_results) > 0){
      variant_list <- single_file_data[[i]] %>% {
        tibble(
          sample_id = sample_id,
          gene = .$gene,
          hap_1 = .$diplotypes %>% map_chr(~ paste0(unlist(.x$haplotype1$sequences), collapse = "")),
          hap_2 = .$diplotypes %>% map_chr(~ paste0(unlist(.x$haplotype2$sequences), collapse = ""))
        )
      }
      variant_list <- variant_list %>%
        mutate(idx = 1:nrow(variant_list)) %>%
        pivot_longer(hap_1:hap_2, names_to = "idx_hap", values_to = "variants") %>%
        separate_rows(variants, sep = ";") %>%
        filter(variants != "") %>%
        mutate(variants = str_replace_all(variants, ":", "_")) %>%
        group_by(idx, idx_hap) %>%
        transmute(sample_id, gene, variants = paste0(variants, collapse = ";")) %>%
        unique %>%
        pivot_wider(names_from = idx_hap, values_from = variants, names_glue = "{idx_hap}_{.value}",) %>%
        ungroup %>%
        mutate(hap_1_variants = ifelse("hap_1_variants" %in% names(.), hap_1_variants, character(0)),
               hap_2_variants = ifelse("hap_2_variants" %in% names(.), hap_2_variants, character(0))) %>%
        select(sample_id, gene, hap_1_variants, hap_2_variants)
    } else {
      variant_list <- single_file_data[[i]] %>% {
        tibble(
          sample_id = sample_id,
          gene = .$gene,
          pos = .$variants %>% map_dbl(., "position"),
          vcf_call = .$variants %>% map_chr (., "vcfCall"),
          idx_hap = c("hap_1_variants|hap_2_variants")
        )
      }
      variant_list <- variant_list %>%
        separate_rows(vcf_call, idx_hap, sep = "\\|", convert = FALSE) %>%
        transmute(sample_id, idx_hap, gene, variants = paste0(pos, "_", vcf_call)) %>%
        group_by(idx_hap) %>%
        transmute(sample_id, gene, variants = paste0(variants, collapse = ";")) %>%
        unique %>%
        pivot_wider(names_from = idx_hap, values_from = variants) %>%
        mutate(hap_1_variants = ifelse("hap_1_variants" %in% names(.), hap_1_variants, character(0)),
               hap_2_variants = ifelse("hap_2_variants" %in% names(.), hap_2_variants, character(0))) %>%
        select(sample_id, gene, hap_1_variants, hap_2_variants)
    }


    # combine haplotype and variants
    if (nrow(single_gene_results) > 0){
      single_gene_summary <- data.frame(sample_id = sample_id,
                                        gene = single_file_data[[i]]$gene,
                                        diplotype = single_gene_results$diplotype,
                                        hap_1 = single_gene_results$hap_1,
                                        hap_2 = single_gene_results$hap_2,
                                        missing_positions = ifelse(length(missing_pos$missing_positions) > 0, missing_pos$missing_positions, "NULL"))
      if ( nrow(variant_list) == 0 ){
        single_gene_summary$hap_1_variants <- "NULL"
        single_gene_summary$hap_2_variants <- "NULL"
      } else {
        single_gene_summary$hap_1_variants <- variant_list$hap_1_variants
        single_gene_summary$hap_2_variants <- variant_list$hap_2_variants
      }

      single_gene_summary <- single_gene_summary %>%
        select(sample_id, gene, diplotype, hap_1, hap_2, hap_1_variants, hap_2_variants, missing_positions)
    } else if (nrow(variant_list) > 0){
      single_gene_summary <- data.frame(sample_id = sample_id,
                                        gene = single_file_data[[i]]$gene,
                                        diplotype = "NULL",
                                        hap_1 = "NULL",
                                        hap_2 = "NULL",
                                        hap_1_variants = variant_list$hap_1_variants,
                                        hap_2_variants = variant_list$hap_2_variants,
                                        missing_positions = ifelse(length(missing_pos$missing_positions) > 0, missing_pos$missing_positions, "NULL"))

    }else {
      single_gene_summary <- data.frame(sample_id = sample_id,
                                        gene = single_file_data[[i]]$gene,
                                        diplotype = "NULL",
                                        hap_1 = "NULL",
                                        hap_2 = "NULL",
                                        hap_1_variants = "NULL",
                                        hap_2_variants = "NULL",
                                        missing_positions = ifelse(length(missing_pos$missing_positions) > 0, missing_pos$missing_positions, "NULL"))
    }

    # combine single-gene results
    summary_results <- rbind(summary_results, single_gene_summary)

    # handle variant of interest for CYP2C9
    if(single_gene_summary$gene[1] == "CYP2C9"){
      cyp2c9_poi_genotypes <- map_chr(single_file_data[[i]]$"variantsOfInterest", c("vcfCall"), .default = "NULL")
      cyp2c9_poi_result <- data.frame(sample_id = sample_id, gene = "CYP2C9 POI (rs12777823)",
                                      diplotype = cyp2c9_poi_genotypes, hap_1 = "NULL", hap_2 = "NULL",
                                      hap_1_variants = "NULL", hap_2_variants = "NULL",
                                      missing_positions = "94645745")
      if(cyp2c9_poi_genotypes != "NULL"){
        poi_hap_1 <- unlist(strsplit(cyp2c9_poi_genotypes, c("[/|//]")))[1]
        poi_hap_2 <- unlist(strsplit(cyp2c9_poi_genotypes, c("[/|//]")))[2]
        cyp2c9_poi_result$hap_1 <- paste0("rs12777823_", poi_hap_1)
        cyp2c9_poi_result$hap_2 <- paste0("rs12777823_", poi_hap_2)
        cyp2c9_poi_result$hap_1_variants <- paste0("94645745_", poi_hap_1)
        cyp2c9_poi_result$hap_2_variants <- paste0("94645745_", poi_hap_2)
        cyp2c9_poi_result$missing_positions <- "NULL"
      }
      # concatenate CYP2C9 POI into summary data frame
      summary_results <- rbind(summary_results, cyp2c9_poi_result)
    }
  }

  # fill in no calls / no results
  summary_results <- summary_results %>%  replace(is.na(.), "NULL")
  # write to output
  write.table(summary_results, file = paste0(output_dir, output_prefix, ".tsv"), sep = "\t",
              quote = FALSE, row.names = FALSE, col.names = FALSE, append = TRUE)
}
# alarm of the output file
print(paste("Writing the TSV output to ", paste0(output_dir, output_prefix, ".tsv"), sep = ""))

# print running time
edt <- Sys.time()
print(edt-bgt)

