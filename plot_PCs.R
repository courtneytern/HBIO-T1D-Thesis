# Plot scatterplot for all combinations of PCs

# module load gcc/7.1.0  openmpi/3.1.4  R
# R

library(lattice)
library(data.table)

##########
## AFR ###
##########
AFR<- fread("./data/tmp_10_AFR_mdspc.txt") # PCs from Dominika 
AFR_5<- AFR[,c(1,2,5:11)] # keep only first 5 PCs 
#color by sex (male=1, female=2)
AFRPlot<- splom(AFR_5[,5:9], groups=AFR_5$SEX, auto.key=list(space="right",text=c("Male","Female")),
                main="AFR PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
                )
# color by Case-Control
AFRPlot2<- splom(AFR_5[,5:9], groups=AFR_5$AFF, auto.key=list(space="right",text=c("Control","Case")),
                main="AFR PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
                )

##########
## AMR ###
##########
AMR<- fread("./data/tmp_10_AMR_mdspc.txt") # PCs from Dominika
AMR_5<- AMR[,c(1,2,5:11)] # keep only first 5 PCs 
# color by sex
AMRPlot<- splom(AMR_5[,5:9], groups=AMR_5$SEX, auto.key=list(space="right",text=c("Male","Female")), 
                main="AMR PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
                )
# color by Case-Control
AMRPlot2<- splom(AMR_5[,5:9], groups=AMR_5$AFF, auto.key=list(space="right",text=c("Control","Case")), 
                main="AMR PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
                )

##########
## EUR ###
##########
EUR<- fread("./data/tmp_10_EUR_mdspc.txt") 
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
# EUR_pc1_2_sex<- ggplot(EUR[,5:16],aes(x=EUR$PC1,y=EUR$PC2,col=as.factor(EUR$SEX))) + geom_point()
EUR_pc1_2_cc<- ggplot(EUR[,5:16],aes(x=EUR$PC1,y=EUR$PC2,col=as.factor(EUR$AFF))) + geom_point()

##########
## 1KG ###
##########
pcs1kg<- fread("./data/tmp_13_T1DGC_HCE_AFR_AMR_EURpc.txt") 
pcs1kg_5<- pcs1kg[,c(1,2,5:11)]
pcs1kg_sex<- splom(pcs1kg[,7:11], groups=pcs1kg_5$SEX, auto.key=list(space="right",text=c("Male","Female")), 
                main="1KG PC Associations by Sex", xlab="PCs 1-5",ylab="PCs 1-5",
                par.settings = list(superpose.symbol = list(col = c("darkorange", "darkblue"))) 
)
pcs1kg_cc<- splom(pcs1kg[,7:11], groups=pcs1kg_5$AFF, auto.key=list(space="right",text=c("Control","Case")), 
               main="1KG PC Associations by Case-Control", xlab="PCs 1-5",ylab="PCs 1-5",
               par.settings = list(superpose.symbol = list(col = c("deeppink3", "darkgray"))) 
)

pcs1kg_pc1_2_cc<- ggplot(pcs1kg[,5:16],aes(x=pcs1kg$PC4,y=pcs1kg$PC5,col=as.factor(pcs1kg$AFF))) + geom_point()

