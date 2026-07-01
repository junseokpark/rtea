#!/usr/bin/env bash
# Download rTea result bundles from a GCS Requester Pays bucket.
set -euo pipefail

BILLING_PROJECT=""
BUCKET=""
VERSION="latest"
DEST="."
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: download_rtea_results.sh --billing-project PROJECT_ID --bucket gs://BUCKET [--version VERSION] [--dest DIR] [--dry-run]

Downloads rTea result bundles (full or partial pan-cancer analysis) from a GCS Requester Pays bucket.

Required:
  --billing-project  Google Cloud project ID to bill for request/network charges
  --bucket           GCS results bucket URI (e.g. gs://my-rtea-results-bucket)

Optional:
  --version          Release version to download (default: latest)
  --dest             Local destination directory (default: current directory)
  --dry-run          Print commands without executing them
  -h, --help         Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --billing-project) BILLING_PROJECT="$2"; shift 2 ;;
    --bucket)          BUCKET="$2"; shift 2 ;;
    --version)         VERSION="$2"; shift 2 ;;
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
  echo "       Example: gs://<RTEA_RESULTS_BUCKET>" >&2
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
SOURCE_PREFIX="$BUCKET/release/$VERSION"
LOCAL_DEST="$DEST/rtea_results_$VERSION"

echo "Downloading rTea result bundle"
echo "  Billing project : $BILLING_PROJECT"
echo "  GCS source      : $SOURCE_PREFIX"
echo "  Local dest      : $LOCAL_DEST"
[[ "$DRY_RUN" == true ]] && echo "  Mode            : DRY-RUN"
echo

run mkdir -p "$LOCAL_DEST"
run gcloud storage rsync -r "$SOURCE_PREFIX" "$LOCAL_DEST" \
    --billing-project="$BILLING_PROJECT"

echo
echo "Done. Results written to: $LOCAL_DEST"
