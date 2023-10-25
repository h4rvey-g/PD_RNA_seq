#!/bin/bash
# Read the CSV file and sort by the first column
sort -t ',' -k1 data/01.fastq/GSE_data/samplesheet.csv >data/01.fastq/GSE_data/sorted_samplesheet.csv

# Extract the header row
header=$(head -n 1 data/01.fastq/GSE_data/samplesheet.csv)

# Extract the PD samples and CC samples
PD_samples=$(grep -i "PD" data/01.fastq/GSE_data/sorted_samplesheet.csv)
CC_samples=$(grep -i "CC" data/01.fastq/GSE_data/sorted_samplesheet.csv)

# Combine the header row and sorted PD and CC samples
echo "$header" >data/01.fastq/GSE_data/sorted_samplesheet.csv
echo "$PD_samples" >>data/01.fastq/GSE_data/sorted_samplesheet.csv
echo "$CC_samples" >>data/01.fastq/GSE_data/sorted_samplesheet.csv
echo "$header" >data/01.fastq/GSE_data/new_samplesheet.csv
tail -n +2 data/01.fastq/GSE_data/sorted_samplesheet.csv | awk -F',' '{split($1,a,"_"); $1=a[2]"_"a[1]"_"a[3]"_"a[4]; print}' OFS=',' >>data/01.fastq/GSE_data/new_samplesheet.csv

nextflow run nf-core/rnaseq \
    --input data/01.fastq/GSE_data/new_samplesheet.csv \
    --outdir results/ \
    --gtf data/references/Homo_sapiens/Ensembl/GRCh38/genes.gtf \
    --fasta data/references/Homo_sapiens/Ensembl/GRCh38/genome.fa \
    --star_index data/references/Homo_sapiens/Ensembl/index/star \
    --salmon_index data/references/Homo_sapiens/Ensembl/index/salmon \
    -profile docker \
    --max_cpus 40 \
    --max_memory 150.GB
