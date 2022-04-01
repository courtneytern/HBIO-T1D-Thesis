#!/bin/bash

# 02/13/22
## This file will filter the imputed VCF file to exclude any sites with low Rsq values and create a new VCF
## Then, it will use the new VCF file to create the appropriate binary files

module load plink

wd="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="chr6.dose.vcf.gz"
excludeFile="filteredOutSNPs.txt"

cd $wd

plink --vcf ${vcfFileName} --exclude ${excludeFile} --recode vcf --out filtered032722

#### check file paths when vcftools finishes running
plink --vcf $wd/filtered032722.vcf.gz --make-bed --out filtered032722

# make summary table in make_allele_summary.sh
