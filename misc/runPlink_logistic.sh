#!/bin/bash

## This script runs plink on the imputed humancore exome data; imputed results pulled from Michigan imputation server
## Will output the assocation based on logistic regression

module load plink

######################
## edit covar file ###
######################
# cd /nv/vol185/T1DGC/USERS/cat7ep/data
# # print first col twice to match fam ID and individ ID
# awk '{ print $2,$2,$3,$4,$5,$6 }' < T1DGC_HCE_AFR_cov.txt > T1DGC_HCE_AFR_FINAL_cov.txt

# remove sex/cc status from EUR PCs. do not print header
awk '{ if( NR!=1 ) {print $1,$2,$7,$8,$9,$10} }' < T1DGC_HCE_pc_EUR.txt > T1DGC_HCE_EUR_FINAL_cov.txt

###############################
## run plink on AFR and AMR ###
###############################
# run plink on the imputed files. will give the SNP associations
## run with keep and covar

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
# 1KG imputed file path:
## filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/1KG_imputed_032321"
vcfFileName="filtered032722.vcf.gz"

filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"
keepFile="T1DGC_HCE_AMR_FINAL_sample_list.txt"
covarFile="T1DGC_HCE_AMR_FINAL_cov.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg"
outStem="AMR_only"
# 1KG imputed out stem:
## outStem="1KG.AMR_only"

# plink --vcf $filePath/${vcfFileName} --logistic --pheno $filePath/${phenoFile} --out multiethnic.IMPUTED --allow-no-sex --double-id

# get just AFR/AMR samples and adjust for population structure
plink --vcf $filePath/${vcfFileName} --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --pheno $filterPath/${phenoFile}  --mpheno 2 \
  --maf .01 --allow-no-sex \
  --out $outPath/${outStem}


#################################
## logistic regression on EUR ###
#################################
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="tmp_5_fam_EUR_cc_unrelated.txt"
covarFile="T1DGC_HCE_EUR_FINAL_cov.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg"
outStem="EUR_only"

plink --bfile $filePath/T1DGC_HCE_unrelated_EUR --logistic hide-covar \
  --keep $filePath/${keepFile} --covar $filterPath/${covarFile} \
  --maf .01 --allow-no-sex \
  --out $outPath/${outStem}

# go to run_HLAManhattan.sh to make plot with this data
# go to stepwise_analysis.sh to initiate stepwise process
