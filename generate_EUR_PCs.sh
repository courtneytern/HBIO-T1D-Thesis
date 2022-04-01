#!/bin/bash

module load plink
KING=/nv/vol185/T1DGC/USERS/cat7ep/software/king

# tmp_5_fam_EUR_cc_unrelated.txt is after keeping only those 3043 EUR individuals.

# echo -e
# step=15
# nextstep=$(($step+1))
# step14=$(($step-1))
 echo "Prepare data for PCA projection after removing the outliers"
# date

cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/temp
logfile=EUR_PCs.log
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/"

cat $filePath/T1DGC_HCE_unrelated_EUR.fam | awk '$NF ~ /1/ {print $1, $2}' > tmp_EUR_unrelated_control.txt
cat $filePath/T1DGC_HCE_unrelated_EUR.fam | awk '$NF ~ /2/ {print $1, $2}' > tmp_EUR_unrelated_case.txt

plink --bfile $filePath/T1DGC_HCE_unrelated_EUR --keep tmp_EUR_unrelated_control.txt --make-bed --out tmp_2_EUR_unrelated_control &>> $logfile
plink --bfile $filePath/T1DGC_HCE_unrelated_EUR --keep tmp_EUR_unrelated_case.txt --make-bed --out tmp_2_EUR_unrelated_case &>> $logfile

# echo -e
# step=16
# nextstep=$(($step+1))
echo "PCA projection after removing the outliers"
# date

# Projects case samples from AFR population on control samples

$KING -b tmp_2_EUR_unrelated_control.bed,tmp_2_EUR_unrelated_case.bed --pca --proj --rplot --prefix tmp_EUR_unrelated_cc &>> $logfile


#####
## Make AFR AMR PCs
#####

cd /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/temp
pop=AMR
logfile=${pop}_PCs.log
famPath="/nv/vol185/T1DGC/USERS/cat7ep/data"
filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"

cat $famPath/T1DGC_HCE_cc_${pop}\-2021-01-20.fam | awk '$NF ~ /1/ {print $1, $2}' > tmp_${pop}_control.txt
cat $famPath/T1DGC_HCE_cc_${pop}\-2021-01-20.fam | awk '$NF ~ /2/ {print $1, $2}' > tmp_${pop}_case.txt

plink --bfile $filePath/T1DGC_HCE_${pop}\-only --keep tmp_${pop}_control.txt --make-bed --out tmp_2_${pop}_control &>> $logfile
plink --bfile $filePath/T1DGC_HCE_${pop}\-only --keep tmp_${pop}_case.txt --make-bed --out tmp_2_${pop}_case &>> $logfile

# echo -e
# step=16
# nextstep=$(($step+1))
echo "PCA projection of AFR and AMR data after removing the outliers"
# date

# Projects case samples from AFR population on control samples

$KING -b tmp_2_${pop}_control.bed,tmp_2_${pop}_case.bed --pca --proj --rplot --prefix tmp_${pop}_cc &>> $logfile

## copy pc.txt into /nv/vol185/T1DGC/USERS/cat7ep/data (AFR_pc_033122.txt)
