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
    ├── README.md                       # This file
    ├── run_demo.sh                     # Script to execute the demo analysis
    ├── checksums.sha256                # SHA-256 checksums for downloaded input files
    ├── data/                           # Large input files – download separately (see Step 1)
    │   ├── demo.R1.fastq.gz
    │   ├── demo.R2.fastq.gz
    │   └── demo.bam                    # Optional – only needed for BAM-mode demo
    └── expected_output/
        └── demo.rtea.txt               # Expected rTea output for result comparison
```

---

## Step 1 – Download the demo data

The raw input files are too large to store in this repository.
They are hosted on Google Cloud Storage (GCS) with **Requester Pays** enabled.

See **[docs/gcs_requester_pays.md](../../docs/gcs_requester_pays.md)** for full instructions on setting up `gcloud` and obtaining a billing project.

```bash
# Set your Google Cloud billing project
export RTEA_BILLING_PROJECT="your-google-cloud-project-id"
export RTEA_DEMO_BUCKET="gs://<RTEA_DEMO_BUCKET>"   # replace with actual bucket name

# Create the data directory
mkdir -p rtea_results/demo/data

# Download demo FASTQ files
gcloud storage cp "$RTEA_DEMO_BUCKET/demo/fastq/demo.R1.fastq.gz" \
    rtea_results/demo/data/demo.R1.fastq.gz \
    --billing-project="$RTEA_BILLING_PROJECT"

gcloud storage cp "$RTEA_DEMO_BUCKET/demo/fastq/demo.R2.fastq.gz" \
    rtea_results/demo/data/demo.R2.fastq.gz \
    --billing-project="$RTEA_BILLING_PROJECT"
```

Or use the convenience script:

```bash
bash scripts/download_demo_data.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_DEMO_BUCKET/demo"
```

**Optional – download demo BAM** (only needed for BAM-mode demo):

```bash
gcloud storage cp "$RTEA_DEMO_BUCKET/demo/bam/demo.bam" \
    rtea_results/demo/data/demo.bam \
    --billing-project="$RTEA_BILLING_PROJECT"
```

**Verify checksums** (recommended):

```bash
sha256sum -c rtea_results/demo/checksums.sha256
```

---

## Step 2 – Set up the environment

Follow the [installation instructions](../../README.md#installation) in the main README to install all required dependencies (fastp, HISAT2, samtools, R packages, etc.) or use Docker/Singularity.

Set the HISAT2 genome index path:

```bash
export GENOME_SNP_TRAN_DIR=/path/to/grch38_snp_tran
```

**Optional – use a prebuilt Singularity image:**

```bash
mkdir -p images
export RTEA_IMAGE_BUCKET="gs://<RTEA_IMAGE_BUCKET>"   # replace with actual bucket name

bash scripts/download_singularity_image.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_IMAGE_BUCKET"
# Image saved to images/rtea_latest.sif
```

---

## Step 3 – Run the demo

### FASTQ mode (standard)

```bash
bash rtea_results/demo/run_demo.sh \
    rtea_results/demo/data/demo.R1.fastq.gz \
    rtea_results/demo/data/demo.R2.fastq.gz \
    demo_sample \
    "$GENOME_SNP_TRAN_DIR" \
    4 \
    rtea_results/demo/output \
    hg38
```

With Singularity:

```bash
singularity exec images/rtea_latest.sif bash rtea_results/demo/run_demo.sh \
    rtea_results/demo/data/demo.R1.fastq.gz \
    rtea_results/demo/data/demo.R2.fastq.gz \
    demo_sample \
    "$GENOME_SNP_TRAN_DIR" \
    4 \
    rtea_results/demo/output \
    hg38
```

### BAM mode (alternative)

```bash
bash rnatea_pipeline_from_bam \
    rtea_results/demo/data/demo.bam \
    demo_sample \
    "$GENOME_SNP_TRAN_DIR" \
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

A successful run produces no differences (or only minor floating-point variations).

Quick column-count check:

```bash
awk -F'\t' 'NR==1{print NF" columns"}' \
    rtea_results/demo/output/rtea/demo_sample.rtea.txt
# Expected: 39 columns
```

---

## Step 5 – Troubleshooting

| Problem | Solution |
|:--------|:---------|
| `400 UserProjectMissing` when downloading | Provide `--billing-project` to `gcloud storage cp`. See [docs/gcs_requester_pays.md](../../docs/gcs_requester_pays.md). |
| `gcloud: command not found` | Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install |
| Output file not found after run | Check that `GENOME_SNP_TRAN_DIR` points to a valid HISAT2 index directory. |
| Column count mismatch | Ensure you are using the expected rTea version; check `run_demo.sh` for the pipeline entry point. |
| Checksum mismatch | Re-download the file; the transfer may have been corrupted. |

For more help see [docs/troubleshooting.md](../../docs/troubleshooting.md).

---

## About rTea-results

The demo input data and expected output are adapted from the
[rTea-results](https://gitlab.aleelab.net/junseokpark/rTea-results) repository,
which hosts the full pan-cancer analysis results described in the paper:

> *Pan-cancer analysis reveals multifaceted roles of retrotransposon-fusion RNAs*
> ([bioRxiv 2023.10.16.562422](https://www.biorxiv.org/content/10.1101/2023.10.16.562422v1.abstract))

Large data files (raw FASTQ/BAM) are **not** included here and must be downloaded from GCS as described in Step 1.
