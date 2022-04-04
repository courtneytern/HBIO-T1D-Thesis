## This script will take in the results from PLINK and HLAassoc 
## and compare the p-values and odds ratios 

# module load gcc/7.1.0  openmpi/3.1.4  intel/18.0  intelmpi/18.0   R 
library(data.table)

### Run on rivanna
setwd("/nv/vol185/T1DGC/USERS/cat7ep/")
plink<- read.table("/nv/vol185/T1DGC/USERS/cat7ep/data/HLAassoc_HLA_lines_only.txt",header = T)
  plink<- data.table(plink)
HLAassoc<- read.table("/nv/vol185/T1DGC/USERS/cat7ep/data/logistic_HLA_lines_only.txt",header=T)
  HLAassoc<- data.table(HLAassoc)

## merge 
setkey(plink,SNP)
setkey(HLAassoc,SNP)
mergedHLA<- merge(plink,HLAassoc)
# keep only relevant columns
mergedHLA.2<- mergedHLA[,c("SNP","OR.x","OR.y","P.x","P.y")]

## check if identical
identical(mergedHLA.2[['OR.x']],mergedHLA.2[['OR.y']])
identical(mergedHLA.2[['P.x']],mergedHLA.2[['P.y']])
### Both are true! 