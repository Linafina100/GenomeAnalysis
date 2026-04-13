#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH -t 5:00:00
#SBATCH -J flye_chr3
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lina.sandberg-muller.5634@student.uu.se
#SBATCH --output=logs/%x.%j.out

# Load the necessary modules
module load Flye

# Run Flye assembly using your specific folder paths
flye --nano-raw data/raw_data/chr3_clean_nanopore.fq.gz \
     --out-dir analyses/02_genome_assembly/flye_output \
     --threads 16
