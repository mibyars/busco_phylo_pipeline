BUSCO_IDs, = glob_wildcards("data/busco_nt_merged/{busco_id}_nt.fasta")
# OK now pushing from monsoon

rule all:
	input:
		"results/astral/astral_species_tree.tre"

rule prune_taxa:
	input:
		"data/busco_nt_merged/{busco_id}_nt.fasta"
	output:
		"{busco_id}_nt.fasta-out.fas"
	conda:
		"conda_yamls/amas.yml"
	shell:
		"AMAS.py remove -x xantus pinoys triJac agaPic sceOcc sauAte leiCar chaMad anoCri anoEqu -d dna -f fasta -i {input} -u fasta -g ''"

rule move_buscos:
	input:
		"{busco_id}_nt.fasta-out.fas"
	output:
		"results/busco_pruned/{busco_id}_nt.fasta-out.fas"
	shell:
		"mv {input} results/busco_pruned/"

rule clean_pruned_files:
	input:
		"results/busco_pruned/{busco_id}_nt.fasta-out.fas"
	output:
		"results/busco_pruned/{busco_id}_nt.fasta"
	shell:
		"rename -- -out.fas '' {input}"

rule mafft_allignment:
	input:
		"results/busco_pruned/{busco_id}_nt.fasta"
	output:
		"results/mafft/{busco_id}.mafft.fa"
	conda:
		"conda_yamls/mafft.yml"
	shell:
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
		"conda_yamls/trimal.yml"
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

# rule subset_by_length

# rule subset_by_taxa_number

# rule iq_tree_concordance_factors

# rule iq_tree_concat_alignment

rule astral_species_tree:
	input:
		expand("results/raxml/RAxML_bestTree.{busco_id}", busco_id=BUSCO_IDs)
	output:
		"results/astral/astral_species_tree.tre"
	shell:
		"module load java;"
		"cat {input} >> results/astral/astral_input.tre;"
		"java -jar /projects/tollis_lab/squamate_phylogenetics/tools/ASTRAL/astral.5.6.3.jar -i results/astral/astral_input.tre -o {output}"
