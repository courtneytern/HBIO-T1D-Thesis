#!/bin/bash

# 02/28/22
## This script will make separate VCFs for the AFR-only and AMR-only data

module load plink

wd="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
sampsDir="/nv/vol185/T1DGC/USERS/cat7ep/data"
AFR_samps="T1DGC_HCE_AFR_FINAL_sample_list.txt"
AMR_samps="T1DGC_HCE_AMR_FINAL_sample_list.txt"
EUR_samps="tmp_5_fam_EUR_cc_unrelated.txt"
AFR_out="T1DGC_HCE_AFR-only"
AMR_out="T1DGC_HCE_AMR-only"
EUR_out="T1DGC_HCE_unrelated_EUR"

cd $wd

# make VCFs
plink --vcf $wd/filtered032722.vcf.gz \
      --keep $sampsDir/$AFR_samps --recode vcf --out $AFR_out
plink --vcf $wd/filtered032722.vcf.gz \
      --keep $sampsDir/$AMR_samps --recode vcf --out $AMR_out
plink --bfile $wd/T1DGC_HCE_updated_fam \
      --keep $wd/$EUR_samps --recode vcf --out $wd/$EUR_out

# make binary files
plink --vcf $wd/${AFR_out}.vcf --make-bed --out $AFR_out
plink --vcf $wd/${AMR_out}.vcf --make-bed --out $AMR_out


plink --bfile T1DGC_HCE_updated_fam --keep $wd/$EUR_samps --make-bed --out $EUR_out
