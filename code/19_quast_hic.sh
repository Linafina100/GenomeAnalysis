#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:30:00
#SBATCH -J quast_hic
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/04_assessment/%x.%j.out

# Load the QUAST module
module load QUAST

# Force the script to start from your main project folder so paths never break
cd /home/lisa5634/GenomeAnalysis

# Define the output directory
OUTDIR="analyses/04_assessment/quast_scaffold_comparison"
mkdir -p $OUTDIR

# Run QUAST to compare the pre-Hi-C and post-Hi-C assemblies
quast.py analyses/03_polishing/pilon_output/chr3_polished.fasta \
         analyses/02_genome_assembly/hic_scaffolding/yahs.out_scaffolds_final.fa \
         -o $OUTDIR \
         --labels Polished_Pilon,HiC_Scaffolded
