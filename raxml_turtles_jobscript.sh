#!/bin/bash
#SBATCH --job-name=raxmlAll
#SBATCH --output=/projects/tollis_lab/turtleNGS/BUSCO_Phylogeny/analysis/trimal/raxml_jobscripts.out
#SBATCH --mem=36000
#SBATCH -c 32
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=smg655@nau.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

module load raxml parallel

cd /projects/tollis_lab/turtleNGS/BUSCO_Phylogeny/analysis/trimal

for i in *trim; do echo 'raxmlHPC -f a -m GTRGAMMA -# 100 -p 12345 -x 12345 -s '${i} ' -n '${i}'.raxml' >> trimal_raxml_commands; done

srun parallel -j 32 --joblog nt_raxml_parallel_log < trimal_raxml_commands

mv *.raxml* ../raxml/
