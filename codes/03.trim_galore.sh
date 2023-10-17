#bin/bash
# based on the report at 1.cleandata_QC/1.cleandata_QC_multiqc_report.html, need to hard-cut the first 9bp according to the failed "Per Base Sequence Content"

# input read len = 150
# cut 5' len = 15
# length cutoff 150-15=135

getTrim() {
	indir=./data/01.fastq/GSE_data
	outdir_trim=./test/data/03.TrimData
	outdir_QC=test/03.trim_galore_QC
	# make dir at current working directionary
	mkdir -p $outdir_trim
	mkdir -p $outdir_QC
	# sampleID is the first column of the comma separated file
	sampleID=$(echo $1 | cut -d "," -f 1)
	trim_galore \
		--paired \
		--gzip \
		-j 8 -e 0.1 -q 20 -O 1 -a AGATCGGAAGAGC \
		--fastqc --fastqc_args "-o $outdir_QC" \
		-o $outdir_trim \
		--basename "$sampleID" \
		$indir/${sampleID}.fastq.gz $indir/${sampleID::-1}2.fastq.gz
}
export -f getTrim
parallel --progress --keep-order --line-buffer getTrim :::: <(tail -n +2 data/01.fastq/GSE_data/samplesheet.csv)
# /data0/apps/anaconda3/bin/multiqc -i 03.trim_galore_QC -o ./results/03.trim_galore_QC ./results/03.trim_galore_QC
