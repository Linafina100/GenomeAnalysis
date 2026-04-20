#!/bin/bash -l

# slurm directives
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2                           
#SBATCH -t 30:00:00
#SBATCH -J braker3_only
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation/%x.%j.out

# module set up
module load braker/3.0.3

# directories & files
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation"
GENOME="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/01_repeat_masking/chr3_polished.fasta.masked"
BAM_FILE="${OUT_DIR}/mapped_RNA_Aligned.sortedByCoord.out.bam"
PROT_DB="/home/lisa5634/GenomeAnalysis/data/reference_data/C_purpureus.faa"
SIF_FILE="/crex/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/braker3.sif"

# structural annotation
echo "Starting BRAKER3 annotation..."

export SINGULARITYENV_AUGUSTUS_CONFIG_PATH=/home/lisa5634/bin/augustus_config

singularity exec \
    -B /home/lisa5634:/home/lisa5634 \
    ${SIF_FILE} \
    braker.pl --genome=${GENOME} \
              --bam=${BAM_FILE} \
              --prot_seq=${PROT_DB} \
              --softmasking \
              --species=niphotrichum_japonicum_lina \
              --AUGUSTUS_CONFIG_PATH=/home/lisa5634/bin/augustus_config \
              --threads=2 \
              --workingdir=${OUT_DIR}/braker_out

echo "BRAKER3 annotation completed successfully."

