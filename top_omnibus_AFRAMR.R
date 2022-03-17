# This script takes in the results from the Omnibus test
# for AFR and AMR and returns the top 10 associated sites 

# module load gcc/7.1.0  openmpi/3.1.4  R
# R

library(data.table)
library(dplyr)

setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus")
AFR_omnibus<- fread("./T1DGC_HCE_AFR.OMNIBUS.txt",header = T)
AMR_omnibus<- fread("./T1DGC_HCE_AMR.OMNIBUS.txt",header = T)

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