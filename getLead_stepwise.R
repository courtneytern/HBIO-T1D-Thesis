# Second step after logistic association from stepwise_analysis.sh
# Read in HLA assoc file, determine most significant, then add variant to covariate file
library(tidyr)
library(data.table)

# setwd to /nv/vol185/T1DGC/USERS/cat7ep/
setwd("./data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/")

# change population and step number appropriately
logFile<- fread("./EUR_AA_step0.assoc.logistic",header=T)
logFile<- logFile[order(logFile$P),]
logFile
# pull the top significant two-digit HLA allele from logFile
# copy top allele into string 
fwrite(list("AA_B_97_31324201_exon3_CLT"),file="./EUR_condition_list.txt",append=T)
# go back to stepwise_analysis.sh and use updated condition list 


# calc number of tests run for Bonferroni p: 0.05/(X*(steps+1))
###### HLA
## X=length(logFile[(str_count(logFile$SNP,":")==1),][[1]])
##### AA 
## X=length(unique(separate(data.table(SNP=logFile$SNP),SNP,sep="_",into=c("1","2","3","4","5","6"))[,1:3])[[1]])
