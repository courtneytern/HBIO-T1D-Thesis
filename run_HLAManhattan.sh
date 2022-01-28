#!/bin/sh

module load  gcc/7.1.0  openmpi/3.1.4
module load R/3.6.3
module load python/3.6.8
module load anaconda

inDir="/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6"
outDir="/nv/vol185/T1DGC/USERS/cat7ep/project/figures"
stem="multiethnic.AMR_only.v4"
## stems: multiethnic.AMR_only.v4; multiethnic.AFR_only.v4

cd /nv/vol185/T1DGC/USERS/cat7ep/HLA-TAPAS

# build is Hg37 but that's not an option, so go with Hg 19
python -m HLAManhattan \
    --assoc-result ${inDir}/${stem}.assoc.logistic \
    --hg 19 \
    --out ${outDir}/${stem}.Manhattan

## scp pdf files to see them
scp cat7ep@rivanna.hpc.virginia.edu:/nv/vol185/T1DGC/USERS/cat7ep/project/figures/multiethnic*.pdf ~/Downloads
