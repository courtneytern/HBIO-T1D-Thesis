# Make a plot to compare all three ancestry groups.
# Generate a bar chart with MAF as the y axis
# and each HLA allele from the conditional analysis as the x axis
library(data.table)
library(ggplot2)

setwd("./data/multiethnic_imputed/chr_6")

AFRfrq<- fread("filtered032722_AFR.frq")
AMRfrq<- fread("filtered032722_AMR.frq")
EURfrq<- fread("filtered032722_EUR.frq")

##########
## HLA ###
##########
HLA<- list("HLA_DRB1*03:01","HLA_DQA1*03:01","HLA_DQB1*06:02","HLA_DQB1*02:01",
           "HLA_DQB1*03:01","HLA_DRB1*07:01","HLA_DQA1*01:03")

dat<- data.table()
for(i in 1:length(HLA)){
  dat<- rbind(dat, data.table(pop="AFR",AFRfrq[which(AFRfrq$SNP==HLA[i]),c("SNP","MAF")]) )
  dat<- rbind(dat, data.table(pop="AMR",AMRfrq[which(AMRfrq$SNP==HLA[i]),c("SNP","MAF")]) )
  dat<- rbind(dat, data.table(pop="EUR",AFRfrq[which(EURfrq$SNP==HLA[i]),c("SNP","MAF")]) )
}
dat

# plot
ggplot(dat,aes(x=SNP,y=MAF,fill=pop)) + geom_bar(stat="identity",position="dodge") +
  scale_fill_manual(values=c("lightskyblue","cornflowerblue","blue4")) +
  theme(axis.text.x=element_text(angle=45,hjust=1)) + 
  xlab("HLA Allele") + ylab("Minor Allele Frequency") +
  labs(title="Minor Allele Frequency by HLA Allele",subtitle="in AFR, AMR, and EUR ancestry groups")

#########
## AA ###
#########
setwd("/data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/")
AFRtop<- fread("./AFR_top_stats.txt",header=F)
AMRtop<- fread("./AMR_top_stats.txt",header=F)
AFRtop2<- fread("./generatedPCs/AFR_top_stats.txt",header=F)
AMRtop2<- fread("./generatedPCs/AMR_top_stats.txt",header=F)
EURtop2<- fread("./generatedPCs/EUR_top_stats.txt",header=F)
AA<- rbind(AFRtop[,"V2"],AMRtop[,"V2"],AFRtop2[,"V2"],AMRtop2[,"V2"],EURtop2[,"V2"])

dat<- data.table()
for(i in 1:length(AA$V2)){
  dat<- rbind(dat, data.table(pop="AFR",AFRfrq[which(AFRfrq$SNP==AA$V2[i]),c("SNP","MAF")]) )
  dat<- rbind(dat, data.table(pop="AMR",AMRfrq[which(AMRfrq$SNP==AA$V2[i]),c("SNP","MAF")]) )
  dat<- rbind(dat, data.table(pop="EUR",AFRfrq[which(EURfrq$SNP==AA$V2[i]),c("SNP","MAF")]) )
}
dat

# plot
ggplot(dat,aes(x=SNP,y=MAF,fill=pop)) + geom_bar(stat="identity",position="dodge") +
  scale_fill_manual(values=c("lightskyblue","cornflowerblue","blue4")) +
  theme(axis.text.x=element_text(angle=70,hjust=1)) + 
  xlab("Amino Acid") + ylab("Minor Allele Frequency") +
  labs(title="Minor Allele Frequency by Amino Acid",subtitle="in AFR, AMR, and EUR ancestry groups")
