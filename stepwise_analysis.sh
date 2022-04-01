#!/bin/bash

## Run the stepwise condition analysis on logistic output

##############################
## Split data by allele type #
##############################
cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg
grep -E "SNP|rs" ./EUR_only.assoc.logistic > ./EUR_SNPs.assoc.logistic
grep -E "CHR|AA" ./EUR_only.assoc.logistic > ./EUR_AA.assoc.logistic
grep -E "CHR|HLA" ./EUR_only.assoc.logistic > ./EUR_HLA.assoc.logistic

##############################
## stepwise on AFR and AMR ###
##############################
module load plink

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="filtered032722.vcf.gz"

filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"
keepFile="T1DGC_HCE_AFR_FINAL_sample_list.txt"
covarFile="T1DGC_HCE_AFR_FINAL_cov.txt"
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
conditionList="AFR_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
outStem="AFR_HLA_step8"

## DON'T FORGET TO CHANGE STEP NAME

plink --vcf $filePath/${vcfFileName} --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --pheno $filterPath/${phenoFile}  --mpheno 2 \
  --maf .01 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the HLA lines
grep -E "CHR|HLA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to findHLA_stepwise.R and repeat until no more significant variants
# when done, clean up folder

######################
## Stepwise on EUR ###
######################
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="tmp_5_fam_EUR_cc_unrelated.txt"
covarFile="T1DGC_HCE_EUR_FINAL_cov.txt"
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
conditionList="EUR_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
outStem="EUR_HLA_step14"

## DON'T FORGET TO CHANGE STEP NAME

plink --bfile $filePath/T1DGC_HCE_unrelated_EUR --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --maf .01 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the HLA lines
# cd $outPath
grep -E "CHR|HLA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to findHLA_stepwise.R and repeat until no more significant variants
# when done. clean up folder

#########################
## Pull summary stats ###
#########################
cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA
pop="AMR"
# copy initial association for the loop to work
cp ./${pop}_HLA.assoc.logistic ./${pop}_HLA_step0.assoc.logistic
# get how many items in SNP list
n=`wc -l ${pop}_condition_list.txt|awk '{print $1}'`

# add header
awk 'BEGIN{print "CHR\tSNP\tBP\tA1\tTEST\tNMISS\tOR\tSTAT\tP"}' ${pop}_top_stats.txt > ${pop}_top_stats.txt
# loop through SNPs
for (( i=0;i<$n;i++ )); do
  allele=`cat ${pop}_condition_list.txt | awk -v j=$(($i+1)) '{if(NR==j){print $0}}'`
  allele=${allele/'*'/'[*]'}
  grep -m 1 $allele ${pop}_HLA_step${i}.assoc.logistic | \
    awk '{print $0}' >> ${pop}_top_stats.txt
done

# remove extra file
rm ./${pop}_HLA_step0.assoc.logistic
