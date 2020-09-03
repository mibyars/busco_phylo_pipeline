#!/bin/bash
#SBATCH --job-name=raxmlTRM
#SBATCH --output=/projects/tollis_lab/squamate_phylogenetics/data/FINAL_busco_output/busco_nt_merged/trimal_raxmlAll.out
#SBATCH --mem=36000
#SBATCH -c 32
#SBATCH --time=3-00:00:00
#SBATCH --mail-user=michael.byars@nau.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

module load raxml parallel

cd /projects/tollis_lab/squamate_phylogenetics/data/FINAL_busco_output/busco_nt_merged

srun parallel -j 32 --joblog nt_raxml_trimal_parallel_log < trimal_raxml_commands

