# ``rTea`` Demo

This directory contains supporting files for a hands-on demo of ``rTea`` (RNA Transposable Element Analyzer).
The demo materials are adapted from [rTea-results](https://gitlab.aleelab.net/junseokpark/rTea-results).

---

## Overview

The demo walks you through running ``rTea`` on a small RNA-seq sample and verifying that the output matches the expected results provided here.

### Directory structure

```
rtea_results/
└── demo/
    ├── README.md              # This file
    ├── run_demo.sh            # Script to execute the demo analysis
    ├── data/                  # Large input files – download separately (see below)
    │   ├── demo.R1.fastq.gz
    │   ├── demo.R2.fastq.gz
    │   └── demo.bam
    └── expected_output/
        └── demo.rtea.txt      # Expected rTea output for result comparison
```

---

## Step 1 – Download the demo data

The raw input files are too large to store in this repository.
Download them from **[LINK]** and place them inside `rtea_results/demo/data/`:

```bash
# Create the data directory
mkdir -p rtea_results/demo/data

# Download demo FASTQ files (replace [LINK] with the actual URL when available)
wget -P rtea_results/demo/data [LINK]/demo.R1.fastq.gz
wget -P rtea_results/demo/data [LINK]/demo.R2.fastq.gz
```

> **Note:** The actual download URL will be added to `[LINK]` in a future update.

---

## Step 2 – Set up the environment

Follow the [installation instructions](../../README.md#installation) in the main README to install all required dependencies (fastp, HISAT2, samtools, R packages, etc.) or build/pull the Docker image.

Make sure the HISAT2 genome index (`genome_snp_tran`) is available and set `GENOME_SNP_TRAN_DIR` accordingly:

```bash
export GENOME_SNP_TRAN_DIR=/path/to/grch38_snp_tran
```

---

## Step 3 – Run the demo

A convenience script is provided to run the full pipeline on the demo data:

```bash
bash rtea_results/demo/run_demo.sh \
    rtea_results/demo/data/demo.R1.fastq.gz \
    rtea_results/demo/data/demo.R2.fastq.gz \
    demo_sample \
    $GENOME_SNP_TRAN_DIR \
    4 \
    rtea_results/demo/output \
    hg38
```

Alternatively, if you have a pre-aligned BAM file:

```bash
bash rnatea_pipeline_from_bam \
    rtea_results/demo/data/demo.bam \
    demo_sample \
    $GENOME_SNP_TRAN_DIR \
    4 \
    rtea_results/demo/output \
    hg38
```

The final output will be written to `rtea_results/demo/output/rtea/demo_sample.rtea.txt`.

---

## Step 4 – Verify results

Compare your output with the expected result provided in this repository:

```bash
diff rtea_results/demo/output/rtea/demo_sample.rtea.txt \
     rtea_results/demo/expected_output/demo.rtea.txt
```

A successful run will produce no differences (or only minor floating-point variations).

You can also do a quick column-count check:

```bash
awk -F'\t' 'NR==1{print NF" columns"}' \
    rtea_results/demo/output/rtea/demo_sample.rtea.txt
# Expected: 39 columns
```

---

## About rTea-results

The demo input data and expected output are adapted from the
[rTea-results](https://gitlab.aleelab.net/junseokpark/rTea-results) repository,
which hosts the full pan-cancer analysis results described in the paper:

> *Pan-cancer analysis reveals multifaceted roles of retrotransposon-fusion RNAs*
> ([bioRxiv 2023.10.16.562422](https://www.biorxiv.org/content/10.1101/2023.10.16.562422v1.abstract))

Large data files (e.g., raw FASTQ/BAM files) from `rTea-results/demo/data` are **not** included here.
They must be downloaded separately from **[LINK]** as described above.
