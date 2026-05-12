#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J make_hic
#SBATCH --mail-type=ALL
#SBATCH --output=/home/lisa5634/GenomeAnalysis/analyses/02_genome_assembly/hic_scaffolding/%x.%j.out

cd /home/lisa5634/GenomeAnalysis/analyses/02_genome_assembly/hic_scaffolding

# Load modules
module load YaHS/1.2.2-foss-2024a
module load SAMtools/1.22.1-GCC-13.3.0
module load Java/17

# Download the new Juicer Tools Jar directly from GitHub's v3.0 release
wget -O juicer_tools.jar https://github.com/aidenlab/Juicebox/releases/download/v2.20.00/juicer_tools.2.20.00.jar

# Index your polished FASTA 
samtools faidx /home/lisa5634/GenomeAnalysis/analyses/03_polishing/pilon_output/chr3_polished.fasta

# Convert the Yahs .bin to a text format
juicer pre -a -o out_JBAT yahs.out.bin yahs.out_scaffolds_final.agp /home/lisa5634/GenomeAnalysis/analyses/03_polishing/pilon_output/chr3_polished.fasta.fai


# Math conversion
java -Xmx16G -jar juicer_tools.jar pre out_JBAT.txt out_JBAT.hic out_JBAT.chrom.sizes
