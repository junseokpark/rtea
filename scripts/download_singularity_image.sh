#!/usr/bin/env bash
# Download a prebuilt rTea Singularity image from a GCS Requester Pays bucket.
set -euo pipefail

BILLING_PROJECT=""
BUCKET=""
IMAGE_TAG="rtea_latest.sif"
DEST="images"
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: download_singularity_image.sh --billing-project PROJECT_ID --bucket gs://BUCKET [--image-tag TAG] [--dest DIR] [--dry-run]

Downloads a prebuilt rTea Singularity (.sif) image from a GCS Requester Pays bucket.

Required:
  --billing-project  Google Cloud project ID to bill for request/network charges
  --bucket           GCS image bucket URI (e.g. gs://my-rtea-images-bucket)

Optional:
  --image-tag        Singularity image filename to download (default: rtea_latest.sif)
                     Available naming conventions:
                       rtea_latest.sif
                       rtea_<version>.sif         (e.g. rtea_1.0.0.sif)
                       rtea_<git-short-sha>.sif   (e.g. rtea_88361ea.sif)
  --dest             Local directory to save the image (default: images/)
  --dry-run          Print commands without executing them
  -h, --help         Show this help message

Examples:
  download_singularity_image.sh \
      --billing-project my-gcp-project \
      --bucket gs://<RTEA_IMAGE_BUCKET> \
      --image-tag rtea_latest.sif

  download_singularity_image.sh \
      --billing-project my-gcp-project \
      --bucket gs://<RTEA_IMAGE_BUCKET> \
      --image-tag rtea_1.0.0.sif \
      --dest /scratch/images
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --billing-project) BILLING_PROJECT="$2"; shift 2 ;;
    --bucket)          BUCKET="$2"; shift 2 ;;
    --image-tag)       IMAGE_TAG="$2"; shift 2 ;;
    --dest)            DEST="$2"; shift 2 ;;
    --dry-run)         DRY_RUN=true; shift ;;
    -h|--help)         usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$BILLING_PROJECT" ]]; then
  echo "ERROR: --billing-project is required." >&2
  usage; exit 1
fi

if [[ -z "$BUCKET" ]]; then
  echo "ERROR: --bucket is required." >&2
  echo "       Example: gs://<RTEA_IMAGE_BUCKET>" >&2
  usage; exit 1
fi

if ! command -v gcloud &>/dev/null; then
  echo "ERROR: gcloud CLI not found. Install it from https://cloud.google.com/sdk/docs/install" >&2
  exit 1
fi

run() {
  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] $*"
  else
    "$@"
  fi
}

BUCKET="${BUCKET%/}"
SOURCE_URI="$BUCKET/singularity/$IMAGE_TAG"
LOCAL_PATH="$DEST/$IMAGE_TAG"

echo "Downloading rTea Singularity image"
echo "  Billing project : $BILLING_PROJECT"
echo "  GCS source      : $SOURCE_URI"
echo "  Local dest      : $LOCAL_PATH"
[[ "$DRY_RUN" == true ]] && echo "  Mode            : DRY-RUN"
echo

run mkdir -p "$DEST"
run gcloud storage cp "$SOURCE_URI" "$LOCAL_PATH" \
    --billing-project="$BILLING_PROJECT"

echo
echo "Download complete: $LOCAL_PATH"

# Verify checksum if a .sha256 sidecar exists
CHECKSUM_FILE="${LOCAL_PATH}.sha256"
if [[ -f "$CHECKSUM_FILE" ]]; then
  echo "Verifying checksum ..."
  sha256sum -c "$CHECKSUM_FILE"
  echo "Checksum OK."
else
  echo "No checksum file found at $CHECKSUM_FILE — skipping verification."
  echo "To verify manually: sha256sum $LOCAL_PATH"
fi

echo
echo "To run rTea with this image:"
echo "  singularity exec $LOCAL_PATH bash rtea_results/demo/run_demo.sh \\"
echo "      rtea_results/demo/data/demo.R1.fastq.gz \\"
echo "      rtea_results/demo/data/demo.R2.fastq.gz \\"
echo "      demo_sample \\"
echo "      \"\$GENOME_SNP_TRAN_DIR\" \\"
echo "      4 \\"
echo "      rtea_results/demo/output \\"
echo "      hg38"
