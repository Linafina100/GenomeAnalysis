#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH --mem=32G
#SBATCH -t 12:00:00
#SBATCH -J pilon_chr3
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lina.sandberg-muller.5634@student.uu.se
#SBATCH --output=logs/%x.%j.out

# Load the necessary modules
module load bioinfo-tools
module load bwa
module load samtools
module load Pilon

# Define folder paths to match your newly numbered structure
OUTDIR="analyses/03_polishing/pilon_output"
mkdir -p $OUTDIR
BAM="$OUTDIR/chr3_aligned.bam"

# Make a safe copy of the draft assembly
cp analyses/02_genome_assembly/flye_output/assembly.fasta $OUTDIR/draft_assembly.fasta
DRAFT="$OUTDIR/draft_assembly.fasta"

# Define paths to your trimmed Illumina reads
R1="data/trimmed_data/chromosome_3/chr3_R1_paired.fastq.gz"
R2="data/trimmed_data/chromosome_3/chr3_R2_paired.fastq.gz"

# Create an index dictionary of your draft assembly
bwa index $DRAFT

# Map Illumina reads to the draft, then instantly sort them into a BAM file
bwa mem -t 2 $DRAFT $R1 $R2 | samtools sort -@ 2 -o $BAM -

# Index the BAM file (required by Pilon)
samtools index $BAM

# Run Pilon to polish the assembly
java -Xmx30G -jar $EBROOTPILON/pilon.jar \
     --genome $DRAFT \
     --frags $BAM \
     --output chr3_polished \
     --outdir $OUTDIR \
     --changes
