#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 06:00:00
#SBATCH --mem=64G
#SBATCH -J cp_cov
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/07_chloroplast/%x.%j.out

set -euo pipefail

module load Bowtie2
module load SAMtools

echo "=== START chloroplast coverage ==="
date

PROJECT="$HOME/GenomeAnalysis"
OUTDIR="$PROJECT/analyses/07_chloroplast/cp_mapping"

REF="$PROJECT/analyses/07_chloroplast/assembly_output/embplant_pt.K105.scaffolds.graph1.1.path_sequence.fasta"
R1="$PROJECT/data/raw_data/CRR809859_f1.fastq.gz"
R2="$PROJECT/data/raw_data/CRR809859_r2.fastq.gz"

mkdir -p "$OUTDIR"
cd "$OUTDIR"

rm -f cp.bam cp.bam.bai cp.depth cp_index*

echo "=== Checking input files ==="
ls -lh "$REF" "$R1" "$R2"

echo "=== Build Bowtie2 index ==="
bowtie2-build "$REF" cp_index

echo "=== Mapping and sorting directly to BAM ==="
# -p 2 and -@ 2 match your core limit. 
# -T tmp_sort/cp_temp forces it to use your local folder instead of the server's
bowtie2 -p 2 -x cp_index \
  -1 "$R1" \
  -2 "$R2" \
| samtools view -b -F 4 - \
| samtools sort -@ 2 -m 1G -T $SNIC_TMP/cp_temp -o cp.bam

echo "=== Index BAM ==="
samtools index cp.bam

echo "=== Calculate coverage depth ==="
samtools depth cp.bam > cp.depth

echo "=== Average coverage ==="
awk '{sum+=$3} END {print "Average coverage:", sum/NR}' cp.depth

echo "=== Output files ==="
ls -lh cp.bam cp.bam.bai cp.depth

echo "=== DONE ==="
date
