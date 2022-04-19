#!/bin/sh

module load  gcc/7.1.0  openmpi/3.1.4 R/3.6.3
module load anaconda

pop="EUR"
inDir="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/logistic_reg"
outDir="/nv/vol185/T1DGC/USERS/cat7ep/project/figures"
stem="logistic_${pop}_040522"

cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

# build is hg37 but that's not an option, so use hg 19
python -m HLAManhattan \
    --assoc-result ${inDir}/${stem}.assoc.logistic \
    --hg 19 \
    --out ${outDir}/logistic_${pop}_040522.Manhattan
