# Installation

``rTea`` runs on Linux (Ubuntu 18.04 LTS recommended).

## System dependencies

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

## External tools

Install the following before running ``rTea``:

| Tool | Version | Link |
|:-----|:--------|:-----|
| fastp | any | http://opengene.org/fastp/fastp |
| HISAT2 | >= 2.1.0 | https://daehwankimlab.github.io/hisat2/ |
| samtools | >= 1.9 | https://github.com/samtools/samtools |
| HTSlib | >= 1.9 | https://github.com/samtools/htslib |
| Scallop | >= 0.10.4 | https://github.com/Kingsford-Group/scallop |
| bamtools | >= 2.5.1 | https://github.com/pezmaster31/bamtools |
| bwa | >= 0.7.17 | https://github.com/lh3/bwa |

Set bamtools environment variables:

```bash
PKG_CXXFLAGS="-I$BAMTOOL_HOME/include/bamtools"
PKG_LIBS="-L$BAMTOOL_HOME/lib -lbamtools"
```

## R dependencies

R version 3.6.2 is required.

```R
R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')"
R -e "install.packages(c('magrittr','data.table','stringr','optparse','Rcpp','BiocManager'))"
R -e "BiocManager::install(c('GenomicAlignments','BSgenome.Hsapiens.UCSC.hg19','BSgenome.Hsapiens.UCSC.hg38','EnsDb.Hsapiens.v75','EnsDb.Hsapiens.v86'))"
```

## Reference genome index

Download the GRCh38 genome_snp_tran HISAT2 index:

```bash
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_snptran.tar.gz
tar -xzf grch38_snptran.tar.gz
export GENOME_SNP_TRAN_DIR=/path/to/grch38_snp_tran
```

## Docker installation

```bash
DOCKER_BUILDKIT=1 docker build -t rtea .
```

## Singularity installation

See [Singularity](singularity.md) for details on using or building a Singularity image.
