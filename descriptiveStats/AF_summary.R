# make summary table of allele types for each of EUR, AFR, AMR

library(data.table)

#set wd to Rivanna folder 
freqAMR<- fread("./data/multiethnic_imputed/chr_6/filtered032722_AMR.frq")
freqAFR<- fread("./data/multiethnic_imputed/chr_6/filtered032722_AFR.frq")
freqEUR<- fread("./data/multiethnic_imputed/chr_6/filtered032722_EUR.frq")

#function to generate summary table, given conditioned freq table
summaryTable<- function(freqTable){
  data.frame(SNP=length(grep("rs|SNPS",freqTable$SNP)),
             AA=length(grep("AA",freqTable$SNP)),
             Gene=length(grep("HLA",freqTable$SNP))
            )
}

AMR_summary<- summaryTable(freqAMR)
AMR_monomorphic<- summaryTable(freqAMR[(MAF==0)|(MAF==1)])
AMR_less001<- summaryTable(freqAMR[(MAF<0.01)&(MAF!=0)])
AMR_001_005<- summaryTable(freqAMR[(MAF>0.01)&(MAF<0.05)])
AMR_over005<- summaryTable(freqAMR[(MAF>0.05)&(MAF!=1)])

AFR_summary<- summaryTable(freqAFR)
AFR_monomorphic<- summaryTable(freqAFR[(MAF==0)|(MAF==1)])
AFR_less001<- summaryTable(freqAFR[(MAF<0.01)&(MAF!=0)])
AFR_001_005<- summaryTable(freqAFR[(MAF>0.01)&(MAF<0.05)])
AFR_over005<- summaryTable(freqAFR[(MAF>0.05)&(MAF!=1)])

EUR_summary<- summaryTable(freqEUR)
EUR_monomorphic<- summaryTable(freqEUR[(MAF==0)|(MAF==1)])
EUR_less001<- summaryTable(freqEUR[(MAF<0.01)&(MAF!=0)])
EUR_001_005<- summaryTable(freqEUR[(MAF>0.01)&(MAF<0.05)])
EUR_over005<- summaryTable(freqEUR[(MAF>0.05)&(MAF!=1)])

