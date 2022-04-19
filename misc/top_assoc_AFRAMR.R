# This script takes in the results from the Omnibus test
# for AFR and AMR and returns the top 10 associated sites 

# module load gcc/7.1.0  openmpi/3.1.4  R
# R

library(data.table)
library(dplyr)

##############
## omnibus ###
##############

#set wd: Session > Set Working Directory > Choose Directory , then select CPHG from Finder 
setwd("./data/multiethnic_imputed/chr_6/omnibus")
AFR_omnibus<- fread("./T1DGC_HCE_AFR.OMNIBUS.txt",header = T)
AFR_n30<- AFR_omnibus[,][N_HAPLO>30] 
  #head(AFR_omnibus[order(AFR_omnibus$PVALUE),], 10)
AFR_omni_noAA<- fread("./T1DGC_HCE_AFR.OMNIBUS.noaa.txt",header = T) # without --aa-only flag
AFR_noAA_n30<- AFR_omni_noAA[,][N_HAPLO>30] 

AMR_omnibus<- fread("./T1DGC_HCE_AMR.OMNIBUS.txt",header = T)
AMR_n30<- AMR_omnibus[,][N_HAPLO>30] 
AMR_omni_noAA<- fread("./T1DGC_HCE_AMR.OMNIBUS.noaa.txt",header = T) # without --aa-only flag
AMR_noAA_n30<- AMR_omni_noAA[,][N_HAPLO>30]

top10<- cbind(AFR=head(AFR_omnibus$AA_ID,10),AMR=head(AMR_omnibus$AA_ID,10))
top10
# AFR                 AMR                
# [1,] "AA_A_105_29911087" "AA_B_239_31323201"
# [2,] "AA_A_142_29911198" "AA_B_253_31323159"
# [3,] "AA_A_145_29911207" "AA_B_267_31323117"
# [4,] "AA_A_152_29911228" "AA_B_268_31323114"
# [5,] "AA_A_156_29911240" "AA_B_270_31323108"
# [6,] "AA_A_161_29911255" "AA_B_275_31323000"
# [7,] "AA_A_166_29911270" "AA_B_295_31322940"
# [8,] "AA_A_167_29911273" "AA_B_296_31322937"
# [9,] "AA_A_186_29911909" "AA_B_298_31322931"
# [10,] "AA_A_194_29911933" "AA_B_299_31322928"

##############
## logistic ##
##############
# get the top HLA and AA from each ancestry's logistic regression
setwd("./data/multiethnic_imputed/chr_6/logistic_reg")
AFRlog<- fread("AFR_only.assoc.logistic")
AMRlog<- fread("AMR_only.assoc.logistic")
EURlog<- fread("EUR_only.assoc.logistic")

topHLA_AA<- function(dat){
  datHLA<- dat[grepl("HLA",dat$SNP)]
  print(datHLA[order(datHLA$P)][1])
  
  datAA<- dat[grepl("AA",dat$SNP)]
  print(datAA[order(datAA$P)][1])
}

topHLA_AA(AFRlog)
topHLA_AA(AMRlog)
topHLA_AA(EURlog)
