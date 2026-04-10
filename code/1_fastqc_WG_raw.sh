#!/bin/bash

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_WG_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lina.sandberg-muller.5634@student.uu.se
#SBATCH --output=%x.%j.out

# Load  moduls
module load FastQC

# FastQC on whole genome raw data 
fastqc -t 2 data/raw_data/CRR809859_*.fastq.gz -o analyses/01_preprocessing/whole_genome/fastqc_raw/
