#!/bin/bash

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J trimmomatic_chr3
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lina.sandberg-muller.5634@student.uu.se
#SBATCH --output=%x.%j.out

# Load the exact module
module load Trimmomatic/0.39-Java-17

# Create output directory
mkdir -p data/trimmed_data/chromosome_3

# Run Trimmomatic
trimmomatic PE -threads 2 \
    data/raw_data/chr3_illumina_R1.fastq.gz \
    data/raw_data/chr3_illumina_R2.fastq.gz \
    data/trimmed_data/chromosome_3/chr3_R1_paired.fastq.gz \
    data/trimmed_data/chromosome_3/chr3_R1_unpaired.fastq.gz \
    data/trimmed_data/chromosome_3/chr3_R2_paired.fastq.gz \
    data/trimmed_data/chromosome_3/chr3_R2_unpaired.fastq.gz \
    LEADING:3 \
    TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36

echo "Trimming for Chromosome 3 Illumina reads completed at $(date)"
