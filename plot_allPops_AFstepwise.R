# Make a plot to compare all three ancestry groups.
# Generate a bar chart. Y axis: allele freq. X axis:each significant variant from the conditional analysis
library(data.table)
library(ggplot2)

setwd("./data/multiethnic_imputed/chr_6")
AFRfrq<- fread("filtered041222_AFR.frq.cc")
AMRfrq<- fread("filtered041222_AMR.frq.cc")
EURfrq<- fread("filtered041222_EUR.frq.cc")

##########
## HLA ###
##########
# list of all significant HLA alleles from conditional analysis 
HLA<- list("HLA_B*39:06","HLA_DPB1*04:02","HLA_DQA1*01:03","HLA_DQA1*03:01",
           "HLA_DQB1*02:01","HLA_DQB1*03:01","HLA_DQB1*03:02","HLA_DQB1*03:03",
           "HLA_DQB1*05:03","HLA_DQB1*06:02",
           "HLA_DRB1*03:01","HLA_DRB1*04:01","HLA_DRB1*07:01"
           )

dat_HLA<- data.table()
for(i in 1:length(HLA)){
  dat_HLA<- rbind(dat_HLA, data.table(pop="AFR",AFRfrq[which(AFRfrq$SNP==HLA[i]),c("SNP","MAF_A","MAF_U")]) )
  dat_HLA<- rbind(dat_HLA, data.table(pop="AMR",AMRfrq[which(AMRfrq$SNP==HLA[i]),c("SNP","MAF_A","MAF_U")]) )
  dat_HLA<- rbind(dat_HLA, data.table(pop="EUR",EURfrq[which(EURfrq$SNP==HLA[i]),c("SNP","MAF_A","MAF_U")]) )
}
dat_HLA

# plot
# case
ggplot(dat_HLA,aes(x=SNP,y=MAF_A,fill=pop)) + geom_col(width=0.6,position="dodge") +
  scale_fill_manual(values=c("lightpink","palevioletred","deeppink4")) +
  theme(axis.text.x=element_text(angle=45,hjust=1)) + 
  xlab("HLA Allele") + ylab("Allele Frequency") +
  labs(title="Allele Frequency by HLA Allele in Cases")
# control
ggplot(dat_HLA,aes(x=SNP,y=MAF_U,fill=pop)) + geom_col(width=0.6,position="dodge") +
  scale_fill_manual(values=c("lightskyblue","cornflowerblue","blue4")) +
  theme(axis.text.x=element_text(angle=45,hjust=1)) + 
  xlab("HLA Allele") + ylab("Allele Frequency") +
  labs(title="Allele Frequency by HLA Allele in Controls")

#########
## AA ###
#########
setwd("./data/multiethnic_imputed/chr_6/logistic_reg/stepwise_AA/")
# make list of all associated amino acids
AFRtop<- fread("./AFR_top_stats.txt",header=F)
AMRtop<- fread("./AMR_top_stats.txt",header=F)
EURtop<- fread("./EUR_top_stats.txt",header=F)
AA<- rbind(AFRtop[,"V2"],AMRtop[,"V2"],EURtop[,"V2"])

dat_AA<- data.table()
for(i in 1:length(AA$V2)){
  dat_AA<- rbind(dat_AA, data.table(pop="AFR",AFRfrq[which(AFRfrq$SNP==AA$V2[i]),c("SNP","MAF_A","MAF_U")]) )
  dat_AA<- rbind(dat_AA, data.table(pop="AMR",AMRfrq[which(AMRfrq$SNP==AA$V2[i]),c("SNP","MAF_A","MAF_U")]) )
  dat_AA<- rbind(dat_AA, data.table(pop="EUR",EURfrq[which(EURfrq$SNP==AA$V2[i]),c("SNP","MAF_A","MAF_U")]) )
}
dat_AA

# plot
# case
ggplot(dat_AA,aes(x=SNP,y=MAF_A,fill=pop)) + geom_col(width=0.6,position="dodge") +
  scale_fill_manual(values=c("lightpink","palevioletred","deeppink4")) +
  theme(axis.text.x=element_text(angle=70,hjust=1)) + 
  xlab("Amino Acid Polymorphism") + ylab("Allele Frequency") +
  labs(title="Allele Frequency by AA Polymorphism in Cases")
# control
ggplot(dat_AA,aes(x=SNP,y=MAF_U,fill=pop)) + geom_col(width=0.6,position="dodge") +
  scale_fill_manual(values=c("lightskyblue","cornflowerblue","blue4")) +
  theme(axis.text.x=element_text(angle=70,hjust=1)) + 
  xlab("Amino Acid Polymorphism") + ylab("Allele Frequency") +
  labs(title="Allele Frequency by AA Polymorphism in Controls")
