#!/bin/sh

module load  gcc/7.1.0  openmpi/3.1.4
module load python/3.6.8
module load anaconda

cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

# chmod +x dependency/plink

######################
### run HLA-TAPAS ####
######################

python -m HLAassoc LOGISTIC \
    --vcf HLAassoc/example/IMPUTED.1958BC.bgl.phased.vcf.gz \
    --out Myassoc/IMPUTED.1958BC \
    --pheno HLAassoc/example/1958BC.phe \
    --pheno-name p1

######################
### RUN with plink ###
######################
module load plink

filePath="/nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS/HLAassoc/example"
# unzip the vcf to run plink
vcfFileName="IMPUTED.1958BC.bgl.phased.vcf"

plink --vcf $filePath/${vcfFileName} --logistic --pheno $filePath/1958BC.phe --out testfilename --allow-no-sex --double-id
