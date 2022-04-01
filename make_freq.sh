#!/bin/bash

# Make summary table for filtered, multiethnic-imputed VCF
module load plink

vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcf="filtered032722.vcf.gz"
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="T1DGC_HCE_AMR_FINAL_sample_list.txt"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"


cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6

plink --vcf $vcfPath/$vcf --keep $filePath/$keepFile \
      --pheno $filePath/${phenoFile} --allow-no-sex \
      --freq case-control --out filtered032722_AMR

###
### EUR

keepFile="tmp_5_fam_EUR_cc_unrelated.txt"

plink --bfile $vcfPath/T1DGC_HCE_updated_fam \
      --keep $filePath/$keepFile --freq case-control --out filtered032722_EUR
