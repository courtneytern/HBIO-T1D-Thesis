#!/bin/bash

## Run the stepwise condition analysis using logistic regression

##############################
## Split data by allele type #
##############################
# cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg
# grep -E "SNP|rs" ./EUR_only.assoc.logistic > ./EUR_SNPs.assoc.logistic
# grep -E "CHR|AA" ./EUR_only.assoc.logistic > ./EUR_AA.assoc.logistic
# grep -E "CHR|HLA" ./EUR_only.assoc.logistic > ./EUR_HLA.assoc.logistic

########################
## Reformat covar file #
########################
pop="EUR"
path="/nv/vol185/T1DGC/USERS/cat7ep/data/"
ogCovar="tmp_10_${pop}_mdspc.txt"
awk '{ if(NR!=1) {print $1,$2,$7,$8,$9,$10,$11} }' $path/$ogCovar > $path/${pop}_mdspc_FINAL.txt

##############################
## stepwise on AFR and AMR ###
##############################
module load plink

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="filtered032722.vcf.gz"

pop="AMR"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="T1DGC_HCE_${pop}_FINAL_sample_list.txt"
covarFile="${pop}_mdspc_FINAL.txt"
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
conditionList="${pop}_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
cd $outPath
outStem="${pop}_HLA_step3"
## DON'T FORGET TO CHANGE STEP NAME
# remove --condition-list for step0

plink --bfile $filePath/T1DGC_HCE_${pop}_updated_fam --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --maf .01 --ci 0.95 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the HLA lines
grep -E "CHR|HLA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to getLead_stepwise.R. Come back to this step and change step name
# repeat until no more significant variants

######################
## Stepwise on EUR ###
######################
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
filterPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
keepFile="tmp_5_fam_EUR_cc_unrelated.txt"
covarFile="EUR_mdspc_FINAL.txt"
conditionPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
conditionList="EUR_condition_list.txt"
outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA"
outStem="EUR_HLA_step12"
## DON'T FORGET TO CHANGE STEP NAME
# no --condition-list line on step0

plink --bfile $filePath/T1DGC_HCE_updated_fam --logistic hide-covar \
  --keep $filterPath/${keepFile} --covar $filterPath/${covarFile} \
  --condition-list $conditionPath/$conditionList \
  --maf .01 --ci 0.95 --allow-no-sex \
  --out $outPath/${outStem}
# keep only the HLA lines
grep -E "CHR|HLA" ./${outStem}.assoc.logistic > ./${outStem}.2.assoc.logistic
rm ./${outStem}.assoc.logistic
mv ./${outStem}.2.assoc.logistic ./${outStem}.assoc.logistic
#go to getLead_stepwise.R. Come back to this step and change step name
# repeat until no more significant variants

#########################
## Pull summary stats ###
#########################
# after all stepwise done
cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_HLA
pop="AFR"
# get how many items in SNP list
n=`wc -l ${pop}_condition_list.txt|awk '{print $1}'`

# add header
awk 'BEGIN{print "CHR\tSNP\tBP\tA1\tTEST\tNMISS\tOR\tSE\tL95\tU95\tSTAT\tP"}' ${pop}_top_stats.txt > ${pop}_top_stats.txt
# loop through SNPs
for (( i=0;i<$n;i++ )); do
  allele=`cat ${pop}_condition_list.txt | awk -v j=$(($i+1)) '{if(NR==j){print $0}}'`
  allele=${allele/'*'/'[*]'}
  grep -m 1 $allele ${pop}_HLA_step${i}.assoc.logistic | \
    awk '{print $0}' >> ${pop}_top_stats.txt
done
