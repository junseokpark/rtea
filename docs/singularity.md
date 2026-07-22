# Singularity

``rTea`` can be run inside a prebuilt Singularity container, which bundles all dependencies.

## Download a prebuilt image

Singularity images are hosted on GCS with Requester Pays. See [GCS Requester Pays](gcs_requester_pays.md) for setup.

```bash
export RTEA_BILLING_PROJECT="your-google-cloud-project-id"
export RTEA_IMAGE_BUCKET="gs://rtea-public-data/rtea-results/demo/singularity"

bash scripts/download_singularity_image.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "$RTEA_IMAGE_BUCKET"
# Downloads images/rtea_latest.sif
```

### Image naming conventions

| Filename | Meaning |
|:---------|:--------|
| `rtea_latest.sif` | Most recent stable release |
| `rtea_<version>.sif` | Specific release (e.g. `rtea_1.0.0.sif`) |
| `rtea_<git-short-sha>.sif` | Build pinned to a specific commit |

### Verify the image

```bash
sha256sum images/rtea_latest.sif
# Compare against the published checksum (if available)
```

## Build from Docker

If you prefer to build the image yourself:

```bash
# 1. Build Docker image
DOCKER_BUILDKIT=1 docker build -t rtea .

# 2. Export Docker image
docker save -o rTea.tar rtea:latest

# 3. Convert to Singularity
singularity build rTea.simg docker-archive://rTea.tar
```

## Run rTea with Singularity

### FASTQ mode

```bash
singularity exec \
    -B "${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran" \
    images/rtea_latest.sif \
    bash rtea_results/demo/run_demo.sh \
        rtea_results/demo/data/demo.R1.fastq.gz \
        rtea_results/demo/data/demo.R2.fastq.gz \
        demo_sample \
        "$GENOME_SNP_TRAN_DIR" \
        4 \
        rtea_results/demo/output \
        hg38
```

### Interactive shell

```bash
singularity shell \
    -B "${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran" \
    images/rtea_latest.sif
```
