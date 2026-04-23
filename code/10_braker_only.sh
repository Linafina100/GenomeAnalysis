#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH --mem=64G
#SBATCH -J braker_only
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation/%x.%j.out

# file variables
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/02_structure_annotation"
MASKED_GENOME="/home/lisa5634/GenomeAnalysis/analyses/05_annotation/01_repeat_masking/chr3_polished.fasta.masked"
BRAKER_SIF="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/braker3.sif"
BAM_FILE="$OUT_DIR/mapped_RNA_Aligned.sortedByCoord.out.bam"

# setup output directory
mkdir -p $OUT_DIR/braker_output
export TMPDIR=$OUT_DIR/tmp
mkdir -p $TMPDIR


# run braker3 container
#export AUGUSTUS_CONFIG_PATH="/home/lisa5634/bin/augustus_config"

singularity exec \
    -B /home/lisa5634:/home/lisa5634 \
    -B /home/lisa5634/bin/augustus_config:/opt/Augustus/config \
    $BRAKER_SIF \
    braker.pl --genome=$MASKED_GENOME \
              --bam=$BAM_FILE \
              --softmasking \
              --species=lisa2 \
              --threads=2 \
	      --min_contig=5000 \
              --workingdir=$OUT_DIR/braker_output
