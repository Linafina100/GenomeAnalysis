#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 00:15:00
#SBATCH -J quast_cp
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/04_assessment/%x.%j.out

# Load the QUAST module
module load QUAST

cd /home/lisa5634/GenomeAnalysis

# Define the output directory
OUTDIR="analyses/04_assessment/quast_chloroplast"
mkdir -p $OUTDIR

# Run QUAST on the chloroplast assembly
quast.py analyses/07_chloroplast/assembly_output/embplant_pt.K105.scaffolds.graph1.1.path_sequence.fasta \
         -o $OUTDIR \
         --labels Chloroplast_GetOrganelle
