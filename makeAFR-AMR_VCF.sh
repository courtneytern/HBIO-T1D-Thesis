#!/bin/bash

# 02/28/22
## This script will make separate VCFs for the AFR-only and AMR-only data

module load plink

wd="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
AFR_samps="T1DGC_HCE_AFR_FINAL_sample_list.txt"
AMR_samps="T1DGC_HCE_AMR_FINAL_sample_list.txt"
AFR_out="T1DGC_HCE_AFR-only"
AMR_out="T1DGC_HCE_AMR-only"

cd $wd

# make VCFs
plink --vcf $wd/filtered021322.recode.vcf.gz \
      --keep $wd/$AFR_samps --recode vcf --out $AFR_out
plink --vcf $wd/filtered021322.recode.vcf.gz \
      --keep $wd/$AMR_samps --recode vcf --out $AMR_out

# make binary files
plink --vcf $wd/${AFR_out}.vcf --make-bed --out $AFR_out
plink --vcf $wd/${AMR_out}.vcf --make-bed --out $AMR_out
