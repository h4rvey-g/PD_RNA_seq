#!/bin/bash
# Align the reads to the genome using the QCed fq files in 2.trim_galore

# input read len = 135

getAlign() {
	index_dir="data/references/Homo_sapiens/Ensembl/index/star"
	indir="test/data/03.TrimData"
	outdir="test/data/04.STARalign_3"
	# create $outdir/$sampleID
	sampleID=$(echo $1 | cut -d "," -f 1)
	mkdir -p $outdir/${sampleID}
	# echo "Processing: "$sampleID::$group
	STAR \
		--runMode alignReads \
		--twopassMode Basic \
		--genomeDir ${index_dir} \
		--runThreadN 10 \
		--readFilesIn $indir/${sampleID}_val_1.fq.gz $indir/${sampleID}_val_2.fq.gz \
		--readFilesCommand zcat \
		--outFileNamePrefix $outdir/$sampleID/$sampleID \
		--outSAMtype BAM Unsorted \
		--outBAMsortingThreadN 5 \
		--outFilterType Normal \
		--outFilterMultimapNmax 20 \
		--quantMode TranscriptomeSAM \
		--sjdbGTFfile data/references/Homo_sapiens/Ensembl/GRCh38/genes.gtf \
		--outSAMattrRGline ID:${sampleID} SM:${sampleID} \
		--runRNGseed 777 --alignSJDBoverhangMin 1
}
export -f getAlign
# date
parallel --progress --keep-order --line-buffer getAlign :::: <(tail -n +2 data/01.fastq/GSE_data/samplesheet.csv | sed -n '2,10p')
# date
/data0/apps/anaconda3/bin/multiqc -i STARalign_clean -o test/04.STAR_multi20 test/data/04.STARalign_2
