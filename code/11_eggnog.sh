#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH -J eggnog_chr3
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/05_annotation/03_functional_annotation/%x.%j.out

# Load the eggNOG-mapper module 
module load eggnog-mapper/2.1.13-gfbf-2024a

# Set up variables
INPUT_PROTEINS="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation/braker_output/braker.aa"
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/03_functional_annotation"

mkdir -p $OUT_DIR
cd $OUT_DIR

# Run eggNOG-mapper 
emapper.py -i $INPUT_PROTEINS \
           --output chr3_functional \
           --cpu 2 \
           --itype proteins \
	   --data_dir /sw/data/eggNOG/5.0.0/rackham/ 
