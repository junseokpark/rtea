# ``rTea`` Results

This directory hosts supporting materials related to ``rTea`` analyses, including demo data and scripts.

## Contents

| Path | Description |
|:-----|:------------|
| `demo/` | Hands-on demo for running ``rTea`` on a small test sample and verifying expected output |

## Relationship to rTea-results

The materials here are adapted from the external
[rTea-results](https://gitlab.aleelab.net/junseokpark/rTea-results) repository,
which contains the full pan-cancer analysis results for the paper:

> *Pan-cancer analysis reveals multifaceted roles of retrotransposon-fusion RNAs*
> ([bioRxiv 2023.10.16.562422](https://www.biorxiv.org/content/10.1101/2023.10.16.562422v1.abstract))

## Large file downloads

**Large input data files** (raw FASTQ/BAM files, full result bundles, Singularity images) are **not** stored in this repository. They are hosted on Google Cloud Storage (GCS) using [Requester Pays](../docs/gcs_requester_pays.md).

See **[docs/gcs_requester_pays.md](../docs/gcs_requester_pays.md)** for complete download instructions, including how to set up `gcloud` and provide a billing project.

### Downloadable artifacts

| Artifact | GCS URI | Local destination | Notes |
|:---------|:--------|:-----------------|:------|
| Demo FASTQs | `gs://<RTEA_DEMO_BUCKET>/demo/fastq/` | `rtea_results/demo/data/` | Required for FASTQ demo |
| Demo BAM | `gs://<RTEA_DEMO_BUCKET>/demo/bam/demo.bam` | `rtea_results/demo/data/demo.bam` | Optional BAM-mode demo |
| Expected output | tracked in repo | `rtea_results/demo/expected_output/` | Used for validation |
| Singularity image | `gs://<RTEA_IMAGE_BUCKET>/singularity/rtea_latest.sif` | `images/rtea_latest.sif` | Optional container |
| rTea result bundle | `gs://<RTEA_RESULTS_BUCKET>/release/<VERSION>/` | user-selected | Full pan-cancer paper results |

> Replace `<RTEA_DEMO_BUCKET>`, `<RTEA_RESULTS_BUCKET>`, and `<RTEA_IMAGE_BUCKET>` with the actual bucket names.
> Copy `config/gcs_artifacts.example.yaml` to `config/gcs_artifacts.yaml` and fill in the values.

### Quick download commands

```bash
# Set your billing project
export RTEA_BILLING_PROJECT="your-google-cloud-project-id"

# Download demo data
bash scripts/download_demo_data.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "gs://<RTEA_DEMO_BUCKET>/demo"

# Download a result bundle
bash scripts/download_rtea_results.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "gs://<RTEA_RESULTS_BUCKET>" \
    --version v1.0.0

# Download Singularity image
bash scripts/download_singularity_image.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "gs://<RTEA_IMAGE_BUCKET>"
```

See [`demo/README.md`](demo/README.md) for the full demo workflow.
