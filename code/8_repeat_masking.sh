#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 01:40:00
#SBATCH -J mask_chr3
#SBATCH --output=logs/%x.%j.out

module load RepeatMasker

# Define the output directly inside the annotation folder
OUTDIR="analyses/05_structural_annotation/01_repeat_masking"
INPUT="analyses/03_polishing/pilon_output/chr3_polished.fasta"

# Create the nested directories
mkdir -p $OUTDIR

# Run the masker using the 4 cores allocated
RepeatMasker -pa 4 -species embryophyta -xsmall -dir $OUTDIR $INPUT
