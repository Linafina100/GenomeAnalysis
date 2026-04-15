#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 01:00:00
#SBATCH -J busco_chr3
#SBATCH --output=logs/%x.%j.out

# Load the necessary modules
module load BUSCO

# Define folder paths
OUTDIR="analyses/04_assessment/busco_output"
mkdir -p $OUTDIR
INPUT="analyses/03_polishing/pilon_output/chr3_polished.fasta"

# Run BUSCO assessment
# -l embryophyta_odb10: Land plants database
busco -i $INPUT \
      -o busco_results \
      --out_path $OUTDIR \
      -m genome \
      -l embryophyta_odb10 \
      -c 2
