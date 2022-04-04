#! /bin/bash

## This script will re-insert family IDs into imputation data
module load plink

pop="AFR"
releasepath="/nv/vol185/T1DGC/USERS/cat7ep/data"
releasefamilyfam="T1DGC_HCE_cc_${pop}-2021-01-20.fam"
vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFile="filtered032722.vcf.gz"

temp="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/temp"
logfile="updateFamID${pop}.log"

outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"

cd $temp

# Convert to PLINK
  plink --memory 15000 --vcf $vcfPath/$vcfFile \
        --make-bed --out tmp_imp_vcf_${pop}_fam_chr6_1 &>> $logfile

# Update FID
awk '{print $2,$2,$1,$2}' $releasepath/$releasefamilyfam > tmp_imp_vcf_${pop}_update_FID_fam.txt

plink --memory 15000 --bfile tmp_imp_vcf_${pop}_fam_chr6_1  \
      --update-ids tmp_imp_vcf_${pop}_update_FID_fam.txt --make-bed \
      --out tmp_imp_vcf_${pop}_fam_chr6_2 &>> $logfile


# Extract complete families
awk '{print $1,$2,$3,$4}' $releasepath/$releasefamilyfam > tmp_imp_vcf_${pop}_update_parents_fam.txt

plink --memory 15000 --bfile tmp_imp_vcf_${pop}_fam_chr6_2 \
      --keep tmp_imp_vcf_${pop}_update_parents_fam.txt --make-bed \
      --out tmp_imp_vcf_${pop}_fam_chr6_2b &>> $logfile

# Update parents IDs
plink --memory 15000 --bfile tmp_imp_vcf_${pop}_fam_chr6_2b \
      --update-parents tmp_imp_vcf_${pop}_update_parents_fam.txt --make-bed \
      --out tmp_imp_vcf_${pop}_fam_chr6_3 &>> $logfile

# Update sex
awk '{print $1,$2,$5}' $releasepath/$releasefamilyfam > tmp_imp_vcf_${pop}_update_sex_fam.txt

plink --memory 15000 --bfile tmp_imp_vcf_${pop}_fam_chr6_3 \
      --update-sex tmp_imp_vcf_${pop}_update_sex_fam.txt --make-bed \
      --out tmp_imp_vcf_${pop}_fam_chr6_4 &>> $logfile

# Update T1D status
awk '{print $1,$2,$6}' $releasepath/$releasefamilyfam > tmp_imp_vcf_${pop}_update_case_fam.txt

plink --memory 15000 --bfile tmp_imp_vcf_${pop}_fam_chr6_4 \
      --pheno tmp_imp_vcf_${pop}_update_case_fam.txt --make-bed \
      --out tmp_imp_vcf_${pop}_fam_chr6 &>> $logfile

##### PAUSE. Look at folder and decide where to move stuff
# Copy the final updated .fam .bed .bim files
  cp $temp/tmp_imp_vcf_${pop}_fam_chr6.fam $outPath/T1DGC_HCE_${pop}_updated_fam.fam
  cp $temp/tmp_imp_vcf_${pop}_fam_chr6.bed $outPath/T1DGC_HCE_${pop}_updated_fam.bed
  cp $temp/tmp_imp_vcf_${pop}_fam_chr6.bim $outPath/T1DGC_HCE_${pop}_updated_fam.bim
