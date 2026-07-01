# Overview

``rTea`` detects TE-fusion transcripts (transposon-fusion RNA) from paired-end RNA-seq data.
It uses multiple features from aligned reads — base quality of clipped sequences, percentage of multi-mapped reads, and alignment score to TE consensus sequences — to filter out false positives caused by non-specifically mapped reads.

## Pipeline stages

1. **QC trimming** — fastp removes adapter contamination and low-quality bases.
2. **Splice-aware alignment** — HISAT2 maps trimmed reads to the reference genome.
3. **Transcript assembly** — Scallop assembles novel transcripts from the alignment.
4. **Soft-clip breakpoint detection** — the `ctea` C++ tool identifies soft-clipped reads that align to TE consensus sequences, producing a `.ctea` file.
5. **Filtering and annotation** — the rTea R pipeline reads the `.ctea` file, applies filter chains, computes depth and VAF, annotates genomic context, and writes the final `.rTea.txt` output.

## Supported TE classes

Alu, L1 (LINE-1), SVA, HERV, PolyA

## Supported genome builds

hg38 (default), hg19
