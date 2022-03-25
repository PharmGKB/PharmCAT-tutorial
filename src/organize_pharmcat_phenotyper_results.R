## Author: Binglan Li
## Date: 03/23/2022
## Purpose: Organize PharmCAT Phenotyper Results


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
library(rjson)
library(optparse)
library(tidyverse)

# read external parameters
opt_list <- list(
  make_option("--input-dir", type="character", default = getwd(), help="Input file directory, default = current working directory"),
  make_option("--input-file-pattern", type="character", default="pharmcat_phenotyper*json", help="Pattern of the input file"),
  make_option("--output-dir", type="character", default= getwd(), help="Output directory"),
  make_option("--prefix-output-file", type="character", default="PharmCAT_Phenotyper_results", help="prefix of the output file")
)
opts <- parse_args(OptionParser(option_list=opt_list))
# parse values
input_dir <- opts$`input-dir`
input_dir <- paste0(input_dir, "/")
input_file_pattern <- opts$`input-file-pattern`
output_dir <- opts$`output-dir`
output_dir <- paste0(output_dir, "/")
output_prefix <- opts$`prefix-output-file`


############################################
## Read files
############################################
# list json files from the PharmCAT Named Allele Matcher module
input_file_list <- list.files(path = input_dir, pattern = input_file_pattern, full.names = TRUE)


############################################
## Organize results
############################################
# print headers
headers <- paste(c("samples", "gene", "phenotype", "hap_1_phenotyper", "hap_2_phenotyper", "hap_1", "hap_2", "hap_1_function", "hap_2_function"), collapse = "\t")
write.table(headers, file = paste0(output_dir, output_prefix, ".txt"), sep = "\t",
            quote = FALSE, row.names = FALSE, col.names = FALSE)

# exhaustively read result json files
for (single_file in input_file_list){
  summary_results <- data.frame()
  sample_id <- unlist(strsplit(single_file, split = "[.]"))[2]
  
  # read in json
  single_file_data <- fromJSON(file = single_file)
  for (i in 1:length(single_file_data)){
    # organize results
    single_gene_results <- single_file_data[[i]] %>% {
      tibble(
        sample_id = sample_id,
        gene = .$geneSymbol,
        phenotype = .$diplotypes %>% map_chr(., "phenotype", .default = "NULL"),
        hap_1_phenotyper = .$diplotypes %>% map_chr(., c("allele1", "name"), .default = "NULL"),
        hap_2_phenotyper = .$diplotypes %>% map_chr(., c("allele2", "name"), .default = "NULL"),
        hap_1 = .$matcherDiplotypes %>% map_chr(., c("allele1", "name"), .default = "NULL"),
        hap_2 = .$matcherDiplotypes %>% map_chr(., c("allele2", "name"), .default = "NULL"),
        hap_1_function = .$diplotypes %>% map_chr(., c("allele1", "function"), .default = "NULL"),
        hap_2_function = .$diplotypes %>% map_chr(., c("allele2", "function"), .default = "NULL")
      )
    }
    single_gene_results <- single_gene_results %>% 
      mutate(hap_1 = recode(hap_1, Unknown = "NULL"),
             hap_2 = recode(hap_2, Unknown = "NULL"))
    # combine single-gene results
    summary_results <- rbind(summary_results, single_gene_results)
  }
  
  
  # write to output
  write.table(summary_results, file = paste0(output_dir, output_prefix, ".txt"), sep = "\t",
              quote = FALSE, row.names = FALSE, col.names = FALSE, append = TRUE)
}


