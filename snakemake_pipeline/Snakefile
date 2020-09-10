BUSCO_IDs, = glob_wildcards("data/busco_nt_merged/{busco_id}_nt.fasta")

rule all:
	input:
		"results/astral/astral_species_tree.tre"

rule mafft_allignment:
	input:
		"data/busco_nt_merged/{busco_id}_nt.fasta"
	output:
		"results/mafft/{busco_id}.mafft.fa"
	shell:
		"module load mafft;"
		"mafft --auto {input} > {output}" 

rule clean_fasta_header:
        input:
              	"results/mafft/{busco_id}.mafft.fa"
        output:
               	"results/mafft/{busco_id}.cleaned"
        shell:
              	"sed 's/|.*//g' {input} > {output}"

rule trimal_trimming:
	input:
		"results/mafft/{busco_id}.cleaned"
	output:	
		"results/trimal/{busco_id}.trim"
	conda:
		"/home/mib75/trimal.yaml"
	shell:
		"trimal -in {input} -out {output} -automated1"		

rule raxml_gene_trees:
	input:
		"results/trimal/{busco_id}.trim"
	output:
		"results/raxml/RAxML_bestTree.{busco_id}"
	shell:
		"module load raxml;"
		"buscoID=$( echo {output} | sed 's/.*\.//');"
		"raxmlHPC -f a -m GTRGAMMA -# 100 -p 12345 -x 12345 -s {input} -w ${{PWD}}/results/raxml -n $buscoID"

rule astral_species_tree:
	input:
		expand("results/raxml/RAxML_bestTree.{busco_id}", busco_id=BUSCO_IDs)
	output:
		"results/astral/astral_species_tree.tre"
	shell:
		"module load java;"
		"cat {input} >> results/astral/astral_input.tre;"
		"java -jar /projects/tollis_lab/squamate_phylogenetics/tools/ASTRAL/astral.5.6.3.jar -i results/astral/astral_input.tre -o {output}"
