#!/bin/bash
module load FastQC
fastqc -t 4 data/raw_data/chr3_*.fastq.gz -o analyses/01_preprocessing/chromosome_3/fastqc_raw/
