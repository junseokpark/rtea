[![ubuntu](https://img.shields.io/badge/ubuntu-18.04_LTS-E95420?style=flat&logo=ubuntu)](https://releases.ubuntu.com/18.04/)
[![R](https://img.shields.io/badge/R-v3.6.3-3776AB?style=flat&logo=R&logoColor=276DC3)](https://cran.r-project.org/bin/windows/base/old/3.6.3/)
[![Docker](https://img.shields.io/badge/Docker-Community_20.10.11-2496ED?style=flat&logo=docker)](https://docs.docker.com/engine/release-notes/20.10/)
[![GCP](https://img.shields.io/badge/Google%20Cloud-kubernetes-4285F4?style=flat&logo=googlecloud)](https://cloud.google.com/?hl=en)
[![bioRxiv](https://img.shields.io/badge/bioRxiv-2023.10.16.562422-E2001A?style=flat&logo=internetarchive)](https://www.biorxiv.org/content/10.1101/2023.10.16.562422v1.abstract)

# ``rTea`` (RNA Transposable Element Analyzer)

``rTea`` is a computational method to detect transposon-fusion RNA.
![rTea](images/ToolImage.png "``rTea``")

* Citation:&nbsp;[Pan-cancer analysis reveals multifaceted roles of retrotransposon-fusion RNAs](https://www.biorxiv.org/content/10.1101/2023.10.16.562422v1.abstract)
* Manual:&nbsp;https://rtea.readthedocs.io/

---

# Overview
We developed ``rTea`` to detect TE-fusion transcripts from short-read RNA-seq data. We utilized multiple features from aligned reads, such as base quality of clipped sequences, percentage of multi-mapped reads, and matching score of reads to TE sequences to filter out false positives caused by nonspecifically mapped reads.

# Demo and result files

A hands-on demo is available in the [`rtea_results/demo/`](rtea_results/demo/) directory of this repository.
It lets you run ``rTea`` on a small test sample and verify the output against the provided expected results.

The demo materials are adapted from the external
[rTea-results](https://gitlab.aleelab.net/junseokpark/rTea-results) repository,
which hosts the full pan-cancer analysis results.
Large input data files (raw FASTQ/BAM) are **not** included in this repository due to their size.

## Large downloads and demo artifacts

Small scripts and expected outputs are version-controlled in this repository.
Large artifacts — raw FASTQ/BAM demo data, full result bundles, and optional Singularity images — are hosted on
**Google Cloud Storage (GCS) with Requester Pays** enabled.

See **[docs/gcs_requester_pays.md](docs/gcs_requester_pays.md)** for complete instructions on:
- What Requester Pays means and who pays for what
- Requirements for downloaders (`gcloud` CLI, a billing-enabled GCP project)
- Download commands for all artifact types
- Troubleshooting `400 UserProjectMissing` errors

See **[rtea_results/demo/README.md](rtea_results/demo/README.md)** for the full step-by-step demo workflow.

### Quick-start demo

1. **Download the demo input data** using GCS with your billing project:
   ```bash
   export RTEA_BILLING_PROJECT="your-google-cloud-project-id"
   export RTEA_DEMO_BUCKET="gs://rtea-public-data/rtea-results/demo"   # replace with actual bucket name

   bash scripts/download_demo_data.sh \
       --billing-project "$RTEA_BILLING_PROJECT" \
       --bucket "$RTEA_DEMO_BUCKET/demo"
   ```

2. **Set up the environment** – install all dependencies or use Docker/Singularity
   (see [Installation](#installation) below).
   ```bash
   export GENOME_SNP_TRAN_DIR=/path/to/grch38_snp_tran
   ```

3. **Run the demo pipeline:**
   ```bash
   bash rtea_results/demo/run_demo.sh \
       rtea_results/demo/data/demo.R1.fastq.gz \
       rtea_results/demo/data/demo.R2.fastq.gz \
       demo_sample \
       "$GENOME_SNP_TRAN_DIR" \
       4 \
       rtea_results/demo/output \
       hg38
   ```

4. **Verify the results** – compare your output with the expected output bundled in the repository:
   ```bash
   diff rtea_results/demo/output/rtea/demo_sample.rtea.txt \
        rtea_results/demo/expected_output/demo.rtea.txt
   ```
   A successful run produces no differences (or only minor floating-point variations).

For full details see [`rtea_results/demo/README.md`](rtea_results/demo/README.md).

# Installation
``rTea`` runs on a Linux-based operating system with certain prerequisite software. Here is a list of the software you should install before you start using ``rTea``.

* System software for Ubuntu 18.04 LTS
```bash
apt-get update && apt-get install -y \
    cmake \
    libxml2-dev \
    libcurl4-openssl-dev \
    libboost-dev \
    gawk \
    libssl-dev \
    pigz \
    htop \
    iputils-ping
```

* Before installing ``rTea``, you'll also need to set up the prerequisite software and environment variables (ENV).

  * [fastp]( http://opengene.org/fastp/fastp)
  * [HISAT2](http://opengene.org/fastp/fastp) (>= v2.1.0)
  * [samtools](https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2) (>= v1.9)
  * [HTSlib](https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2) (>= v1.9)
  * [Scallop](https://github.com/Kingsford-Group/scallop/releases/download/v0.10.4/scallop-0.10.4_linux_x86_64.tar.gz) (>= v0.10.4)
  * [bamtools](https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz) (>= v2.5.1)
  ```bash
  # Bamtools environment
  # BAMTOOL_HOME is installed directory
  PKG_CXXFLAGS="-I$BAMTOOL_HOME/include/bamtools"
  PKG_LIBS="-L$BAMTOOL_HOME/lib -lbamtools"
  ```
  * [bwa](https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2) (>=0.7.17)

* [R](https://cran.r-project.org/) (==3.6.2) and the necessary R software should be installed.
```R
R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')"
R -e "install.packages(c( \
       'magrittr', \
       'data.table', \
       'stringr', \
       'optparse', \
       'Rcpp', \
       'BiocManager' \
     ))"

R -e "BiocManager::install(c( \
       'GenomicAlignments', \
       'BSgenome.Hsapiens.UCSC.hg19', \
       'BSgenome.Hsapiens.UCSC.hg38', \
       'EnsDb.Hsapiens.v75', \
       'EnsDb.Hsapiens.v86' \
     ))"
```
* Download GRCh38 [genome_snp_tran](https://genome-idx.s3.amazonaws.com/hisat/grch38_snptran.tar.gz)


## Use Docker for Installation
Build a Docker file and run ``rTea`` in the Docker container.
```bash
DOCKER_BUILDKIT=1 docker build -t rtea .
```

## Use Singularity for Installation
After creating a Docker image for ``rTea``, convert it to Singularity.

```bash
docker save -o rTea.tar rtea:latest
singularity build rTea.simg docker-archive://rTea.tar
```

---

# Running ``rTea``
If you are using Docker as your runtime environment, run the Docker image to execute ``rTea``.
```bash
docker exec -it -v ${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran rtea bash
```
If the runtime environment is Singularity, execute the Singularity image to run ``rTea``.
```bash
singularity shell -B ${GENOME_SNP_TRAN_DIR}:/app/rTea/hg38/genome_snp_tran \
    rTea.simg
```

``rTea`` supports paired-end FASTQ files and a BAM file as input.
For FASTQ file input, use the following command:
```bash
rTea.sh \
        ${R1.fq}.gz \
        ${R2.fq}.gz \
        $SAMPLE_NAME \
        $GENOME_SNP_TRAN_DIR \
        $NUMBER_OF_CORES \
        $OUT_DIR \
        hg38 \
        resume
```
For BAM file input, please use the following command:
```bash
rnatea_pipeline_from_bam \
        ${BAM} + \
        $SAMPLE_NAME \
        $GENOME_SNP_TRAN_DIR \
        $NUMBER_OF_CORES \
        $OUT_DIR \
        hg38
```

# Output file
After running ``rTea``, the user can find a <SAMPLE_NAME>.rTea.txt file in the _rTea_ directory, which contains information about TEs and other supporting data.
|Column|Description|
|:---|:---|
|chr|Chromosome name|
|pos| Fusion breakpoint position on the chromosome
|ori| Fusion direction on the chromosome (f, TE\|gene; r, gene\|TE)
|class| TE class
|seq| Proximal portion of fusion sequence
|isPolyA| Whether it is a fusion with polyA sequence
|posRepFamily| Repeat masked repeat family on the breakpoint position
|posRep| Repeat masked repeat element on the breakpoint position
|TEfamily| TE family with highest alignment score when fusion sequence is aligned with consensus TE sequence
|TEscore| Alignment score of fusion sequence with the consensus TE sequence
|TEside| Fusion direction on the consensus TE sequence (5, TE\|gene; 3, gene\|TE)
|TEbreak| Fusion breakpoint position on the consensus TE sequence
|depth| Number of RNA-seq reads on the breakpoint position
|matchCnt| Number of fusion-supporting RNA-seq reads
|polyAcnt| Number of polyA reads
|baseQual| Median base quality of supporting reads
|lowMapQual| Number of supporting reads that have low mapping quality
|mateDist| Minimum distance of mate reads
|overhang| Distance of breakpoint from splice site
|gap| Length of nearby intron
|secondary| Proportion of supporting reads that are from secondary alignment
|nonspecificTE| Mean alignment score of supporting reads to consensus TE sequence
|r1pstrand| Proportion of supporting reads that are from positive strand of chromosome
|fusion_tx_id| Transcript ID of the fusion transcript
|tx_support_exon| Number of read fragments spanning exonic region of the fusion transcript ID
|tx_support_intron| Number of read gaps matching the fusion transcript ID
|strand| Strand of fusion transcript
|pos_type| Genomic region of breakpoint
|polyTE| Known non-reference TE on the breakpoint position
|hardstart| Start position of nearby reference genome where fusion sequence came from
|hardend| End position of nearby reference genome where fusion sequence came from
|hardTE| Repeat masked TE subfamily of nearby reference genome where fusion sequence came from
|hardDist| Distance from fusion breakpoint to nearby reference genome where fusion sequence came from
|fusion_type| Type of TE fusion
|fusion_tx_biotype| Biotype of fusion transcript
|fusion_gene_id| Gene ID of fusion transcript
|fusion_gene_name| Gene symbol of fusion transcript
|Filter| Filter reason of low confidence fusion

# Licenses
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC_BY--NC_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Contacts
[Junseok Park](mailto:junseok.park@childrens.harvard.edu) and 
[Boram Lee](mailto:boram.lee@samsung.com)
