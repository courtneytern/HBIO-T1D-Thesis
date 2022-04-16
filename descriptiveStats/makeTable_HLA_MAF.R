# Create table with two-field HLA genes (cols) and MAF for each ancestry group (rows)
# This will include only the HLA genes that pass the filters 

library(data.table)
library(stringr)

setwd("./data/multiethnic_imputed/chr_6")

# use case-control frequencies
AFRfrq<- fread("./filtered041222_AFR.frq.cc")
AMRfrq<- fread("./filtered041222_AMR.frq.cc")
EURfrq<- fread("./filtered041222_EUR.frq.cc")

# keep only HLA
AFR_HLA<- AFRfrq[grepl("HLA",AFRfrq$SNP),c("SNP","A1","MAF_A","MAF_U")]
AMR_HLA<- AMRfrq[grepl("HLA",AMRfrq$SNP),c("SNP","A1","MAF_A","MAF_U")]
EUR_HLA<- EURfrq[grepl("HLA",EURfrq$SNP),c("SNP","A1","MAF_A","MAF_U")]

# keep only AA
AFR_AA<- AFRfrq[grepl("AA",AFRfrq$SNP),c("SNP","MAF_A","MAF_U")]
AMR_AA<- AMRfrq[grepl("AA",AMRfrq$SNP),c("SNP","MAF_A","MAF_U")]
EUR_AA<- EURfrq[grepl("AA",EURfrq$SNP),c("SNP","MAF_A","MAF_U")]

# combine all 
mergedHLA<- merge(AFR_HLA,AMR_HLA,by="SNP")
mergedHLA<- merge(mergedHLA,EUR_HLA,by="SNP")
colnames(mergedHLA)<- c("SNP","A1_AFR","AFR_AF_case","AFR_AF_control",
                        "A1_AMR","AMR_AF_case","AMR_AF_control",
                        "A1_EUR","EUR_AF_case","EUR_AF_control")

mergedAA<- merge(AFR_AA,AMR_AA,by="SNP")
mergedAA<- merge(mergedAA,EUR_AA,by="SNP")
colnames(mergedAA)<- c("SNP","AFR_MAF_case","AFR_MAF_control",
                     "AMR_MAF_case","AMR_MAF_control",
                     "EUR_MAF_case","EUR_MAF_control")

# find two-digit HLA by grep for one ":"
mergedHLA<- mergedHLA[(str_count(mergedHLA$SNP,":")==1),]
fwrite(mergedHLA,"./HLA_AF_cc_table.txt")

fwrite(mergedAA,"./AA_MAF_cc_table.txt")
