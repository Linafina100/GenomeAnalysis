#!/bin/bash
#SBATCH -A uppmax2026-1-61
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 02:00:00
#SBATCH -J fastqc_chr3_raw
#SBATCH -o logs/fastqc_chr3_raw_%j.out
#SBATCH -e logs/fastqc_chr3_raw_%j.err

# Load modules
module load FastQC

# Create output directory if it doesn't exist
mkdir -p analyses/01_preprocessing/fastqc_raw/

# Run FastQC on all Chromosome 3 genomic and transcriptomic reads
# Using -t 4 to match our core allocation
fastqc -t 4 \
    data/raw_data/chromosome_3_data/*.gz \
    -o analyses/01_preprocessing/fastqc_raw/

echo "FastQC for Chromosome 3 raw data completed at $(date)"
