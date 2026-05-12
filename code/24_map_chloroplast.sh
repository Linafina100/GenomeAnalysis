#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH -J cp_mapping
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/05_annotation/%x.%j.out

# Create a directory for this analysis and move into it
mkdir -p /home/lisa5634/GenomeAnalysis/analyses/05_annotation/cp_mapping
cd /home/lisa5634/GenomeAnalysis/analyses/05_annotation/cp_mapping

# Load modules
module load BWA
module load SAMtools/1.22.1-GCC-13.3.0

# Define paths
CP_FASTA="/home/lisa5634/GenomeAnalysis/analyses/07_chloroplast/assembly_output/embplant_pt.K105.scaffolds.graph1.1.path_sequence.fasta"
READ1="/home/lisa5634/GenomeAnalysis/data/raw_data/CRR809859_f1.fastq.gz"
READ2="/home/lisa5634/GenomeAnalysis/data/raw_data/CRR809859_r2.fastq.gz"

echo "Indexing the chloroplast assembly..."
bwa index $CP_FASTA

echo "Mapping reads with BWA MEM, converting to BAM, and sorting..."
bwa mem -t 2 $CP_FASTA $READ1 $READ2 | samtools view -bS - | samtools sort -o cp_mapped_sorted.bam

echo "Indexing the sorted BAM file..."
samtools index cp_mapped_sorted.bam

echo "Calculating per-base coverage depth..."
samtools depth cp_mapped_sorted.bam > cp_coverage_depth.txt

echo "Mapping complete!"
