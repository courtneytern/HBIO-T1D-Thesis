## Read in .fam file and count # male female 

# module load gcc/7.1.0  openmpi/3.1.4  R
# R 

#################
## find first and last HLA position in the data that was uploaded to the imputation server

setwd("/nv/vol185/T1DGC/USERS/cat7ep/data/multiethnic_imputed/chr_6")
vcf.file<- read.table("chr6.dose.vcf") # this is pretty slow in R. do it in awk later if you need to do it again
# CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT
positions<- vcf.file$V2
min(positions)
#[1] 28000361
max(positions)
#[1] 33966845
## look up on genome browser chr6:28000361 / chr6:33966845

#get rs id
vcf.file[positions==min(positions),]$V3

#################
## Count male/female and case/control in AFR and AMR 

setwd("/nv/vol185/T1DGC/USERS/cat7ep/data")
famFileAFR<- read.table("T1DGC_HCE_cc_AFR-2021-01-20.fam")
famFileAMR<- read.table("T1DGC_HCE_cc_AMR-2021-01-20.fam")

countSex<- function(famFile){
  male<- length(famFile$V5[famFile$V5==1]) 
  female<- length(famFile$V5[famFile$V5==2]) 
  data.frame(male=male,female=female)
}
countSex(famFileAFR)
countSex(famFileAMR)

countCaseControl<- function(famFile){
  control<- length(famFile$V5[famFile$V6==1]) 
  case<- length(famFile$V5[famFile$V6==2]) 
  data.frame(control=control,case=case)
}
countCaseControl(famFileAFR)
countCaseControl(famFileAMR)