Michael Byars (michael.byars@nau.edu)
Tollis Lab

Contents:

Driver Scripts
Individual bash scripts

Pipeline Steps

0. Run BUSCO

1. Extract single copy busco's for transcriptome runs as nucleotide fastas

2. Grab all complete single copy buscos for every species, then merge them by Gene ID, ie every GENE will have its own fasta file containing the sequence for each species

3. Allign Sequences with MAFFT

4. Trim allignments with TRIMAL

6. Generate gene trees with RAXML

7. Run AMAS summary on gene trees

8. CLUSTAL species tree on RAXML gene trees 
 


