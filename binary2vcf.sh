#!/bin/sh

#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20G
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=berglandlab
#SBATCH -o /scratch/cat7ep/slurmOut/plink.%A_%a.out # Standard output
#SBATCH -e /scratch/cat7ep/slurmOut/plink.%A_%a.err # Standard error

####### sbatch /scratch/cat7ep/Onengut/binary2vcf.sh

step=1
echo "Step $step: Convert PLINK format to VCF format"
date

module load plink
module load bcftools/1.9
module load gzip
module load tabix

dataPath="/nv/vol185/T1DGC/USERS/cat7ep/data/mega_immunochip_data/"
dataPrefix="mega_b37-updated-chr6"
projectFolder="/nv/vol185/T1DGC/USERS/cat7ep/project/mega_ic_092321"
finalname="CT_mega_b37-updated-chr6"
logfile="mega_b37-updated-chr6.log"

# Take binary files and recode it to vcf file

plink2 --bfile $dataPath/${dataPrefix} --recode vcf --out $projectFolder/${finalname}

bcftools sort $projectFolder/${finalname}.vcf  -Oz -o $projectFolder/${finalname}.vcf.gz
