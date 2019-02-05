# `BCB420.2019.AWESOME`
#### AWESOME-data attempted annotatation of human gene single-nucleotide polymorphisms

* [Gabriela Morgenshtern](https://orcid.org/0000-0003-4762-8797)
* [g.morgenshtern@mail.utoronto.ca](mailto:g.morgenshtern@mail.utoronto.ca)

## 1 About this package:

This package describes the process to download the single-nucleotide polymorphism data available from the [AWESOME database](http://www.awesome-hust.com/), how to validate the given gene names with the most up-to-date [HGNC](https://www.genenames.org/), how to annotate the example gene set, and provides examples of computing database statistics.

This is both an installable R package and an RStudio project. Package build checks have **passed without errors, warnings, or notes**.
### 1.2 Package layout
``` text
 --BCB420.2019.AWESOME/             # On this level you would also add the /data directory for the all-awesome.tsv file
   |__.gitignore
   |__.Rbuildignore
   |__BCB420.2019.AWESOME.Rproj
   |__DESCRIPTION
   |__dev/
      |__functionTemplate.R
      |__rptTwee.R
      |__toBrowser.R
   |__inst/
      |__extdata/
         |__test_lseq.dat
      |__scripts/
         |__AWESOME-Data-Cleaning.R
         |__scriptTemplate.R
   |__LICENSE
   |__man/
      |__lseq.Rd
   |__NAMESPACE
   |__R/
      |__lseq.R
      |__zzz.R
   |__README.md
   |__tests/
      |__testthat.R
      |__testthat/
         |__helper-functions.R
         |__test_lseq.R
```
## 2 AWESOME Data

### 2.1 Element Descriptions
We can't simply take the Gene.Symbol column and make these into rownames because these aren't unique-- a given gene may be represented
as many times in the database as there are reported SNPs.

We must work to try to understand whether the data can be unified is unique per gene, so that we may learn something about our dataset. But how do we aggregate SNP data?

#### 2.1.1 What does each column mean?
``` R
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
# "O.GalNAc"        (-/+)1.240        The higher the absolute value, the higher the probability 
                                      of the transformation
# "O.GlcNAc"        "                 O-N-acetylglucosamine
# "N.Gly"           "                 N-glycosylation
# "K.Ace"           "                 Lysine acetylation
# "N.t.Ace"         "                 N-terminal acetylatin

# "Exp.Score"       one of {0,1,2,3}  Data from experimental databases 
                                      (online tool has database names and the experiments associated)

# "Ref"             cAg               Reference DNA base sequence (codon)
# "Alt"             L                 Mutant AA (AWESOME also has the mutant codon you can pull in indiv results)
```

## 3 Data download and cleanup

### 3.1 Adding the data to your R project
To download the source data from AWESOME:

1. Navigate to the [**AWESOME** database](http://www.awesome-hust.com/#/) and click on the [download section](http://www.awesome-hust.com/#/download).
2. Download the only available option: **SNP Result Under Default Condition** (16.7MB)
3. Unzip the file and place it into a sister directory of your working directory which is called `data` (It should be reachable with `file.path("..", "data")`). The unzipped file, `../data/awesome-all.tsv`, is 87.1 Mb.

### Including the data in the package
```R

#### Loading .tsv into a table: ####
awesomeTable <- read.table(file = 'data/awesome-all.tsv', sep = '\t',
                           header = TRUE, stringsAsFactors = FALSE) # takes a good minute
```

## 4 Mapping and validating 
### 4.1 Possible Approaches and their Issues
We'd like to be able to map HGNCs to particular rsIDs attributed to them. An rsID is a Reference SNP cluster ID, an identifier used by researchers to label a specific SNP uniquely. An alternative identification system is NCBI's dbSNP, which is the preffered identifier by [Nature journal] (https://www.nature.com/articles/ng.3716). However, aggregating rsIDs or dbSNPs for a given gene in an array of some sort would not be an insightful way to process the AWESOME data, as it would be losing the probability scores attributed to each SNPs affected domains. 

Alternatively, it would be interesting to learn about the functional effects of certain "significant" SNPs, and the probability of acquiring such mutations for a given system. Data that would be helpful for informing this kind of analysis could include probability of acquiring specific SNPs given a specific environment. However, it is not easily evident how such data could be acquired and integrated here today. 

On another note, AWESOME's downloadable dataset includes chromosomal position mappings to GRCh37 (hg19), rather than our preffered GRCh38. Remapping the chromosomal positioning would be quite the computational feat, and given the limited applicability of this package to our current needs, this is not an endeavour the package author deemed reasonable to pursue.

### 4.2 Lookup practice: Checking for presence of given genes
* We use the given example gene data set to look at the type of coverage our database holds
```R
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
```

* How many of our genes did we match to?
``` R
awesomeExampleGenes <- awesomeTable[c(awesomeTable$Gene.Symbol %in% exampleGenes),]
length(awesomeExampleGenes$rsID) # 4709
length(unique(awesomeExampleGenes$Gene.Symbol)) # 73, 85.9% coverage of our example gene set
```

## 5 Future Steps
Through the database site's online portal, it is also possible to download the MAF scores of relevant SNPs in CSV format, on an independent or batch lookup basis. This would allow to differentiate common and rare variants of genes in the population (rare: MAF < 0.05; common: MAF > 0.05). If a lookup API became available for AWESOME, these conclusions could help us gain insight on what part of this database could be used to inform our future decisions. Unfortunately, as it stands, it is unclear what sort of data integration or mapping methods could be used to inform future decisions for BCB420.
