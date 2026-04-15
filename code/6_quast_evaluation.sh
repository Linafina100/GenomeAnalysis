#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J quast_eval
#SBATCH --output=logs/%x.%j.out

# Load the necessary modules
module load QUAST

# Define the output directory
OUTDIR="analyses/04_assessment/quast_results"
mkdir -p $OUTDIR

# Run QUAST with corrected flags
quast.py analyses/03_polishing/pilon_output/draft_assembly.fasta \
         analyses/03_polishing/pilon_output/chr3_polished.fasta \
         -o $OUTDIR \
         --labels Draft_Flye,Polished_Pilon
