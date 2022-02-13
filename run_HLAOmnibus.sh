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
module load python/3.6.8
module load anaconda

cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

vcfPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
vcfFileName="filtered021322.recode.vcf.gz"

filePath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
bimFile="filtered021322.bim"
famFile="filtered021322.fam"

phePath="/nv/vol185/T1DGC/USERS/cat7ep/data"
phenoFile="T1DGC_HCE-2021-10-07_CT.phe"

outPath="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus"

python -m HLAassoc OMNIBUS \
    --vcf $vcfPath/${vcfFileName} \
    --bim $filePath/${bimFile} \
    --fam $filePath/${famFile} \
    --pheno $phePath/${phenoFile} \
    --out $outPath/multiethnic.OMNIBUS \
    --aa-only \
    --maf-threshold 0
