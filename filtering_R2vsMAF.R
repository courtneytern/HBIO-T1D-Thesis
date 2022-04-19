# module load gcc/7.1.0  openmpi/3.1.4  R
# R 

## This script will read in the .info file generated from the Michigan Imputation Server
## Output: 
### Summary table of imputed variants, before and after filtration steps
### information for thesis Table 3 
### Comparison plots of 1KG and multi refs (thesis Figure 4)

library(ggplot2)

######################
## FILTERING/SETUP ### 
######################
# Outputs a summary table with the number of each type of variants imputed
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

#### 1KG reference
filterSteps("./data/1KG_imputed_032321/chr6.info")
# HLA  SNPs Indels   AA
# 387 67106    116 1027

#### Multiethnic reference
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
# Scatter plot of MAF vs Rsq
## save plots from R Studio window

## change data table to multi or oneKG as needed 
multi<- fread("./data/multiethnic_imputed/chr_6/chr6.info")
oneKG<- fread("./data/1KG_imputed_032321/chr6.info")

# pre-filtered
ggplot( oneKG , aes(x = Rsq, y = MAF)) + 
  geom_point(size = 1.5, color = "black") +
  geom_vline(xintercept=0.3, color="red") + geom_hline(yintercept=0.005, color="red") +
  labs(x = "Rsq", y = "Allele Frequency") +
  ggtitle("Imputed on 1KG Reference Panel") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

# filtered
ggplot( oneKG[((Rsq>0.5)&(MAF>0.005)),] , aes(x = Rsq, y = MAF)) + 
  geom_point(size = 1.5, color = "black") +
  labs(x = "Rsq", y = "Allele Frequency") +
  ggtitle("Imputed on 1KG Reference Panel (Filtered)") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

