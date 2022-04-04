#!/bin/bash

## Run the stepwise condition analysis on logistic output
## for AMINO ACIDS

##############################
## stepwise on AFR and AMR ###
##############################
module load plink

pop="AFR"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"
keepFile="T1DGC_HCE_${pop}_FINAL_sample_list.txt"
covarFile="${pop}_pc_040122_FINAL.txt" # my generated PCs
# covarFile="T1DGC_HCE_${pop}_FINAL_cov.txt"
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/generatedPCs"
# conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA"
conditionList="${pop}_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/generatedPCs"
# outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA"
cd $outPath
outStem="${pop}_AA_step2"
## DON'T FORGET TO CHANGE STEP NAME
# no condition list for step0

plink --bfile $filePath/T1DGC_HCE_${pop}_updated_fam --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --maf .01 --ci 0.95 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the AA lines
grep -E "CHR|AA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to findTop_stepwise.R and repeat until no more significant variants
# when done, clean up folder and scroll down to pull stats for significant alleles

######################
## Stepwise on EUR ###
######################
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="tmp_5_fam_EUR_cc_unrelated.txt"
covarFile="EUR_pc_040122_FINAL.txt" # my generated
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/generatedPCs"
conditionList="EUR_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/generatedPCs"
outStem="EUR_AA_step5"

## DON'T FORGET TO CHANGE STEP NAME

plink --bfile $filePath/T1DGC_HCE_updated_fam --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --maf .01 --ci 0.95 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the HLA lines
# cd $outPath
grep -E "CHR|AA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to findHLA_stepwise.R and repeat until no more significant variants
# when done. clean up folder

#########################
## Pull summary stats ###
#########################
cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA
pop="EUR"
# get how many items in SNP list
n=`wc -l ${pop}_condition_list.txt|awk '{print $1}'`

# add header
awk 'BEGIN{print "CHR\tSNP\tBP\tA1\tTEST\tNMISS\tOR\tSE\tL95\tU95\STAT\tP"}' ${pop}_top_stats.txt > ${pop}_top_stats.txt
# loop through SNPs
for (( i=0;i<$n;i++ )); do
  allele=`cat ${pop}_condition_list.txt | awk -v j=$(($i+1)) '{if(NR==j){print $0}}'`
  allele=${allele/'*'/'[*]'}
  grep -m 1 $allele ${pop}_AA_step${i}.assoc.logistic | \
    awk '{print $0}' >> ${pop}_top_stats.txt
done
