#!/bin/bash

# Use this script to extract single copy busco sequences from busco transcriptome-mode runs - these runs do not automatically generate the single_copy_busco_sequences directory

# first positional argument is genSpe abbreviation
# requires bioawk enabled 

tail -n +6 full_table_$1.tsv |awk '$2 == "Complete" {print $0}' full_table_$1.tsv | awk '{print($3)}' > extract_ids.txt

bioawk -cfastx 'BEGIN{while((getline k <"extract_ids.txt")>0)i[k]=1}{if(i[$name])print ">"$name"\n"$seq}' /projects/tollis_lab/squamate_phylogenetics/data/ref/$1.tran.rna > extracted_busco_sequences.fna

awk '$2 == "Complete" {print $0}' full_table_$1.tsv > $1_table_only_complete_genes.txt

awk '{print $3"\t"$1}' $1_table_only_complete_genes.txt > gene_busco.kv.txt

awk -f /projects/tollis_lab/squamate_phylogenetics/scripts/pipeline/key_renamer.awk gene_busco.kv.txt extracted_busco_sequences.fna > renamed_extracted_busco_sequences.fna

while read line
do
    if [[ ${line:0:1} == '>' ]]
    then
        outfile=${line#>}.fna
        echo $line > $outfile
    else
        echo $line >> $outfile
    fi
done < renamed_extracted_busco_sequences.fna

mkdir single_copy_busco_sequences
mv EO* single_copy_busco_sequences/ 
