# rTea Documentation Update Report

**Date:** 2026-06-30
**Branch:** `docs/rtea-manual-gcs-requester-pays`
**Remote branch inspected:** `copilot/add-demo-dataset-readme-update` @ `88361ea19307c92244fa9f31c4085805d4d62338`
**Local path updated:** `src/R/rtea/` (relative to the stea repo root)

---

## 1. Remote branch inspection

The remote branch `junseokpark/rtea:copilot/add-demo-dataset-readme-update` was fetched and inspected via a temporary git worktree at `/tmp/rtea_remote_branch`.

| Item | Value |
|:-----|:------|
| Remote commit hash | `88361ea19307c92244fa9f31c4085805d4d62338` |
| Commit message | "Add rtea_results/demo directory with demo files and update README" |
| Files only in remote (new) | `rtea_results/README.md`, `rtea_results/demo/README.md`, `rtea_results/demo/run_demo.sh`, `rtea_results/demo/expected_output/demo.rtea.txt` |
| Files changed in both | `README.md` |
| Files only in local | `.omc/` (OMC state, not synced) |

---

## 2. Local source update

A backup of the pre-sync local state was created at:
```
archive/rtea_local_backup_<timestamp>/
```

The following files were copied from the remote branch:

- `README.md` — updated (contained `[LINK]` placeholders, further updated below)
- `rtea_results/README.md` — new
- `rtea_results/demo/README.md` — new (contained `[LINK]` placeholders, further updated below)
- `rtea_results/demo/run_demo.sh` — new
- `rtea_results/demo/expected_output/demo.rtea.txt` — new

---

## 3. README changes summary

### `README.md`

- Replaced the "Demo and result files" quick-start section.
- Added new **"Large downloads and demo artifacts"** section.
- Removed all `[LINK]` placeholders — replaced with:
  - `gcloud storage cp ... --billing-project` commands
  - Reference to `scripts/download_demo_data.sh` convenience script
  - Link to `docs/gcs_requester_pays.md` canonical instructions
  - Link to `rtea_results/demo/README.md`

### `rtea_results/README.md`

- Added **"Large file downloads"** section explaining GCS Requester Pays.
- Added downloadable artifacts table with GCS URI placeholders (`<RTEA_DEMO_BUCKET>`, `<RTEA_RESULTS_BUCKET>`, `<RTEA_IMAGE_BUCKET>`).
- Added quick download commands using `scripts/download_*.sh`.
- Linked to canonical `docs/gcs_requester_pays.md`.

### `rtea_results/demo/README.md`

- Replaced `[LINK]` download instructions with GCS Requester Pays commands.
- Added `gcloud storage cp` as primary download method.
- Added `scripts/download_demo_data.sh` as convenience alternative.
- Added optional BAM download.
- Added optional Singularity image download.
- Added checksum verification step.
- Added troubleshooting table.
- Updated directory structure to include `checksums.sha256`.

---

## 4. GCS Requester Pays documentation

Canonical reusable page created at: `docs/gcs_requester_pays.md`

Covers:
- What Requester Pays means and who pays
- Requirements: `gcloud` CLI, billing-enabled GCP project, Service Usage Consumer role
- Authentication with `gcloud auth login`
- Download commands: `gcloud storage cp` (primary), `gsutil -u` (secondary/legacy)
- Recursive copy with `gcloud storage rsync`
- Per-artifact download examples (demo FASTQs, demo BAM, result bundles, Singularity images)
- Convenience script references
- Troubleshooting: `400 UserProjectMissing`, `403 Permission denied`, `gcloud not found`
- Bucket owner setup: `gcloud storage buckets update --requester-pays`
- Security notes: never commit credentials, billing IDs, or private signed URLs

---

## 5. Downloader scripts created

| Script | Purpose |
|:-------|:--------|
| `scripts/download_demo_data.sh` | Download demo FASTQ and BAM files |
| `scripts/download_rtea_results.sh` | Download full result bundles by version |
| `scripts/download_singularity_image.sh` | Download prebuilt Singularity `.sif` image |

All scripts:
- Use `set -euo pipefail`
- Accept `--billing-project`, `--bucket`, `--dest`, `--dry-run`, `-h/--help`
- Validate that `gcloud` is installed
- Validate required arguments and fail with clear error messages
- Use `gcloud storage cp` / `gcloud storage rsync` as primary CLI
- Never hard-code private billing project IDs
- Pass bash syntax check (`bash -n`)

---

## 6. GCS artifact config template

Created: `config/gcs_artifacts.example.yaml`

Contains placeholder URIs for all artifact types. Users copy this to `config/gcs_artifacts.yaml` (gitignored) and fill in real bucket names.

---

## 7. Documentation site structure

Sphinx + MyST Markdown documentation created at `docs/`:

| File | Description |
|:-----|:------------|
| `conf.py` | Sphinx configuration (myst-parser, sphinx-rtd-theme, sphinx-copybutton) |
| `index.md` | Navigation toctree |
| `overview.md` | Pipeline stages, supported TE classes and genome builds |
| `installation.md` | System deps, external tools, R packages, reference genome |
| `quickstart_demo.md` | 4-step demo quick start |
| `gcs_requester_pays.md` | Canonical GCS download instructions |
| `singularity.md` | Download and use prebuilt Singularity image; build from Docker |
| `input_output.md` | Input formats; full 39-column output table |
| `running_from_fastq.md` | FASTQ-mode pipeline commands |
| `running_from_bam.md` | BAM-mode pipeline commands |
| `results.md` | Result files in repo; full bundle download |
| `troubleshooting.md` | Common errors and solutions |
| `citation.md` | Citation, data availability, contact, licenses |
| `developer_notes.md` | Repo structure, doc build steps, GCS update guide, GitHub Pages workflow |

Additional files:
- `requirements-docs.txt` — Sphinx dependencies
- `.readthedocs.yaml` — Read the Docs v2 config

---

## 8. Local docs build result

```
sphinx-build -W -b html docs docs/_build/html
```

**Result: build succeeded. 13 pages, 0 warnings, 0 errors.**

Local test site command:

```bash
cd src/R/rtea
source .venv-docs/bin/activate
python -m http.server 8000 --directory docs/_build/html
```

Preview URL: http://localhost:8000

---

## 9. Deployment options

### Option A: Read the Docs (recommended)

1. Push the branch to GitHub.
2. Import the repository at readthedocs.org.
3. Select the `docs/rtea-manual-gcs-requester-pays` branch (or merge to main first).
4. The `.readthedocs.yaml` at the repo root controls the build automatically.

### Option B: GitHub Pages

1. Push branch to GitHub.
2. Enable Pages from GitHub Actions in repository Settings.
3. Create `.github/workflows/docs.yml` using the template in `docs/developer_notes.md`.
4. Run the workflow.

---

## 10. QA tests run

| Test | Result |
|:-----|:-------|
| `bash -n scripts/download_demo_data.sh` | PASS |
| `bash -n scripts/download_rtea_results.sh` | PASS |
| `bash -n scripts/download_singularity_image.sh` | PASS |
| `grep -rn "\[LINK\]" README.md rtea_results/ docs/ scripts/ config/` | PASS — no unresolved `[LINK]` placeholders |
| `sphinx-build -W -b html docs docs/_build/html` | PASS — build succeeded, 13 pages |
| shellcheck | NOT RUN — shellcheck not installed |
| Full demo run | NOT RUN — large demo data not available; no HISAT2 index present |
| Singularity image download | NOT RUN — GCS bucket names are placeholders |

---

## 11. Known limitations

1. **Real GCS bucket names unavailable.** All bucket URIs use `<RTEA_DEMO_BUCKET>`, `<RTEA_RESULTS_BUCKET>`, and `<RTEA_IMAGE_BUCKET>` placeholders. The repository owner must replace these once real buckets are provisioned.

2. **Full demo not run.** The demo requires large FASTQ/BAM input files and a HISAT2 genome index, neither of which was available in this environment. Only script syntax was validated.

3. **Singularity image not downloaded or built.** No real GCS bucket is configured.

4. **shellcheck not installed.** Bash scripts were validated with `bash -n` (syntax only) but not linted with shellcheck. Recommended: `brew install shellcheck` or `apt-get install shellcheck`.

5. **`checksums.sha256` not yet created.** This file is referenced in `rtea_results/demo/README.md` but must be created by the repository owner after uploading the demo data to GCS and computing checksums.

6. **Docs venv and `_build/` are gitignored** (by `.gitignore` update). Do not commit them.

---

## 12. Next steps for the repository owner

```bash
# 1. Assign real GCS bucket names and update placeholders
grep -rn "<RTEA_DEMO_BUCKET>\|<RTEA_RESULTS_BUCKET>\|<RTEA_IMAGE_BUCKET>" \
    README.md rtea_results/ docs/ scripts/ config/

# 2. Enable Requester Pays on each bucket
gcloud storage buckets update gs://YOUR_DEMO_BUCKET --requester-pays
gcloud storage buckets update gs://YOUR_RESULTS_BUCKET --requester-pays
gcloud storage buckets update gs://YOUR_IMAGE_BUCKET --requester-pays

# 3. Upload demo data to GCS
gcloud storage cp demo.R1.fastq.gz gs://YOUR_DEMO_BUCKET/demo/fastq/ --billing-project=YOUR_PROJECT
gcloud storage cp demo.R2.fastq.gz gs://YOUR_DEMO_BUCKET/demo/fastq/ --billing-project=YOUR_PROJECT
gcloud storage cp demo.bam gs://YOUR_DEMO_BUCKET/demo/bam/ --billing-project=YOUR_PROJECT

# 4. Generate and commit checksums
sha256sum rtea_results/demo/data/demo.R1.fastq.gz \
          rtea_results/demo/data/demo.R2.fastq.gz \
          rtea_results/demo/data/demo.bam \
    > rtea_results/demo/checksums.sha256
git add rtea_results/demo/checksums.sha256

# 5. Run the full demo to verify
bash rtea_results/demo/run_demo.sh \
    rtea_results/demo/data/demo.R1.fastq.gz \
    rtea_results/demo/data/demo.R2.fastq.gz \
    demo_sample \
    /path/to/grch38_snp_tran \
    4 \
    rtea_results/demo/output \
    hg38

# 6. Deploy documentation to Read the Docs or GitHub Pages
# See docs/developer_notes.md for step-by-step instructions

# 7. Merge the branch
git checkout main
git merge docs/rtea-manual-gcs-requester-pays
git push origin main
```
