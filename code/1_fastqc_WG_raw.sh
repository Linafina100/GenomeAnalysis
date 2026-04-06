#!/bin/bash

# Load  moduls
module load FastQC

# FastQC on whole genome raw data 
fastqc -t 2 data/raw_data/WG_*.fastq.gz -o analyses/01_preprocessing/whole_genome/fastqc_raw/
