#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:15:00
#SBATCH -J cp_mummer
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/07_chloroplast/%x.%j.out

cd /home/lisa5634/GenomeAnalysis/analyses/07_chloroplast

# Load module
module load MUMmer/4.0.1-GCCcore-13.3.0

# Define paths
REF="reference_sequence.fasta"
QUERY="assembly_output/embplant_pt.K105.scaffolds.graph1.1.path_sequence.fasta"

# Run nucmer (Whole-genome alignment) and create 'cp_comp.delta'
nucmer --prefix=cp_comp $REF $QUERY

# Filter and generate the dot-plot 
# -p creates the prefix for the plot files
# --png ensures you get a viewable image file
delta-filter -1 cp_comp.delta > cp_comp.filter.delta

mummerplot --png --prefix=cp_comp_plot cp_comp.filter.delta
