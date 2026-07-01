#!/usr/bin/env bash
# Download rTea demo FASTQ/BAM files from a GCS Requester Pays bucket.
set -euo pipefail

BILLING_PROJECT=""
BUCKET=""
DEST="rtea_results/demo/data"
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: download_demo_data.sh --billing-project PROJECT_ID --bucket gs://BUCKET [--dest rtea_results/demo/data] [--dry-run]

Downloads rTea demo FASTQ/BAM files from a GCS Requester Pays bucket.

Required:
  --billing-project  Google Cloud project ID to bill for request/network charges
  --bucket           GCS bucket or prefix URI (e.g. gs://my-rtea-bucket/demo)

Optional:
  --dest             Local destination directory (default: rtea_results/demo/data)
  --dry-run          Print commands without executing them
  -h, --help         Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --billing-project) BILLING_PROJECT="$2"; shift 2 ;;
    --bucket)          BUCKET="$2"; shift 2 ;;
    --dest)            DEST="$2"; shift 2 ;;
    --dry-run)         DRY_RUN=true; shift ;;
    -h|--help)         usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$BILLING_PROJECT" ]]; then
  echo "ERROR: --billing-project is required." >&2
  echo "       Provide your Google Cloud project ID (e.g. my-gcp-project-123)." >&2
  usage; exit 1
fi

if [[ -z "$BUCKET" ]]; then
  echo "ERROR: --bucket is required." >&2
  echo "       Example: gs://<RTEA_DEMO_BUCKET>/demo" >&2
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

# Strip trailing slash from bucket
BUCKET="${BUCKET%/}"

echo "Downloading rTea demo data"
echo "  Billing project : $BILLING_PROJECT"
echo "  GCS source      : $BUCKET"
echo "  Local dest      : $DEST"
[[ "$DRY_RUN" == true ]] && echo "  Mode            : DRY-RUN"
echo

run mkdir -p "$DEST"

for FILE in demo.R1.fastq.gz demo.R2.fastq.gz; do
  echo "Downloading $FILE ..."
  run gcloud storage cp "$BUCKET/fastq/$FILE" "$DEST/$FILE" \
      --billing-project="$BILLING_PROJECT"
done

echo "Downloading demo.bam (optional) ..."
run gcloud storage cp "$BUCKET/bam/demo.bam" "$DEST/demo.bam" \
    --billing-project="$BILLING_PROJECT" || echo "  WARNING: demo.bam not found — skipping (only needed for BAM-mode demo)."

echo
echo "Done. Files written to: $DEST"
echo "Next: verify checksums if rtea_results/demo/checksums.sha256 exists:"
echo "  sha256sum -c rtea_results/demo/checksums.sha256"
