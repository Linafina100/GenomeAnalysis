#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 02:00:00
#SBATCH -J hic_scaffolding
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# Load modules
module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0
module load YaHS/1.2.2-foss-2024a

# Define paths
GENOME="/home/lisa5634/GenomeAnalysis/analyses/03_polishing/pilon_output/chr3_polished.fasta"

HIC_R1="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/genomics_chr3_data/chr3_hiC_R1.fastq.gz"
HIC_R2="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/genomics_chr3_data/chr3_hiC_R2.fastq.gz"

OUTDIR="/home/lisa5634/GenomeAnalysis/analyses/02_genome_assembly/hic_scaffolding"
mkdir -p $OUTDIR
cd $OUTDIR

# Index genome
bwa index $GENOME

# Map Hi-C reads
bwa mem -5SP -t 4 $GENOME $HIC_R1 $HIC_R2 | \
samtools view -bhS - > hic_mapped.bam

# Sort, fix mates, remove duplicates
samtools sort -@ 4 -n hic_mapped.bam | \
samtools fixmate -m - - | \
samtools sort -@ 4 - | \
samtools markdup -r - hic_mapped_filtered.bam

# Run scaffolding
yahs $GENOME hic_mapped_filtered.bam
