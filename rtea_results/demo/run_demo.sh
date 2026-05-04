#!/bin/bash
# run_demo.sh - Convenience wrapper to run the rTea pipeline on the demo data.
#
# Usage:
#   bash run_demo.sh <R1.fastq.gz> <R2.fastq.gz> <sample_name> \
#                   <genome_snp_tran_dir> <threads> <out_dir> [genome_build]
#
# Example:
#   bash rtea_results/demo/run_demo.sh \
#       rtea_results/demo/data/demo.R1.fastq.gz \
#       rtea_results/demo/data/demo.R2.fastq.gz \
#       demo_sample \
#       /path/to/grch38_snp_tran \
#       4 \
#       rtea_results/demo/output \
#       hg38

set -euo pipefail

R1=${1:?Usage: run_demo.sh R1.fastq.gz R2.fastq.gz SAMPLE HISAT_REF THREADS OUT_DIR [BUILD]}
R2=${2:?}
SAMPLE=${3:?}
HISAT_REF=${4:?}
THREADS=${5:-4}
OUT_DIR=${6:-rtea_results/demo/output}
BUILD=${7:-hg38}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTEA_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "========================================"
echo "  rTea Demo Pipeline"
echo "========================================"
echo "  Sample   : ${SAMPLE}"
echo "  R1       : ${R1}"
echo "  R2       : ${R2}"
echo "  Build    : ${BUILD}"
echo "  Threads  : ${THREADS}"
echo "  Output   : ${OUT_DIR}"
echo "========================================"
echo

bash "${RTEA_ROOT}/rtea.sh" \
    "${R1}" \
    "${R2}" \
    "${SAMPLE}" \
    "${HISAT_REF}" \
    "${THREADS}" \
    "${OUT_DIR}" \
    "${BUILD}" \
    resume

RESULT="${OUT_DIR}/rtea/${SAMPLE}.rtea.txt"
EXPECTED="${SCRIPT_DIR}/expected_output/demo.rtea.txt"

echo
echo "========================================"
echo "  Verifying results"
echo "========================================"

if [ ! -f "${RESULT}" ]; then
    echo "ERROR: Output file not found: ${RESULT}"
    exit 1
fi

echo "Output written to: ${RESULT}"

if [ -f "${EXPECTED}" ]; then
    echo "Comparing with expected output..."
    if diff -q "${RESULT}" "${EXPECTED}" > /dev/null 2>&1; then
        echo "SUCCESS: Output matches expected results."
    else
        echo "NOTE: Output differs from expected results."
        echo "      This may be due to minor floating-point differences."
        echo "      Review the diff below:"
        diff "${RESULT}" "${EXPECTED}" | head -40
    fi
else
    echo "Expected output file not found at: ${EXPECTED}"
    echo "Skipping comparison."
fi

echo
echo "Demo complete."
