#!/bin/bash

# 02/13/22
## This file will filter the imputed VCF file to exclude any sites with low Rsq values and create a new VCF
## Then, it will use the new VCF file to create the appropriate binary files

module load vcftools
module load plink

wd="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="chr6.dose.vcf.gz"
excludeFile="lowRsqSNPs.txt"

cd $wd

vcftools --gzvcf ${vcfFileName} --exclude ${excludeFile} --recode --out filtered021322

#### check file paths when vcftools finishes running
plink --vcf $wd/filtered021322.recode.vcf.gz --make-bed --out filtered021322

# now go to run_HLAOmnibus.sh
