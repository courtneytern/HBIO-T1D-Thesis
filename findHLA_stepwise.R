# Read in HLA assoc file, determine most significant, then add variant to covariate file

# setwd to /nv/vol185/T1DGC/USERS/cat7ep/

setwd("./data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA")

# change step number appropriately
logFile<- fread("./EUR_HLA_step14.assoc.logistic",header=T)
logFile<- logFile[order(logFile$P),]
logFile
# pull the top two-digit HLA allele from logFile
# copy top allele into string 
fwrite(list("HLA_B*39:01"),file="./EUR_condition_list.txt",append=T)
# go back to runPlink_logistic.sh and use updated condition list 

# We use a bonferroni corrected p-value = 0.05/(number of tests) 
# to define what we will accept as significant.
## p-value= 0.05/(step# + 1 )

## There should be as many lines in condition_list.txt as steps+1
## AMR last line of insignifiance (output of step 5; pval= 0.05/6)
###  6       HLA_DRB1*04:02 32546590  T  ADD   308 7.8100  2.572 0.01011
## AFR last line (output of step 8 )
### 6             HLA_DPB1*11:01 33043742  T  ADD   891 2.589 2.590 0.009590
## EUR last line (output of step 14)
### 6          HLA_C*16:01 31236752  T  ADD  3043 1.9130  2.642 0.008247
