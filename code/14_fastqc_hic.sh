#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:30:00
#SBATCH -J fastqc_hic
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/01_preprocessing/%x.%j.out

# Load the module
module load FastQC/0.11.9

# Exact Hi-C Data Paths
HIC_R1="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/genomics_chr3_data/chr3_hiC_R1.fastq.gz"
HIC_R2="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/genomics_chr3_data/chr3_hiC_R2.fastq.gz"

# Output Directory
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/01_preprocessing/hic/fastqc_raw"
mkdir -p $OUT_DIR

# Run FastQC
echo "Running FastQC on Hi-C reads..."
fastqc -t 2 -o $OUT_DIR $HIC_R1 $HIC_R2

echo "FastQC complete!"
