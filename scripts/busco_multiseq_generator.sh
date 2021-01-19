#!/bin/bash

### Run this in the parent directory of your individual busco runs

## Get list of complete BUSCO's for each species & prep list of busco genes to extract
for file in */*run_*/full_table*.tsv; do grep -v "^#" ${file} | awk '$2=="Complete" {print $1}' >> complete_busco_ids.txt; done
sort complete_busco_ids.txt | uniq -c > complete_busco_ids_with_counts
awk '$1 > 2 {print $2}' complete_busco_ids_with_counts > final_busco_ids

## Copy single_copy_busco_sequences into a new directory and append the appropriate genSpe abbreviation to each file

mkdir busco_nt1
mkdir busco_nt_merged
for dir in $(find -type d -name "single_copy_busco_sequences"); do  genSpe=$(dirname $dir | cut -c 3-8);  for file in ${dir}/*.fna; do cp ${file} ./busco_nt1/${genSpe}_$(basename ${file}); sed -i 's/^>/>'${genSpe}'|/g' ./busco_nt1/${genSpe}_$(basename ${file}); done; done

## Merge the BUSCO nucleotide fasta sequences together - (each file will have the same BUSCO sequence from different species) 
while read line; do cat busco_nt1/??????_${line}.fna >> busco_nt_merged/${line}_nt.fasta; done < final_busco_ids

