# Quick-start demo

This page walks you through a complete demo run of ``rTea`` on a small test sample.

## Prerequisites

- ``rTea`` installed (see [Installation](installation.md))
- `gcloud` CLI installed and authenticated (see [GCS Requester Pays](gcs_requester_pays.md))
- A Google Cloud project with billing enabled

## Step 1 – Download demo data

```bash
export RTEA_BILLING_PROJECT="your-google-cloud-project-id"
export RTEA_DEMO_BUCKET="gs://rtea-public-data/rtea-results/demo"   # replace with actual bucket name

bash scripts/download_demo_data.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_DEMO_BUCKET/demo"
```

## Step 2 – Set environment

```bash
export GENOME_SNP_TRAN_DIR=/path/to/grch38_snp_tran
```

## Step 3 – Run the demo

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

## Step 4 – Verify output

```bash
diff rtea_results/demo/output/rtea/demo_sample.rtea.txt \
     rtea_results/demo/expected_output/demo.rtea.txt
```

A successful run produces no differences (or only minor floating-point variations).

For the full step-by-step guide see `rtea_results/demo/README.md` in the repository root.
