# Results

## Result files in this repository

Small result files are version-controlled under `rtea_results/`.

| Path | Description |
|:-----|:------------|
| `rtea_results/demo/expected_output/demo.rtea.txt` | Expected output for the demo run |

## Full pan-cancer result bundles

Full result files from the pan-cancer analysis are hosted on GCS.
See [GCS Requester Pays](gcs_requester_pays.md) for download instructions.

```bash
bash scripts/download_rtea_results.sh \
    --billing-project "$RTEA_BILLING_PROJECT" \
    --bucket "gs://rtea-public-data/rtea-results/filteredResults" \
    --version v1.0.0
```

## Result interpretation

See [Input and output](input_output.md) for a full description of output columns.

Key columns for filtering:

- **Filter**: empty = high-confidence call; populated = reason for low confidence
- **fusion_type**: type of TE fusion event
- **matchCnt**: number of fusion-supporting reads (higher = more evidence)
- **depth**: total read depth at breakpoint
