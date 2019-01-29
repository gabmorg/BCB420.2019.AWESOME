# AWESOME-Data-Cleaning.R
#
# Purpose:  AWESOME Dataset:
#              R code for importing and cleaning the AWESOME tsv data
#
# Version:   0.1
#
# Date:     2019  01 29 - 2019 01 XX
# Author:   Gabriela Morgenshtern (g.morgenshtern@mail.utoronto.ca)
#
# Versions:
#           1.0    XXX
#           0.1    First code importing AWESOME data
#

# =    1  Setup and data  ======================================================


# We'll probably need iGraph to create visualizations at some point:

if (!require(igraph, quietly=TRUE)) {
  install.packages("igraph")
  library(igraph)
}
# Package information:
#  library(help = igraph)       # basic information
#  browseVignettes("igraph")    # available vignettes
#  data(package = "igraph")     # available datasets

# Loading .tsv into a table:
awesomeTable <- read.table(file = 'data/awesome-all.tsv', sep = '\t',
                           header = TRUE, stringsAsFactors = FALSE) # takes a goid minute

# We can't simply take the Gene.Symbol col and make these into rownames because these aren't unique
# We must pare down and unify data in a way that is unique per gene-- how do we aggregate SNP data?
# What does each column mean?

# Column Name       # Ex. Data        # Description
# "rsID"            rs372783720       Unique key for specific SNP
# "Location"        chr1:892534       reference chromosomal (hg19) position of SNP
# "Gene.Symbol"     NOC2L             HGNC gene symbol
# "ENSP"            ENSP00000317992   Ensemble protein ID
# "AA.Change"       S/L               Original/Mutated AA in peptide seq

## PTM Prediction sum columns (based on 20 bioinformatics tools)
## The higher the absolute value, the higher the probability of the transformation:
# "Phos"            3.414             Phosphorylation score
# "Ubi"             0.000             Ubiquination score
# "Meth"            -1.136            Methylation score
# "SUMO"            35.762            Small ubiquitin-like modifiers
# "O.GalNAc"        (-/+)1.240        The higher the absolute value, the higher the probability of the transformation
# "O.GlcNAc"        "                 O-N-acetylglucosamine
# "N.Gly"           "                 N-glycosylation
# "K.Ace"           "                 Lysine acetylation
# "N.t.Ace"         "                 N-terminal acetylatin

# "Exp.Score"       one of {0,1,2,3}  Data from experimental databases (online tool has specific DBs and their exp)

# "Ref"             cAg               Reference DNA base sequence (codon)
# "Alt"             L                 Mutant AA (AWESOME also has the mutant codon you can pull in indiv results)

# Also possible to get the MAF scores of relevant genes on
# independent/batch lookup basis after initial cleanup
# (to differentiate common and rare variants of genes in the population)
