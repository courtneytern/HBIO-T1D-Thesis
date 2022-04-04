# HBIO-T1D-Thesis
This repository contains the code used in Courtney Tern's thesis for the Distinguished Majors Program in Human Biology 2022. This code takes imputed data and conducts quality control and association tests.
<br>

### QC/Analysis Pipeline 

1. filterVCF_makeBinary.sh
2. updateFamIDs.sh
2. generatePCs.sh
3. filtering_R2vsMAF.R
4. make_freq.sh
5. run_HLAOmnibus.sh
6. run_HLAManhattan.sh
7. stepwise_analysis.sh and stepwise_analysis_AA.sh
8. findTop_stepwise.R

### Make Plots
* plot_PCs.R
  - Makes scatter plot matrix comparing all PCs against each other
* plot_allPops_MAFstepwise.R
  - Makes bar chart of MAF in each population for all significantly associated variants from the stepwise analysis

#### /descriptiveStats
* count_imputed_phenos.R
  - Counts sex (M/F) and case/control status from .fam file
* MAF_summary.R
  - Requires .frq file
* makeTable_HLA_MAF.R
  - Requires .frq file
* top_assoc_AFRAMR.R
  - Finds the top associated HLA alleles and amino acids in each population
