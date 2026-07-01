# GCS Requester Pays downloads

Large rTea artifacts — demo FASTQ/BAM files, full result bundles, and Singularity images — are hosted on
Google Cloud Storage (GCS) with **Requester Pays** enabled.

## What Requester Pays means

With Requester Pays, the **requester** (downloader) provides a billing project and pays for request and
network egress charges. Storage charges remain billed to the project that owns the bucket.
This allows the rTea team to share large data publicly without incurring unbounded egress costs.

## Requirements for downloaders

1. **`gcloud` CLI** installed and initialized. Install from https://cloud.google.com/sdk/docs/install
2. **A Google Cloud project** with billing enabled and in good standing.
3. **Permission** to use the billing project — typically the Service Usage Consumer role
   (`serviceusage.services.use`).
4. **Cloud Storage read permissions** on the objects (if not public).

## Authentication

```bash
# Install gcloud if not present
# https://cloud.google.com/sdk/docs/install

# Authenticate
gcloud auth login

# Set your default project (optional but recommended)
gcloud config set project your-google-cloud-project-id
```

## Download commands

### Single file

```bash
gcloud storage cp gs://BUCKET_NAME/OBJECT_NAME SAVE_TO_LOCATION \
    --billing-project=PROJECT_IDENTIFIER
```

### Recursive copy

```bash
gcloud storage rsync -r gs://BUCKET_NAME/PREFIX LOCAL_DIR \
    --billing-project=PROJECT_IDENTIFIER
```

### Legacy gsutil (secondary option)

For users who still use gsutil:

```bash
gsutil -u PROJECT_IDENTIFIER cp gs://BUCKET_NAME/OBJECT_NAME SAVE_TO_LOCATION
```

> Prefer `gcloud storage` for new workflows; it is faster and better maintained.

## Download rTea artifacts

### Demo FASTQ files

```bash
export RTEA_BILLING_PROJECT="your-google-cloud-project-id"
export RTEA_DEMO_BUCKET="gs://<RTEA_DEMO_BUCKET>"

mkdir -p rtea_results/demo/data

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

### Demo BAM file (optional)

```bash
gcloud storage cp "$RTEA_DEMO_BUCKET/demo/bam/demo.bam" \
    rtea_results/demo/data/demo.bam \
    --billing-project="$RTEA_BILLING_PROJECT"
```

### Result bundles

```bash
export RTEA_RESULTS_BUCKET="gs://<RTEA_RESULTS_BUCKET>"

bash scripts/download_rtea_results.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_RESULTS_BUCKET" \
    --version v1.0.0
```

### Singularity images

```bash
export RTEA_IMAGE_BUCKET="gs://<RTEA_IMAGE_BUCKET>"

bash scripts/download_singularity_image.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_IMAGE_BUCKET"
# Downloads images/rtea_latest.sif
```

## Troubleshooting

### `400 UserProjectMissing`

You did not provide a billing project. Always pass `--billing-project=PROJECT_IDENTIFIER` to
`gcloud storage` commands, or `-u PROJECT_IDENTIFIER` to gsutil.

### `403 Permission denied`

Your account does not have permission to use the billing project. Ensure you have the
Service Usage Consumer role (`serviceusage.services.use`) on the billing project.

### `gcloud: command not found`

Install the Google Cloud SDK: https://cloud.google.com/sdk/docs/install

## For bucket owners: enabling Requester Pays

```bash
# Enable Requester Pays on a bucket
gcloud storage buckets update gs://BUCKET_NAME --requester-pays

# Verify status
gcloud storage buckets describe gs://BUCKET_NAME \
    --format="default(requester_pays)"
```

## Security notes

- Never commit credentials, service-account keys, or private billing project IDs to this repository.
- Never commit signed URLs unless they are intentionally public and time-limited.
- Add `config/gcs_artifacts.yaml` (your local filled-in config) to `.gitignore`.
- Downloaded large files (`rtea_results/demo/data/`, `images/*.sif`) are already listed in `.gitignore`.
