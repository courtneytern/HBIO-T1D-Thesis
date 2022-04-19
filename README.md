# HBIO-T1D-Thesis
This repository contains the code used in Courtney Tern's thesis for the Distinguished Majors Program in Human Biology 2022. This code takes imputed data and conducts quality control and association tests.
<br>

### QC/Analysis Pipeline

1. filtering_R2vsMAF.R
   1. Counts number of each type of imputed variant
   2. Generates data for table 3
   3. Filters by Rsq and MAF and returns the SNPs that should be filtered out
   4. Plots the Rsq vs MAF for 1KG and multiethnic reference panel
2. filterVCF_makeBinary.sh
3. updateFamIDs.sh
4. make_freq.sh
5. run_HLAOmnibus.sh
6. stepwise_analysis_HLA.sh and stepwise_analysis_AA.sh
   1. Runs stepwise conditional logistic regression analysis.
   2. Run _HLA and _AA separately. Both are run in conjunction with getLead_stepwise.R
   3. "Pull summary stats" code segment: run after there are no more significant variants
7. getLead_stepwise.R
8. run_HLAManhattan.sh
   1. Make Manhattan plot on logistic regression (step 0)

### Make Plots
* plot_PCs.R
  - Makes scatter plot matrix comparing all pairwsie combinations of PCs
  - Use to verify that none of the PCs are case-control status or sex
* plot_allPops_MAFstepwise.R
  - Makes bar chart of MAF in each population for all significantly associated variants from the conditional stepwise analysis

#### /descriptiveStats
* count_imputed_phenos.R
  - Get first and last imputed genetic position
  - Counts sex (M/F) and case/control status from .fam file
* MAF_summary.R
  - Requires .frq file
  - Generates data for Table 4
* makeTable_HLA_MAF.R
  - Requires .frq.cc file
  - Makes supplemental table with HLA and AA allele frequencies by case and control for all populations

#### /misc
* generatePCs.sh
  - generate PCs using PLINK. Not used in the final version of this study in favor of MDS projections
* top_assoc_AFRAMR.R
  - Finds the top associated HLA alleles and amino acids in each population for omnnibus association
  - **no longer needed for this study
