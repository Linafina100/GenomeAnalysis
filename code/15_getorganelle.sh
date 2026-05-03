#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH -J getorganelle
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/07_chloroplast/%x.%j.out

# Load the module
GetOrganelle/1.7.7.1-foss-2024a

# Input Paths
DNA_R1="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/whole_genome_data/CRR809859_f1.fq.gz"
DNA_R2="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/whole_genome_data/CRR809859_r2.fq.gz"
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/07_chloroplast/assembly_output"

# Move into the output directory
mkdir -p $OUT_DIR
cd $OUT_DIR

# Run GetOrganelle targeting the chloroplast (-F embplant_pt)
echo "Starting Chloroplast Assembly..."
get_organelle_from_reads.py -1 $DNA_R1 -2 $DNA_R2 \
  -o $OUT_DIR \
  -R 15 -k 21,45,65,85,105 \
  -F embplant_pt \
  -t 2

echo "Chloroplast Assembly Complete!"
