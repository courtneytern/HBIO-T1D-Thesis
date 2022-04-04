## This script will take in the results from PLINK 
## and sort the P-value column to find the most highly
## associated SNPs 
### This is running on the multiethnic imputed Human Core Exome data

# module load gcc/7.1.0  openmpi/3.1.4 R 
library(data.table)

### Run on rivanna
setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6")
plink<- read.table("./multiethnic.IMPUTED.assoc.logistic",header = T)

orderedPvals<- plink[order(plink$P),]
head(orderedPvals, n=10)

###### archived 
setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/archive_plink")
archive_plink<- read.table("./multiethnic.IMPUTED.assoc.logistic",header = T)

orderedPvals2<- archive_plink[order(archive_plink$P),]
head(orderedPvals2, n=10)