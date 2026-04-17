#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 40:00:00
#SBATCH -J star_braker
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# load modules
module load STAR/2.7.11b-GCC-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0

# file variables
MASKED_GENOME="/home/lisa5634/GenomeAnalysis/analyses/05_structural_annotation/01_repeat_masking/chr3_polished.fasta.masked"
PROTEIN_DB="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/Ceratodon_purpureus/C_purpureus.faa"
BRAKER_SIF="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/braker3.sif"

# rna files
RNA_DIR="/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/reads/transcriptomic_data"
RNA_R1="${RNA_DIR}/Control_1_f1.fq.gz,${RNA_DIR}/Control_2_f1.fq.gz,${RNA_DIR}/Control_3_f1.fq.gz,${RNA_DIR}/Heat_treated_42_12h_1_f1.fq.gz,${RNA_DIR}/Heat_treated_42_12h_2_f1.fq.gz,${RNA_DIR}/Heat_treated_42_12h_3_f1.fq.gz"
RNA_R2="${RNA_DIR}/Control_1_r2.fq.gz,${RNA_DIR}/Control_2_r2.fq.gz,${RNA_DIR}/Control_3_r2.fq.gz,${RNA_DIR}/Heat_treated_42_12h_1_r2.fq.gz,${RNA_DIR}/Heat_treated_42_12h_2_r2.fq.gz,${RNA_DIR}/Heat_treated_42_12h_3_r2.fq.gz"

# setup output directory
OUT_DIR="/home/lisa5634/GenomeAnalysis/analyses/05_structural_annotation/02_structure_annotation"
mkdir -p $OUT_DIR/star_index

# build star index
STAR --runThreadN 2 \
     --runMode genomeGenerate \
     --genomeDir $OUT_DIR/star_index \
     --genomeFastaFiles $MASKED_GENOME

# map rna reads
STAR --runThreadN 2 \
     --genomeDir $OUT_DIR/star_index \
     --readFilesIn $RNA_R1 $RNA_R2 \
     --readFilesCommand zcat \
     --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix $OUT_DIR/mapped_RNA_

# run braker3 container
export AUGUSTUS_CONFIG_PATH=/home/lisa5634/bin/augustus_config

singularity exec \
    -B /home/lisa5634:/home/lisa5634 \
    $BRAKER_SIF \
    braker.pl --genome=$MASKED_GENOME \
              --bam=$OUT_DIR/mapped_RNA_Aligned.sortedByCoord.out.bam \
              --prot_seq=$PROTEIN_DB \
              --softmasking \
              --species=niphotrichum_japonicum_lisa \
              --threads=1 \
              --workingdir=$OUT_DIR/braker_output
