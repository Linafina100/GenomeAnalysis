#!/bin/bash
module load FastQC
fastqc -t 4 data/raw_data/chromosome_3_data/*.gz -o analyses/01_preprocessing/fastqc_raw/
