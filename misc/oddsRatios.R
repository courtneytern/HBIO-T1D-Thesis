library(finalfit)
library(dplyr)
library(ggplot2)
library(data.table)

setwd("/Users/ctern/Downloads/Onengut")
#Supplemental Table 6 from Robertson et al; removed rows with NA in cols of interest 
snpsData<- read.csv("robertson_ST6.csv",header=TRUE)

# OR plot
# Set labels to the gene abbreviation
boxLabels<- snpsData$gene
id<- snpsData$ID
popList<- c("European","African","Finnish","Hispanic")

#### calculate odds ratios and confidence intervals
# first, get relevant columns from whole data table
effectEUR<- snpsData$Effect_EUR #european
seEUR<- snpsData$SE_EUR
effectAFR<- snpsData$Effect_AFR #african
seAFR<- snpsData$SE_AFR
effectFIN<- snpsData$Effect_FIN #finnish
seFIN<- snpsData$SE_FIN
effectAMR<- snpsData$Effect_AMR #hispanic
seAMR<- snpsData$SE_AMR

odds<- data.frame()
ciHigh<- data.frame()
ciLow<- data.frame()
for(i in 1:length(effectEUR)) { 
  biEUR<- effectEUR[i] #bi stores effect size per lead SNP
  seBiEUR<- seEUR[i] #standard error of the SNP
  biAFR<- effectAFR[i] 
  seBiAFR<- seAFR[i]
  biFIN<- effectFIN[i] 
  seBiFIN<- seFIN[i]
  biAMR<- effectAMR[i] 
  seBiAMR<- seAMR[i]
  
  #Calculate odds ratio with exp of effect size
  #European in first row 
  odds[1,i]<- exp(biEUR) #one row per snp; each column different pop
  ciHigh[1,i]<- exp( biEUR +1.96*seBiEUR ) 
  ciLow[1,i]<- exp(biEUR -1.96*seBiEUR ) 
  
  #African second row
  odds[2,i]<- exp(biAFR)
  ciHigh[2,i]<- exp( biAFR +1.96*seBiAFR ) 
  ciLow[2,i]<- exp(biAFR -1.96*seBiAFR )
  
  #Finnish third row
  odds[3,i]<- exp(biFIN) 
  ciHigh[3,i]<- exp( biFIN +1.96*seBiFIN ) 
  ciLow[3,i]<- exp(biFIN -1.96*seBiFIN )
  
  #Hispanic fourth row
  odds[4,i]<- exp(biAMR) 
  ciHigh[4,i]<- exp( biAMR +1.96*seBiAMR ) 
  ciLow[4,i]<- exp(biAMR -1.96*seBiAMR )
}

#giving meaningful row and column names
colnames(odds)<-boxLabels
rownames(odds)<-popList
colnames(ciHigh)<-boxLabels
rownames(ciHigh)<-popList
colnames(ciLow)<-boxLabels
rownames(ciLow)<-popList

#following code from https://www.jscarlton.net/post/2015-10-24visualizinglogistic/
yAxis<- length(popList):1 #number of pops 
df <- data.frame( yAxis = length(popList):1, boxOdds = odds, boxCILow = ciLow, boxCIHigh = ciHigh)

#Make one plot per SNP
pdf(file="~/Downloads/Onengut/ORPlots.pdf")
  for(i in 1:length(boxLabels) ) {
    p <- ggplot(df, aes(x = unlist(odds[i]), y = yAxis))
    p<- p + geom_vline(aes(xintercept = 1), size = .25, linetype = "dashed") +
    geom_errorbarh(aes(xmax = unlist(ciHigh[i]), xmin = unlist(ciLow[i])), size = .5, height = .2, color = "gray50") +
    geom_point(size = 3.5, color = "orange") +
    theme_bw() +
    theme(panel.grid.minor = element_blank()) +
    scale_y_continuous(breaks = yAxis, labels = popList) +
    scale_x_log10() +
    ylab("") +
    xlab("Odds ratio (log scale)") +
    ggtitle( paste("Odds Ratio",boxLabels[i],id[i], "i=",i) ) 
    
    print(p)
  }
dev.off()

#Associated SNPs:
##after adding Hispanic data, 44 is the only one that remains assoc in all 4 pops
##removed CTLA4, IKZF4, IL27, UBASH3A based on recommendations 
assoc.SNP.ids<- c(25,34,38,44) #35 is also associated, but that's insulin
pdf(file="~/Downloads/Onengut/assoc_ORPlots.pdf")
for(j in assoc.SNP.ids ) {
  p <- ggplot(df, aes(x = unlist(odds[j]), y = yAxis))
  p<- p + geom_vline(aes(xintercept = 1), size = .25, linetype = "dashed") +
    geom_errorbarh(aes(xmax = unlist(ciHigh[j]), xmin = unlist(ciLow[j])), size = .5, height = .2, color = "gray50") +
    geom_point(size = 3.5, color = "deepskyblue") +
    theme_bw() +
    theme(panel.grid.minor = element_blank()) +
    scale_y_continuous(breaks = yAxis, labels = popList) +
    scale_x_log10() +
    ylab("") +
    xlab("Odds ratio (log scale)") +
    ggtitle( paste("Odds Ratio",boxLabels[j],id[j], "i=",j) ) 
  
  print(p)
}
dev.off()

snpsData$ID[assoc.SNP.ids]
snpsData$gene[assoc.SNP.ids]

