#!/bin/bash

# Load  moduls
module load FastQC

# FastQC on whole genome raw data 
fastqc -t 2 data/raw_data/whole_genome_data/*.fq.gz -o analyses/01_preprocessing/fastqc_raw/
