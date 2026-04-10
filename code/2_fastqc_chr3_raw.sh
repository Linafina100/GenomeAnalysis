#!/bin/bash

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J fastqc_chr3_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lina.sandberg-muller.5634@student.uu.se
#SBATCH --output=%x.%j.out

module load FastQC
fastqc -t 2 data/raw_data/chr3_illumina_*.fastq.gz -o analyses/01_preprocessing/chromosome_3/fastqc_raw/
