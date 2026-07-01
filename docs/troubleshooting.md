# Troubleshooting

## Download errors

### `400 UserProjectMissing`

You did not provide a billing project when accessing a Requester Pays bucket.

```bash
# Correct: always pass --billing-project
gcloud storage cp gs://BUCKET/FILE ./dest \
    --billing-project="your-google-cloud-project-id"
```

See [GCS Requester Pays](gcs_requester_pays.md) for full instructions.

### `403 Permission denied`

Your account does not have the Service Usage Consumer role on the billing project.
Contact your GCP project admin.

### `gcloud: command not found`

Install the Google Cloud SDK: https://cloud.google.com/sdk/docs/install

## Pipeline errors

### Output file not found after run

- Check that `GENOME_SNP_TRAN_DIR` points to a valid HISAT2 `genome_snp_tran` index.
- Ensure fastp, HISAT2, samtools, and Scallop are on your `PATH`.
- Check the log files in `<OUT_DIR>/logs/` for detailed error messages.

### Column count mismatch

Ensure you are using the expected rTea version. The demo expects 39 columns.

```bash
awk -F'\t' 'NR==1{print NF" columns"}' your_output.rtea.txt
```

### R package errors

Run the R installation commands from [Installation](installation.md) again.
Ensure R version 3.6.2 is active (`R --version`).

### Checksum mismatch after download

Re-download the file; the transfer may have been corrupted:

```bash
# Re-download
gcloud storage cp gs://BUCKET/FILE ./dest --billing-project=PROJECT

# Verify
sha256sum -c rtea_results/demo/checksums.sha256
```

## Docker / Singularity errors

### `GENOME_SNP_TRAN_DIR` not found inside container

Mount the directory explicitly:

```bash
singularity exec \
    -B "${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran" \
    images/rtea_latest.sif bash ...
```
