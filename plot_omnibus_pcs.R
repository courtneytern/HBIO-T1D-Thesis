# Plot scatterplot for all combinations of PCs
# for AFR and AMR omnibus data

# module load gcc/7.1.0  openmpi/3.1.4  R
# R

library(lattice)
library(data.table)

setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus")
# setwd("~/Downloads")
## COLOR CODE BY CASE-CONTROL AND SEX
AFR<- fread("./T1DGC_HCE_AFR.OMNIBUS.pcs")
  AFR$FID<- as.character(AFR$FID)
AFR_sex<- fread("./T1DGC_HCE_AFR.OMNIBUS.sex")
withSexAFR<- merge(AFR,AFR_sex,by.x=c("FID","IID"),by.y=c("V1","V2"),all.x=T)
# color by sex
AFRPlot<- splom(withSexAFR[,3:12], groups=withSexAMR$V3, auto.key=list(space="right"),
                main="AFR Omnibus PC Associations By Sex", xlab="PCs 1-10",ylab="PCs 1-10")

AMR<- fread("./T1DGC_HCE_AMR.OMNIBUS.pcs")
  AMR$FID<- as.character(AMR$FID)
AMR_sex<- fread("./T1DGC_HCE_AMR.OMNIBUS.sex")
withSexAMR<- merge(AMR,AMR_sex,by.x=c("FID","IID"),by.y=c("V1","V2"),all.x=T)
# color by sex
AMRPlot<- splom(withSexAMR[,3:12], groups=withSexAMR$V3, auto.key=list(space="right"), 
                main="AMR Omnibus PC Associations By Sex", xlab="PCs 1-10",ylab="PCs 1-10")

pdf("/nv/vol185/T1DGC/USERS/cat7ep/project/figures/omnibusPlots_AFR_AMR_bysex.pdf")
  AFRPlot
  AMRPlot
dev.off()
