#!/bin/bash
#SBATCH --job-name=raxmlAll
#SBATCH --output=/projects/tollis_lab/squamate_phylogenetics/analysis/astral_pipeline/clipkit_raxmlAll.out
#SBATCH --mem=36000
#SBATCH -c 32
#SBATCH --time=3-00:00:00
#SBATCH --mail-user=michael.byars@nau.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

module load raxml parallel

cd /projects/tollis_lab/squamate_phylogenetics/analysis/astral_pipeline/clipkit

srun parallel -j 32 --joblog nt_raxml_parallel_log < clipkit_raxml_commands

