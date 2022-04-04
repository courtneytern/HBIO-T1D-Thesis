# Create table with two-field HLA genes (cols) and MAF for each ancestry group (rows)
# This will include only the HLA genes that pass the filters 

library(data.table)
library(stringr)

setwd("./data/multiethnic_imputed/chr_6")

# use case-control frequencies
AFRfrq<- fread("./filtered032722_AFR.frq.cc")
AMRfrq<- fread("./filtered032722_AMR.frq.cc")
EURfrq<- fread("./filtered032722_EUR.frq.cc")

# keep only HLA
AFR_HLA<- AFRfrq[grepl("HLA",AFRfrq$SNP),c("SNP","MAF_A","MAF_U")]
AMR_HLA<- AMRfrq[grepl("HLA",AMRfrq$SNP),c("SNP","MAF_A","MAF_U")]
EUR_HLA<- EURfrq[grepl("HLA",EURfrq$SNP),c("SNP","MAF_A","MAF_U")]

# combine all 
merged<- merge(AFR_HLA,AMR_HLA,by="SNP")
merged<- merge(merged,EUR_HLA,by="SNP")
colnames(merged)<- c("SNP","AFR_MAF_case","AFR_MAF_control",
                     "AMR_MAF_case","AMR_MAF_control",
                     "EUR_MAF_case","EUR_MAF_control")

# find two-digit HLA by grep for one ":"
merged<- merged[(str_count(merged$SNP,":")==1),]
fwrite(merged,"./HLA_MAF_cc_table.txt")
