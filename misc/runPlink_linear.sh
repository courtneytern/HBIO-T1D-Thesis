#!/bin/sh

## Run linear regression with Plink on imputed data

module load  plink

vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="filtered021322.recode.vcf.gz"

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"
keepFile="T1DGC_HCE_AFR_FINAL_sample_list.txt"
covarFile="T1DGC_HCE_AFR_FINAL_cov.txt"

outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/linear_reg"

plink --vcf $vcfPath/$vcfFileName --linear \
      --allow-no-sex --double-id \
      --keep $filePath/$keepFile --covar $filePath/$covarFile \
      --pheno $filePath/$phenoFile --mpheno 2 --all-pheno \
      --out $outPath/linear_AFR

# go to run_HLAManhattan.sh to make plot with this data
