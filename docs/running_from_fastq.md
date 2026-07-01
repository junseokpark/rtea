# Running from FASTQ

Use the FASTQ-mode pipeline when starting from raw paired-end RNA-seq reads.

## Docker

```bash
docker exec -it \
    -v "${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran" \
    rtea bash
```

Inside the container:

```bash
rTea.sh \
    "${R1}.gz" \
    "${R2}.gz" \
    "$SAMPLE_NAME" \
    "$GENOME_SNP_TRAN_DIR" \
    "$NUMBER_OF_CORES" \
    "$OUT_DIR" \
    hg38 \
    resume
```

## Singularity

```bash
singularity shell \
    -B "${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran" \
    images/rtea_latest.sif
```

Inside the container, run the same `rTea.sh` command as above.

## Direct (no container)

```bash
bash rtea.sh \
    "${R1}.gz" \
    "${R2}.gz" \
    "$SAMPLE_NAME" \
    "$GENOME_SNP_TRAN_DIR" \
    "$NUMBER_OF_CORES" \
    "$OUT_DIR" \
    hg38 \
    resume
```

## Parameters

| Position | Variable | Description |
|:---------|:---------|:------------|
| 1 | R1.fastq.gz | Gzipped R1 FASTQ |
| 2 | R2.fastq.gz | Gzipped R2 FASTQ |
| 3 | SAMPLE_NAME | Output prefix |
| 4 | GENOME_SNP_TRAN_DIR | Path to HISAT2 genome_snp_tran index |
| 5 | NUMBER_OF_CORES | CPU threads to use |
| 6 | OUT_DIR | Output directory |
| 7 | genome build | `hg38` or `hg19` |
| 8 | resume | `resume` to skip completed steps |
