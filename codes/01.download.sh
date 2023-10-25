#!/bin/bash
# this run in aspera conda env
ascp -QT -l 1000000 -k2 -P 33001 jshao@aspera.ini.usc.edu:/RNA/FASTQ data
# rename the files from run_accession to sample_title
cat data/01.fastq/GSE_data/accession.txt | while read line; do
    SRR=$(echo $line | cut -d $'\t' -f 1)
    TITLE=$(echo $line | cut -d $'\t' -f 6)
    mv data/01.fastq/GSE_data/$SRR\_1.fastq.gz data/01.fastq/GSE_data/$TITLE\_1.fastq.gz
    mv data/01.fastq/GSE_data/$SRR\_2.fastq.gz data/01.fastq/GSE_data/$TITLE\_2.fastq.gz
done
