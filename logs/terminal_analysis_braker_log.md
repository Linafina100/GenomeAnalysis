# Terminal Analysis Log
**Project:** Genome Analysis - Structural Annotation & Mapping
**Author:** Lina Mueller

This file documents the interactive bash commands used to extract key metrics from the pipeline output files for the wiki.

```bash
BASE_PATH="/home/lisa5634/GenomeAnalysis"

### 1. RNA-Seq Mapping Results (STAR)
cd $BASE_PATH/analyses/05_annotation/02_structure_annotation/

grep "Uniquely mapped reads %" mapped_RNA_Log.final.out | awk '{print $NF}'
# result: 7.97%

---

### 2. Structural Annotation Results (BRAKER3)
cd $BASE_PATH/analyses/05_annotation/02_structure_annotation/braker_output/

awk '$3 == "transcript"' braker.gtf | wc -l
# result: 3792

awk '$3 == "gene"' braker.gtf | wc -l
# result: 3296
```
