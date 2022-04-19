#!/bin/bash

# Make frequency file for each variant in each population, separated by case and control
# Need the sample list to keep one population at a time
module load plink

pop="AMR"
vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="T1DGC_HCE_${pop}_FINAL_sample_list.txt"

cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6

plink --bfile $vcfPath/T1DGC_HCE_${pop}_updated_fam \
      --freq case-control --nonfounders --out filtered041222_${pop}

###
### EUR

keepFile="tmp_5_fam_EUR_cc_unrelated.txt"

plink --bfile $vcfPath/T1DGC_HCE_updated_fam \
      --keep $filePath/$keepFile --freq case-control --out filtered041222_EUR
