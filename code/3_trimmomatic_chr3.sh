#!/bin/bash

# Load the exact module
module load Trimmomatic/0.39-Java-17

# Create output directory
mkdir -p data/trimmed_data/chromosome_3

# Run Trimmomatic
trimmomatic PE -threads 4 \
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
