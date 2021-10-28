Michael Byars (michael.byars@nau.edu)
Simone Gable (smg655@nau.edu)
Tollis Lab

Based off of: https://bioinformaticsworkbook.org/dataAnalysis/phylogenetics/reconstructing-species-phylogenetic-tree-with-busco-genes-using-maximum-liklihood-method.html#gsc.tab=0

# Contents:

Driver Scripts
Individual bash scripts

# Software Dependencies

BUSCO (version 3.0, not compatible with version 4.0+)
MAFFT: https://mafft.cbrc.jp/alignment/software/
RAxML-HPC: https://cme.h-its.org/exelixis/web/software/raxml/index.html
TrimAL: https://github.com/scapella/trimal
ASTRAL: https://github.com/smirarab/ASTRAL

# Installation Instructions

## 1.) Clone github repository

## 2.) Create Conda environments using the bioconda recipes for the following programs
MAFFT: https://mafft.cbrc.jp/alignment/software/
RAxML-HPC: https://cme.h-its.org/exelixis/web/software/raxml/index.html
TrimAL: https://github.com/scapella/trimal

## 3.) Export .yaml files for each environment into the folder /YOUR_WORKING_DIR/busco_phylo_pipeline/conda_yamls

## 4.) Conda .yaml files should have the following names to work with snakake pipeline:
amas.yml
mafft.yml
raxml.yml
trimal.yml

## 5.) Download and install astral into the tools/ directory
*Note: If you are using a different version of Astral you will have to correct the name in the Snakemake pipeline*

## 6.) Extract nucleotide sequences for each BUSCO, place in the data/busco_nt_merged/ directory

*Helper Scripts have been placed in the scripts/ directory to help automate this process. Run busco_multiseq_generator.sh in the base directory of your BUSCO output directory to extract and collate the sequences into one file containing the sequences from every species for each BUSCO. If you have transcriptome mode output from BUSCO there is a script called trans_extract_sequences.sh that you will need to run on each transcriptome mode run before running busco_multiseq_generator.sh.*

## Run the Snakemake Pipeline use this command (or similar)
```
snakemake --cores 4 --use-conda --keep-going
```

