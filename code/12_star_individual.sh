#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 8
#SBATCH -t 15:00:00
#SBATCH -J star_individual
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/06_expression/%x.%j.out

# Load STAR
module load STAR/2.7.11b-GCC-13.3.0

# Define your directories
READS_DIR="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/transcriptomic_data"
GENOME_INDEX="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation/star_index"
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/06_expression/mapping_individual"

# Make the output directory and move into it
mkdir -p $OUT_DIR
cd $OUT_DIR

# List the 6 sample prefixes we want to map
SAMPLES=(
    "Control_1" 
    "Control_2" 
    "Control_3" 
    "Heat_treated_42_12h_1" 
    "Heat_treated_42_12h_2" 
    "Heat_treated_42_12h_3"
)

# Run STAR for each sample individually
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Starting mapping for: ${SAMPLE}"
    
    STAR --runThreadN 8 \
         --genomeDir $GENOME_INDEX \
         --readFilesIn ${READS_DIR}/${SAMPLE}_f1.fq.gz ${READS_DIR}/${SAMPLE}_r2.fq.gz \
         --readFilesCommand zcat \
         --outFileNamePrefix ${OUT_DIR}/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate
         
    echo "Finished mapping ${SAMPLE}!"
done

echo "All 6 samples have been successfully mapped!"
