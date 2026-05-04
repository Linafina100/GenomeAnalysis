#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 2:00:00
#SBATCH -J featureCounts
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/06_expression/%x.%j.out

# Load the required module 
module load Subread/2.1.1-GCC-13.3.0

# Define your exact file paths
ANNOTATION="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation/braker_output/braker.gtf"
BAM_DIR="/home/lisa5634/GenomeAnalysis/analyses/06_expression/mapping_individual"
OUTPUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/06_expression"

# Move into the output directory
cd $OUTPUT_DIR

# Run featureCounts
# -T: 2 uses 2 core
# -p: data is paired-end
# -t exon: only count reads mapped to exons
# -g gene_id: groups the counts by the gene name
echo "Starting featureCounts..."
featureCounts -T 2 -p -t exon -g gene_id \
  -a $ANNOTATION \
  -o raw_gene_counts.txt \
  $BAM_DIR/*Aligned.sortedByCoord.out.bam

# Clean the Matrix for DESeq2
echo "Cleaning up the count matrix..."
sed '1d' raw_gene_counts.txt | cut -f1,7- > clean_gene_counts.txt

echo "Pipeline complete! Final file for R is clean_gene_counts.txt"
