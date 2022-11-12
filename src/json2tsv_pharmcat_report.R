## Author: Binglan Li
## Date: 11/10/2022
## Purpose: Organize PharmCAT Results


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
  make_option("--input-dir", type="character", default = getwd(), help="Input file directory, default = current working directory"),
  make_option("--input-file-pattern", type="character", default="*report.json", help="Pattern of the input file"),
  make_option("--output-dir", type="character", default= getwd(), help="Output directory"),
  make_option("--prefix-output-file", type="character", default="pharmcat_report_results", help="prefix of the output file"),
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
headers <- paste(c("samples", "gene", "phenotype", "phenotype_source","haplotype_1", "haplotype_2", "haplotype_1_function", "haplotype_2_function"), collapse = "\t")
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
  single_file_data <- fromJSON(file = single_file)$genes
  for (data_source in c("CPIC", "DPWG")){
    for (i in 1:length(single_file_data[[data_source]])){
      # organize results
      single_gene_results <- single_file_data[[data_source]][[i]] %>% {
        tibble(
          sample_id = sample_id,
          gene = .$geneSymbol,
          phenotype = .$recommendationDiplotypes %>% map_chr(., "phenotypes", .default = "No Result"),
          phenotype_source = .$phenotypeSource,
          haplotype_1 = .$recommendationDiplotypes %>% map_chr(., c("allele1", "name"), .default = "NA"),
          haplotype_2 = .$recommendationDiplotypes %>% map_chr(., c("allele2", "name"), .default = "NA"),
          haplotype_1_function = .$recommendationDiplotypes %>% map_chr(., c("allele1", "function"), .default = "NA"),
          haplotype_2_function = .$recommendationDiplotypes %>% map_chr(., c("allele2", "function"), .default = "NA")
        )
      }
      single_gene_results <- single_gene_results %>%
        mutate(haplotype_1 = recode(haplotype_1, Unknown = "NULL"),
               haplotype_2 = recode(haplotype_2, Unknown = "NULL"),
               phenotype = recode(phenotype, `n/a` = "No Result"))
      # combine single-gene results
      summary_results <- rbind(summary_results, single_gene_results)
    }
    
  }
  
  # write to output
  write.table(summary_results, file = paste0(output_dir, output_prefix, ".tsv"), sep = "\t",
              quote = FALSE, row.names = FALSE, col.names = FALSE, append = TRUE)
}
# alarm of the output file
print(paste("Writing the TSV output to ", paste0(output_dir, output_prefix, ".tsv"), sep = ""))

# print running time
edt <- Sys.time()
print(edt-bgt)