# Developer notes

## Repository structure

```
rtea/
├── ctea/                     # C++ soft-clip detection tool
├── docs/                     # Sphinx documentation source
├── rtea/                     # Core R pipeline scripts
├── rtea_results/             # Demo and result files
│   └── demo/
│       ├── expected_output/  # Version-controlled expected output
│       └── run_demo.sh       # Demo convenience script
├── scripts/                  # Download helper scripts
├── config/                   # Config templates (example files only)
├── ref/                      # Reference files (RDS, FASTA)
├── Dockerfile                # Docker build definition
├── rtea.sh                   # FASTQ-mode pipeline entry point
└── rnatea_pipeline_from_bam  # BAM-mode pipeline entry point
```

## Building the documentation

```bash
cd src/R/rtea
python -m venv .venv-docs
source .venv-docs/bin/activate
pip install -r requirements-docs.txt
sphinx-build -W -b html docs docs/_build/html
python -m http.server 8000 --directory docs/_build/html
```

Local preview: http://localhost:8000

## Adding a new documentation page

1. Create `docs/<page-name>.md`.
2. Add it to the `toctree` in `docs/index.md`.
3. Rebuild and verify locally.

## Updating GCS bucket names

When real GCS bucket names are assigned:

1. Update `config/gcs_artifacts.example.yaml` with the real URIs.
2. Replace `<RTEA_DEMO_BUCKET>`, `<RTEA_RESULTS_BUCKET>`, and `<RTEA_IMAGE_BUCKET>` placeholders in:
   - `README.md`
   - `rtea_results/README.md`
   - `rtea_results/demo/README.md`
   - `docs/gcs_requester_pays.md`
   - `docs/quickstart_demo.md`
3. Enable Requester Pays on the bucket: `gcloud storage buckets update gs://BUCKET --requester-pays`

## .gitignore guidance

These paths must remain gitignored:

```
config/gcs_artifacts.yaml    # filled-in local config with billing project ID
rtea_results/demo/data/      # downloaded large input files
rtea_results/demo/output/    # pipeline output during demo runs
images/*.sif                 # downloaded Singularity images
docs/_build/                 # Sphinx build output
.venv-docs/                  # docs virtual environment
```

## Deployment options

### Read the Docs

- Push branch to GitHub.
- Import the repository at readthedocs.org.
- Select the documentation branch.
- The `.readthedocs.yaml` at the repo root controls the build.

### GitHub Pages

- Push branch to GitHub.
- Enable Pages from GitHub Actions in repository Settings.
- Create `.github/workflows/docs.yml` (see `docs/developer_notes.md`).

### GitHub Pages workflow template

```yaml
name: Deploy docs
on:
  push:
    branches: [main]
    paths: ['docs/**', 'requirements-docs.txt']

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pages: write
      id-token: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -r requirements-docs.txt
      - run: sphinx-build -W -b html docs docs/_build/html
      - uses: actions/upload-pages-artifact@v3
        with:
          path: docs/_build/html
      - uses: actions/deploy-pages@v4
```
