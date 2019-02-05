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
# Input:
# Output:
# Dependencies:
#
# ToDo: Figure out how to make these data insights usable
# Notes: Not clear how to proceed with this data in a helpful manner, so script has been cut simply to
# show the data import process

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

#### Loading .tsv into a table: ####
awesomeTable <- read.table(file = 'data/awesome-all.tsv', sep = '\t',
                           header = TRUE, stringsAsFactors = FALSE) # takes a good minute

#### Pare down data to example gene set ####
exampleGenes <- c("AMBRA1", "ATG14", "ATP2A1", "ATP2A2", "ATP2A3", "BECN1", "BECN2",
                  "BIRC6", "BLOC1S1", "BLOC1S2", "BORCS5", "BORCS6", "BORCS7",
                  "BORCS8", "CACNA1A", "CALCOCO2", "CTTN", "DCTN1", "EPG5", "GABARAP",
                  "GABARAPL1", "GABARAPL2", "HDAC6", "HSPB8", "INPP5E", "IRGM",
                  "KXD1", "LAMP1", "LAMP2", "LAMP3", "LAMP5", "MAP1LC3A", "MAP1LC3B",
                  "MAP1LC3C", "MGRN1", "MYO1C", "MYO6", "NAPA", "NSF", "OPTN",
                  "OSBPL1A", "PI4K2A", "PIK3C3", "PLEKHM1", "PSEN1", "RAB20", "RAB21",
                  "RAB29", "RAB34", "RAB39A", "RAB7A", "RAB7B", "RPTOR", "RUBCN",
                  "RUBCNL", "SNAP29", "SNAP47", "SNAPIN", "SPG11", "STX17", "STX6",
                  "SYT7", "TARDBP", "TFEB", "TGM2", "TIFA", "TMEM175", "TOM1",
                  "TPCN1", "TPCN2", "TPPP", "TXNIP", "UVRAG", "VAMP3", "VAMP7",
                  "VAMP8", "VAPA", "VPS11", "VPS16", "VPS18", "VPS33A", "VPS39",
                  "VPS41", "VTI1B", "YKT6")

awesomeExampleGenes <- awesomeTable[c(awesomeTable$Gene.Symbol %in% exampleGenes),]
length(awesomeExampleGenes$rsID) # 4709

## How many of our genes did we match to?
length(unique(awesomeExampleGenes$Gene.Symbol)) # 73, 85.9% coverage of our example gene set
