# GenomeAnalysis

This repository contains the pipeline for a comprehensive bioinformatic analysis of the moss N. japonicum. The project is based on data from the article "The genome of the haploid moss Niphotrichum japonicum provides new insights into heat stress responses in mosses" by Zhou et al. (2023).

The original study used a combination of long-read Nanopore sequencing, short-read Illumina sequencing, and Hi-C scaffolding to assemble a reference genome and study gene expression changes under heat stress. The purpose of this project is to replicate the preprocessing, assembly of Chromosome 3, and subsequent differential expression analysis.

## Repository Structure
The project is divided into three primary subfolders:

data/: Contains metadata.

code/: Contains all Bash and R scripts used for pre-processing and analysis.

analyses/: Stores the outputs and results, including QC reports and assembly statistics.

## Pipeline
1. Preprocessing & quality Control
2. Genome assembly
3. Polishing
5. Functional and structural annotation
6. Transcriptomic analysis (differential expression)

### Detailed Workflow
The analysis is designed to be executed in the following order:

1. Raw Data QC: Initial quality assessment of Illumina DNA reads using FastQC.
2. Read Preprocessing: Adapter removal and quality trimming using Trimmomatic.
3. Post-Trimming QC: Secondary assessment with FastQC to verify trimming efficiency.
4. Genome Assembly: De novo assembly of Chromosome 3 using Nanopore long-reads and Illumina short-read polishing.
5. Assembly Evaluation: Quality assessment of the resulting contigs using QUAST.
6. Synteny & Comparison: Visual comparison of the assembly against the reference genome using MUMmer/MUMmerplot.

Functional Annotation: Identifying gene structures and coding sequences.

RNA-Seq Preprocessing: QC and trimming of Illumina RNA-seq reads (Heat Stress vs. Control).

Read Mapping: Aligning RNA-seq reads to the new assembly using BWA/SAMtools.

Quantification: Generating gene-level counts using HTSeq-count.

Differential Expression: Statistical analysis of heat stress response using DESeq2 in R



Trimmed reads are stored in the data directory. Symbolic links are used in the analyses directory to reflect workflow steps without duplicating large files.
