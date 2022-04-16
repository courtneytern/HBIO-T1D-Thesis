# module load gcc/7.1.0  openmpi/3.1.4  R
# R 

library(ggplot2)
# hla_alleles_imputed <- read.table("/m/CPHG/T1DGC/USERS/cat7ep/project/snp2hla_hla_intron_exon.txt", sep = "", header = F)

######################
## FILTERING/SETUP ### 
######################
# Outputs a summary table with the number of each type of gene imputed
filterSteps<- function(info.file.path){ 
  T1DGC_6 <- read.table(info.file.path, sep = "", header = T)
  length(T1DGC_6[[1]])
  # 55615 lines (minus header) before filtering
  
  #Generate list of SNPs that are filtered out 
  SNPs_filteredOut<- T1DGC_6[(T1DGC_6['Rsq']<0.5)|(T1DGC_6['MAF']<0.005),]$SNP
  #length(SNPs_filteredOut)
  SNPs_HLA<- SNPs_filteredOut[grep("HLA",SNPs_filteredOut)] # hla alleles
  SNPs_rsSNPs<- SNPs_filteredOut[grep("rs",SNPs_filteredOut)] # rs snp ID 
  SNPs_SNPS<- SNPs_filteredOut[grep("SNPS",SNPs_filteredOut)] #snps marked as SNPS_DB...
  SNPs_AA<- SNPs_filteredOut[grep("AA",SNPs_filteredOut)] # amino acids
  filtered_out<- data.frame(out_HLA=length(SNPs_HLA),
                            out_SNPs= length(SNPs_rsSNPs)+length(SNPs_SNPS),
                            out_AA=length(SNPs_AA),
                            out_total=length(SNPs_HLA)+length(SNPs_rsSNPs)+length(SNPs_SNPS)+length(SNPs_AA)
  )
  print(filtered_out)
  
  # Do the filtering 
  T1DGC_6_filtered <- T1DGC_6[(T1DGC_6['Rsq']>0.5)&(T1DGC_6['MAF']>0.005),]
  length(T1DGC_6_filtered[[1]])
  # 53673 lines (minus header) after filtering
  
  SNPs_kept<- T1DGC_6_filtered$SNP
  SNPs_HLA<- SNPs_kept[grep("HLA",SNPs_kept)] # hla alleles
  SNPs_rsSNPs<- SNPs_kept[grep("rs",SNPs_kept)] # rs snp ID 
  SNPs_SNPS<- SNPs_kept[grep("SNPS",SNPs_kept)] #snps marked as SNPS_DB...
  SNPs_AA<- SNPs_kept[grep("AA",SNPs_kept)] # amino acids

  # summary table of # snps kept in each category
  filtered_summary<- data.frame(HLA=length(SNPs_HLA),
                                SNPs= length(SNPs_rsSNPs)+length(SNPs_SNPS),
                                AA=length(SNPs_AA),
                                total=length(SNPs_HLA)+length(SNPs_rsSNPs)+length(SNPs_SNPS)+length(SNPs_AA)
                                )
  filtered_summary
}

#### 1KG panel
filterSteps("./data/1KG_imputed_032321/chr6.info")
# HLA  SNPs Indels   AA
# 387 67106    116 1027

#### Multiethnic panel
filterSteps("./data/multiethnic_imputed/chr_6/chr6.info")
# HLA  SNPs Indels   AA
# 924 49116    162 3473

## Get the list of low Rsq values from multiethnic panel
multi_info_path<- "/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/chr6.info"
multi_info <- fread(multi_info_path, sep = "\t", header = T)
SNPs_filteredOut<- multi_info[which((multi_info['Rsq']<0.5)|(multi_info['MAF']<0.005)),]$SNP
write.table(SNPs_filteredOut,"/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/filteredOutSNPs.txt",
            quote=F,row.names=F,col.names=F)

####################
## Summary tables ##
####################
# set wd to /nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6
prefilter<- fread("chr6.info")
filtered<- fread("filtered032722.map")
  colnames(filtered)<- c("CHR","SNP","V3","V4")
excluded<- fread("filteredOutSNPs.txt")
  colnames(excluded)<- c("SNP")

table3<- function(dat){
  HLA<- dat[grepl("HLA",dat$SNP)]
  AA<- dat[grepl("AA",dat$SNP)]
  SNP<- dat[(grepl("SNP",dat$SNP)) | (grepl("rs",dat$SNP))]
  data.table( HLA=length(HLA[[1]]),AA=length(AA[[1]]),SNP=length(SNP[[1]]),
              sum=length(HLA[[1]])+length(AA[[1]])+length(SNP[[1]]),
              total=length(dat[[1]])
            )
}
table3(prefilter)
table3(filtered)
table3(excluded)

#################
## MAKE PLOTS ###
#################
multi<- fread("./data/multiethnic_imputed/chr_6/chr6.info")
oneKG<- fread("./data/1KG_imputed_032321/chr6.info")

# Scatter plot of MAF vs Rsq (chromosome 6 T1DGC)
# do for pdf and jpg
# jpeg(file="/m/CPHG/T1DGC/USERS/cat7ep/r2mafQC.jpg")
#jpeg(file="./project/figures/040122_1KG_IMPUTED_r2mafQC.jpg")
ggplot( oneKG , aes(x = Rsq, y = MAF)) + 
  geom_point(size = 1.5, color = "black") +
  geom_vline(xintercept=0.3, color="red") + geom_hline(yintercept=0.005, color="red") +
  labs(x = "Rsq", y = "Allele Frequency") +
  ggtitle("Imputed on 1KG Reference Panel") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
#dev.off()

#jpeg(file="/nv/vol185/T1DGC/USERS/cat7ep/project/figures/040122_1KG_IMPUTED_r2mafQC_filtered.jpg")
ggplot( oneKG[((Rsq>0.5)&(MAF>0.005)),] , aes(x = Rsq, y = MAF)) + 
  geom_point(size = 1.5, color = "black") +
  labs(x = "Rsq", y = "Allele Frequency") +
  ggtitle("Imputed on 1KG Reference Panel (Filtered)") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
#dev.off()

# jpeg(file="/m/CPHG/T1DGC/USERS/cat7ep/project/r2mafQC_hla_alleles.jpg")
# ggplot( hla_alleles_imputed , aes(x = Rsq, y = MAF)) + 
#   geom_point(size = 1.5, color = "blue", fill="blue") +
#   labs(x = "Rsq", y = "MAF") +
#   ggtitle("Chromosome 6 (T1DGC) Filtered") +
#   theme_minimal()+
#   theme(plot.title = element_text(hjust = 0.5))
# dev.off()

###############
## ANALYSIS ###
###############
# get the most associated in each of AFR and AMR only
## Multiethnic 
setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6")
AFR_logistic<- read.csv("./AFR_only.assoc.logistic.csv")
AMR_logistic<- read.csv("./AMR_only.assoc.logistic.csv")
## 1KG
setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/1KG_imputed_032321")
AFR_1KG_logistic<- read.csv("./1KG.AFR_only.assoc.logistic.csv")
AMR_1KG_logistic<- read.csv("./1KG.AMR_only.assoc.logistic.csv")

#multiethnic
multi_info<- "/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6/chr6.info"
topAssoc(multi_info,AFR_logistic,AMR_logistic)
#1KG
oneKG_info<- "/nv/vol185/T1DGC/USERS/cat7ep/data/1KG_imputed_032321/chr6.info"
topAssoc(oneKG_info,AFR_1KG_logistic,AMR_1KG_logistic)


topAssoc<- function(info.file.path,AFR_logistic,AMR_logistic){
  T1DGC_6 <- read.table(info.file.path, sep = "", header = T)
  SNPs_filteredOut<- T1DGC_6[which(T1DGC_6['Rsq']<0.3),]$SNP

  ##Filter out Rsq<0.3
  filtered_AFR<- AFR_logistic[!is.element(AFR_logistic$SNP,SNPs_filteredOut),]
  filtered_AMR<- AMR_logistic[!is.element(AMR_logistic$SNP,SNPs_filteredOut),]

  #### TREAT AFR FIRST 
  AFR_SNPs<- filtered_AFR$SNP
  ## hla alleles
  AFR_HLA<- filtered_AFR[grep("HLA",AFR_SNPs),] 
  top_AFR_HLA<- head(AFR_HLA[order(AFR_HLA$P),]) # top associated 
  print("*****Top AFR HLA*****")
  print(top_AFR_HLA)
  ## rs snp ID and snps marked as SNPS_DB...
  AFR_rsSNPs<- filtered_AFR[grep("rs",AFR_SNPs),] 
  AFR_gene<- filtered_AFR[grep("^SNPS",AFR_SNPs),] 
   # combine all genes into one data frame
   AFR_AllGenes<- rbind(AFR_rsSNPs,AFR_gene)
   top_AFR_SNPs<- head(AFR_AllGenes[order(AFR_AllGenes$P),])# top associated 
  print("*****Top AFR SNPs*****")
  print(top_AFR_SNPs)
  ## amino acids
  AFR_AA<- filtered_AFR[grep("AA",AFR_SNPs),]
  top_AFR_AA<- head(AFR_AA[order(AFR_AA$P),]) # top associated
  print("*****Top AFR AA*****")
  print(top_AFR_AA)
  ##snps marked as INDEL 
  AFR_indel<- filtered_AFR[grep("INDEL",AFR_SNPs),]
  top_AFR_indel<- head(AFR_indel[order(AFR_indel$P),]) # top associated
  print("*****Top AFR Indels*****")
  print(top_AFR_indel)

  #### TREAT AMR
  AMR_SNPs<- filtered_AMR$SNP
  ## hla alleles
  AMR_HLA<- filtered_AMR[grep("HLA",AMR_SNPs),] 
  top_AMR_HLA<- head(AMR_HLA[order(AMR_HLA$P),]) # top associated 
  print("*****Top AMR HLA*****")
  print(top_AMR_HLA)
  ## rs snp ID and snps marked as SNPS_DB...
  AMR_rsSNPs<- filtered_AMR[grep("rs",AMR_SNPs),] 
  AMR_gene<- filtered_AMR[grep("^SNPS",AMR_SNPs),] 
    # combine all genes into one data frame
    AMR_AllGenes<- rbind(AMR_rsSNPs,AMR_gene)
    top_AMR_SNPs<- head(AMR_AllGenes[order(AMR_AllGenes$P),])# top associated 
  print("*****Top AMR SNPs*****")
  print(top_AMR_SNPs)
  ## amino acids
  AMR_AA<- filtered_AMR[grep("AA",AMR_SNPs),]
  top_AMR_AA<- head(AMR_AA[order(AMR_AA$P),]) # top associated
  print("*****Top AMR AA*****")
  print(top_AMR_AA)
  ##snps marked as INDEL 
  AMR_indel<- filtered_AMR[grep("INDEL",AMR_SNPs),]
  top_AMR_indel<- head(AMR_indel[order(AMR_indel$P),]) # top associated
  print("*****Top AMR Indels*****")
  print(top_AMR_indel)
}


