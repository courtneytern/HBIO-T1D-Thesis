# Read in HLA assoc file, determine most significant, then add variant to covariate file
library(tidyr)
library(data.table)

# setwd to /nv/vol185/T1DGC/USERS/cat7ep/
setwd("./data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/")

# change step number appropriately
logFile<- fread("./EUR_AA_step5.assoc.logistic",header=T)
logFile<- logFile[order(logFile$P),]
logFile
###### HLA
## length(logFile[(str_count(logFile$SNP,":")==1),][[1]])
##### AA 
## length(unique(separate(data.table(SNP=logFile$SNP),SNP,sep="_",into=c("1","2","3","4","5","6"))[,1:3])[[1]])
# pull the top significant two-digit HLA allele from logFile
# copy top allele into string 
fwrite(list("AA_B_97_31324201_exon3_CLT"),file="./EUR_condition_list.txt",append=T)


####
## OMNIBUS
#####

setwd("./data/multiethnic_imputed/chr_6/omnibus")
haploFile<- fread("./T1DGC_HCE_AFR.omnibus.haplo.txt",header=T)
haploFile<- haploFile[order(haploFile$PVALUE),]
haploFile
fwrite(list("AA_DQA1_-16_32605258_exon1_L"),file="./AFR_condition_list.txt",append=T)

# calc p-val as EUR=0.05/(99*tests) AMR=0.05/(107*tests) AFR=0.05/(104*tests)
# 368 for AFR AA, 357 AMR AA, 345 EUR
## where tests=step+1
# go back to runPlink_logistic.sh and use updated condition list 

# We use a bonferroni corrected p-value = 0.05/(number of tests) 
# to define what we will accept as significant.

## There should be as many lines in condition_list.txt as steps+1
## AMR last line of insignificance (output of step 2; pval= 0.05/(107*3)=0.00015576)
###   6          HLA_C*16:01 31236752  T  ADD   293 0.1081 -3.643 0.0002691
## AFR last line (output of step 3, pval=0.05/(104*4)=0.0001201923 )
###  6             HLA_DQB1*06:04 32627329  T  ADD   857 3.489 3.270 0.0010760
## EUR last line (output of step 5; pval= 0.05/(99*6)=8.417508e-05)
### 2:   6       HLA_DQB1*03:03 32627264  T  ADD  3043 0.4073 -3.823 1.319e-04
