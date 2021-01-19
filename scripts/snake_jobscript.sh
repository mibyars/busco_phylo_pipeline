#!/bin/bash
#SBATCH --job-name=snekBSCO
#SBATCH --output=/scratch/mib75/busco_squamate_no_gamble_transcriptomes/snakemake_jobscripts.out
#SBATCH --error=/scratch/mib75/busco_squamate_no_gamble_transcriptomes/snakemake_busco.error
#SBATCH --mem=42000
#SBATCH -c 32
#SBATCH --time=4-00:00:00
#SBATCH --mail-user=michael.byars@nau.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

module load anaconda3
source activate snakemake

cd /scratch/mib75/busco_squamate_no_gamble_transcriptomes

srun snakemake --use-conda --cores 32 --keep-going --latency-wait 300

