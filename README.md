Michael Byars (michael.byars@nau.edu)
Tollis Lab

Contents:

Driver Scripts
Individual bash scripts

Pipeline Steps

0. Run BUSCO

1. Extract single copy busco's for transcriptome runs as nucleotide fastas

use the transcriptome converter bash script

2. Grab all complete single copy buscos for every species, then merge them by Gene ID, ie every GENE will have its own fasta file containing the sequence for each species


## Get list of complete BUSCO's for each species & prep list of busco genes to extract
for file in */*run_*/full_table*.tsv; do grep -v "^#" ${file} | awk '$2=="Complete" {print $1}' >> complete_busco_ids.txt; done
sort complete_busco_ids.txt | uniq -c > complete_busco_ids_with_counts
awk '$NF > 2 {print $2}' complete_busco_ids_with_counts > final_busco_ids

## Copy single_copy_busco_sequences into a new directory and append the appropriate genSpe abbreviation to each file

mkdir busco_nt
mkdir busco_nt_merged

for dir in $(find -type d -name "single_copy_busco_sequences"); do  genSpe=$(dirname $dir | cut -c 3-8);  for file in ${dir}/*.fna; do cp ${file} ./busco_nt/${genSpe}_$(basename ${file}); sed -i 's/^>/>'${genSpe}'|/g' ./busco_nt/${genSpe}_$(basename ${file}); done; done

## Merge the BUSCO nucleotide fasta sequences together - (each file will have the same BUSCO sequence from different species) 
while read line; do cat busco_nt/??????_${line}.fna >> busco_nt_merged/${line}_nt.fasta; done < final_busco_ids

3. Allign Sequences with MAFFT

# First you need to generate a list of commands to feed into gnu-parallel
# Run this command in the merged busco nt directory
for i in *.fasta; do echo 'mafft --auto ' ${i} ' > ' ${i}'.mafft.out' >> commands; done

# Now that we have our commands for mafft, start a screen session, allocate some resources, and then feed the commands into gnu-parallel

salloc -c 12 --mem 24000 -t 480
srun parallel -j 12 < commands

4. Trim allignments with TRIMAL

We need to modify our fasta alignment files to get rid of everything but the species name in the sequence header

for i in *mafft.out; do sed -i 's/|.*//' ${i}; done

# [deprecated] for i in *mafft.out; do echo 'trimal -in '${i}' -out '${i}'.trim -automated1' >> trimal_commands; done

# cliplkit trimmming, takes <30 min for ~4000 alignments w/ 12 cores
for i in *mafft.out; do echo 'clipkit '${i} >> clipkit_commands; done



5. Remove GeneID from fasta header in alignment (gene name will still be in filename, this is necessary for the Astral program)

6. Generate gene trees with RAXML

for i in *clipkit; do echo 'raxmlHPC -f a -m GTRGAMMA -# 100 -p 12345 -x 12345 -s '${i} ' -n '${i}'.raxml' >> clipkit_raxml_commands; done

for i in *trim; do echo 'raxmlHPC -f a -m GTRGAMMA -# 100 -p 12345 -x 12345 -s '${i} ' -n '${i}'.raxml' >> trimal_raxml_commands; done

7. Run AMAS summary on gene trees

8. ASTRAL species tree on RAXML gene trees 
 
# concatenate alignments into input file

# run astral 

srun java -jar /projects/tollis_lab/squamate_phylogenetics/tools/ASTRAL/astral.5.6.3.jar astral_input_bipartitions.tre