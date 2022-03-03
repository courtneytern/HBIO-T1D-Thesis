## This script will check which variants are in the imputed file 
## but not in the reference BIM files

#module load  gcc/7.1.0  openmpi/3.1.4 R/3.6.3


library(data.table)

imputedInfoFile<- fread("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/chr6.info",
                        header=T,select=1)[[1]]
referenceBimFile<- fread("/nv/vol185/T1DGC/USERS/cat7ep/data/multi.REFERENCE.4digit.bim",
                         header=F,select=2)[[1]]
not_in_ref<- setdiff(imputedInfoFile,referenceBimFile)
fwrite(list(not_in_ref),"/nv/vol185/T1DGC/USERS/cat7ep/data/not_in_ref_4DIGIT.txt",quote=F)