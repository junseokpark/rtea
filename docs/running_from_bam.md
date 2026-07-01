# Running from BAM

Use the BAM-mode pipeline when you already have a sorted, indexed BAM file from a previous alignment run.

## Command

```bash
bash rnatea_pipeline_from_bam \
    "${BAM}" \
    "$SAMPLE_NAME" \
    "$GENOME_SNP_TRAN_DIR" \
    "$NUMBER_OF_CORES" \
    "$OUT_DIR" \
    hg38
```

## Parameters

| Position | Variable | Description |
|:---------|:---------|:------------|
| 1 | BAM | Sorted, indexed BAM file |
| 2 | SAMPLE_NAME | Output prefix |
| 3 | GENOME_SNP_TRAN_DIR | Path to HISAT2 genome_snp_tran index |
| 4 | NUMBER_OF_CORES | CPU threads to use |
| 5 | OUT_DIR | Output directory |
| 6 | genome build | `hg38` or `hg19` |

## Notes

- The BAM file must be sorted by coordinate and indexed (`.bai` sidecar present).
- Scallop transcript assembly is skipped in `rnatea_pipeline_noscallop_from_bam` — use that variant if Scallop is unavailable.
