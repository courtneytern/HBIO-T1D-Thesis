#!/bin/sh

#SBATCH -N 1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=120G
#SBATCH --time=6:00:00
#SBATCH --partition=largemem
#SBATCH --account=berglandlab_standard
#SBATCH -o /scratch/cat7ep/slurmOut/HLAOmnibus.%A_%a.out # Standard output
#SBATCH -e /scratch/cat7ep/slurmOut/HLAOmnibus.%A_%a.err # Standard error

####### sbatch /nv/vol185/T1DGC/USERS/cat7ep/T1D-Thesis/run_HLAOmnibus.sh

module load  gcc/7.1.0  openmpi/3.1.4 R/3.6.3
module load anaconda

cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="T1DGC_HCE_unrelated_EUR.vcf"

bPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
bimFile="T1DGC_HCE_unrelated_EUR.bim"
famFile="T1DGC_HCE_unrelated_EUR.fam"

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-noheader_recode.phe"
covarFile="EUR_covars_final.txt" # recode to FID,IID,PC1-10

outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus"

python -m HLAassoc OMNIBUS_LOGISTIC \
    --vcf $vcfPath/${vcfFileName} \
    --bim $bPath/${bimFile} \
    --fam $bPath/${famFile} \
    --covars $outPath/${covarFile} \
    --pheno $filePath/${phenoFile} \
    --out $outPath/T1DGC_HCE_EUR_AA.mds \
    --maf-threshold 0.01 \
    --aa-only

##################
## AFR and AMR ###
##################
cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

pop="AFR"
vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFile="T1DGC_HCE_${pop}-only.vcf"

bPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
bimFile="T1DGC_HCE_${pop}_updated_fam.bim"
famFile="T1DGC_HCE_${pop}_updated_fam.fam"

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-noheader_recode.phe" # recode pheno to no header; 0=control, 1=case
covarFile="${pop}_covars_final.txt" # recode to FID,IID,PC1-10

outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus"

python -m HLAassoc OMNIBUS_LOGISTIC \
    --vcf $vcfPath/${vcfFile} \
    --bim $bPath/${bimFile} \
    --fam $bPath/${famFile} \
    --covars $outPath/${covarFile} \
    --pheno $filePath/${phenoFile} \
    --out $outPath/T1DGC_HCE_${pop}_AA.mds \
    --maf-threshold 0.01 \
    --aa-only

## Add CHR 6 col for locuszoom
cd $outPath

pop="EUR"
awk -F'\t' '{ if(NR!=1){print$0,"\t"6} }' T1DGC_HCE_${pop}_AA.mds.txt > locuszoom.${pop}_AA.mds.txt
sort -k 4 locuszoom.${pop}_AA.mds.txt > locuszoom.${pop}_AA2.mds.txt
mv locuszoom.${pop}_AA2.mds.txt locuszoom.${pop}_AA.mds.txt
