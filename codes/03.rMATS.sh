#!/bin/bash
workdir=results
bams_indir=$workdir/star_salmon
rmats_outdir=$workdir/rMATs
#1: prepare the sample group, rep1 in one group and rep2 in the other.
sampleMetaPD=./data/rmats_samples_PD.txt
echo "" >"$sampleMetaPD"
find "$bams_indir" -name "PD""_*""_1.markdup.sorted.bam" | while read -r line; do
    echo -n "$line," >>"$sampleMetaPD"
done
sed -i '1d' "$sampleMetaPD"

sampleMetaCC=./data/rmats_samples_CC.txt
echo "" >"$sampleMetaCC"
find "$bams_indir" -name "CC""_*""_1.markdup.sorted.bam" | while read -r line; do
    echo -n "$line," >>"$sampleMetaCC"
done
sed -i '1d' "$sampleMetaCC"
# remove the last comma in each line
sed -i 's/,$//g' "$sampleMetaPD"
sed -i 's/,$//g' "$sampleMetaCC"
# #2: do as detection using rmats turbo
genome_gtf="data/references/Homo_sapiens/Ensembl/GRCh38/genes.gtf"
alias rmats='/data0/apps/anaconda3/bin/python /data0/apps/anaconda3/bin/rmats.py'
# use rmats to compare each group in a, b, c of $sample_groups, use loop
/data0/apps/anaconda3/bin/python /data0/apps/anaconda3/bin/rmats.py \
    --b1 $sampleMetaPD \
    --b2 $sampleMetaCC \
    --gtf $genome_gtf \
    --od "$rmats_outdir/" \
    --tmp "$rmats_outdir/tmp/" \
    --variable-read-length \
    --readLength 51 \
    -t paired \
    --nthread 30 \
    --novelSS
# remove all tmp in subfolders
find "$rmats_outdir" -name "tmp" | xargs rm -rf
# filter significant AS events
cd results/rMATs
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 >= 0.1)' SE.MATS.JCEC.txt >sig/SE.sig.gain.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 >= 0.1)' A5SS.MATS.JCEC.txt >sig/A5SS.sig.gain.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 >= 0.1)' A3SS.MATS.JCEC.txt >sig/A3SS.sig.gain.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 >= 0.1)' RI.MATS.JCEC.txt >sig/RI.sig.gain.txt
awk 'NR == 1||($21<0.01 && $22<0.05 && $25 >= 0.1)' MXE.MATS.JCEC.txt >sig/MXE.sig.gain.txt
awk 'NR == 1||($21<0.01 && $22<0.05 && $25 <=- 0.1)' MXE.MATS.JCEC.txt >sig/MXE.sig.loss.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 <= -0.1)' RI.MATS.JCEC.txt >sig/RI.sig.loss.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 <= -0.1)' SE.MATS.JCEC.txt >sig/SE.sig.loss.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 <= -0.1)' A5SS.MATS.JCEC.txt >sig/A5SS.sig.loss.txt
awk 'NR == 1||($19<0.01 && $20<0.05 && $23 <= -0.1)' A3SS.MATS.JCEC.txt >sig/A3SS.sig.loss.txt
# sashimiplot
rmats2sashimiplot \
    --b1 "$sampleMetaPD" \
    --b2 "$sampleMetaCC" \
    --gtf "$genome_gtf" \
    --l1 PD \
    --l2 CC \
    --exon_s 1 \
    --intron_s 5 \
    -o $rmats_outdir/sashimiplot
