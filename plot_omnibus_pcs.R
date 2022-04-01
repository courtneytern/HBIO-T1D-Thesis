# Plot scatterplot for all combinations of PCs
# for AFR and AMR omnibus data

# module load gcc/7.1.0  openmpi/3.1.4  R
# R

library(lattice)
library(data.table)

# setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/omnibus")
# setwd("~/Downloads")
# read in pheno file with sex and case-control info
pheno<- fread("./data/T1DGC_HCE-2021-10-07_CT.phe")
pheno<- pheno[,c(2:4)] # drop duplicate
## COLOR CODE BY CASE-CONTROL AND SEX
AFR<- fread("./data/multiethnic_imputed/chr_6/omnibus/T1DGC_HCE_AFR.OMNIBUS.pcs")
  AFR$IID<- as.character(AFR$IID)
withSexAFR<- merge(AFR,pheno,by.x=c("IID"),by.y=c("IID"),all.x=T)
withSexAFR<- withSexAFR[,c(1:7,13,14)] # keep only first 5 PCs 
#color by sex (male=1, female=2)
AFRPlot<- splom(withSexAFR[,3:7], groups=withSexAFR$p1, auto.key=list(space="right",text=c("Male","Female")),
                main="AFR Omnibus PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
                )
# color by Case-Control
AFRPlot2<- splom(withSexAFR[,3:7], groups=withSexAFR$p2, auto.key=list(space="right",text=c("Control","Case")),
                main="AFR Omnibus PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
                )

AMR<- fread("./data/multiethnic_imputed/chr_6/omnibus/T1DGC_HCE_AMR.OMNIBUS.pcs")
  AMR$IID<- as.character(AMR$IID)
withSexAMR<- merge(AMR,pheno,by.x=c("IID"),by.y=c("IID"),all.x=T)
withSexAMR<- withSexAMR[,c(1:7,13,14)] # keep only first 5 PCs 
# color by sex
AMRPlot<- splom(withSexAMR[,3:7], groups=withSexAMR$p1, auto.key=list(space="right",text=c("Male","Female")), 
                main="AMR Omnibus PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
                )
# color by Case-Control
AMRPlot2<- splom(withSexAMR[,3:7], groups=withSexAMR$p2, auto.key=list(space="right",text=c("Control","Case")), 
                main="AMR Omnibus PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
                )

EUR<- fread("./data/T1DGC_HCE_pc_EUR.txt")
EUR_5<- EUR[,c(1,2,5:11)]
EUR_sex<- splom(EUR[,7:11], groups=EUR_5$SEX, auto.key=list(space="right",text=c("Male","Female")), 
               main="EUR PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
               par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
)
EUR_cc<- splom(EUR[,7:11], groups=EUR_5$AFF, auto.key=list(space="right",text=c("Control","Case")), 
                 main="EUR PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
                 par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
)

# just pcs 1 and 2
EUR_pc1_2_sex<- ggplot(EUR[,7:8],aes(x=EUR$PC1,y=EUR$PC2,col=as.factor(EUR$SEX))) + geom_point()
EUR_pc1_2_cc<- ggplot(EUR[,7:8],aes(x=EUR$PC1,y=EUR$PC2,col=as.factor(EUR$AFF))) + geom_point()


pdf("/nv/vol185/T1DGC/USERS/cat7ep/project/figures/omnibusPlots_AFR_AMR_bysex.pdf")
  AFRPlot
  AMRPlot
dev.off()

pdf("/nv/vol185/T1DGC/USERS/cat7ep/project/figures/omnibusPlots_AFR_AMR_byCC.pdf")
  AFRPlot2
  AMRPlot2
dev.off()