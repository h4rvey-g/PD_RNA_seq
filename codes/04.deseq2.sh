#!/bin/bash
nextflow run nf-core/differentialabundance \
    --input data/01.fastq/GSE_data/new_samplesheet.csv \
    --contrasts data/01.fastq/GSE_data/contrast.csv \
    --matrix results/star_salmon/salmon.merged.gene_counts.tsv \
    --outdir results/deseq2 \
    --gtf data/references/Homo_sapiens/Ensembl/GRCh38/genes.gtf \
    -profile docker \
    --max_cpus 40 \
    --max_memory 150.GB \
    --shinyngs_build_app true \
    --differential_max_pval 0.05 \
    --shinyngs_deploy_to_shinyapps_io \
    --shinyngs_shinyapps_account 'h4rvey' \
    --shinyngs_shinyapps_app_name 'PD_RNA_seq-1'
