# Input and output files

## Input

``rTea`` accepts either paired-end FASTQ files or a pre-aligned BAM file.

| Input | Description |
|:------|:------------|
| `R1.fastq.gz`, `R2.fastq.gz` | Paired-end FASTQ files (gzipped) |
| `sample.bam` | Pre-aligned BAM file (sorted and indexed) |

## Output

The main output is `<SAMPLE_NAME>.rTea.txt` written to `<OUT_DIR>/rtea/`.

### Output columns

| Column | Description |
|:-------|:------------|
| chr | Chromosome name |
| pos | Fusion breakpoint position |
| ori | Fusion direction (f = TE\|gene; r = gene\|TE) |
| class | TE class |
| seq | Proximal portion of fusion sequence |
| isPolyA | Whether it is a polyA fusion |
| posRepFamily | RepeatMasker family at breakpoint |
| posRep | RepeatMasker element at breakpoint |
| TEfamily | TE family with highest alignment score |
| TEscore | Alignment score to consensus TE |
| TEside | Fusion direction on consensus TE (5 = TE\|gene; 3 = gene\|TE) |
| TEbreak | Breakpoint position on consensus TE |
| depth | Total RNA-seq read depth at breakpoint |
| matchCnt | Fusion-supporting read count |
| polyAcnt | PolyA read count |
| baseQual | Median base quality of supporting reads |
| lowMapQual | Supporting reads with low mapping quality |
| mateDist | Minimum mate read distance |
| overhang | Distance from breakpoint to splice site |
| gap | Nearby intron length |
| secondary | Proportion of secondary-alignment supporting reads |
| nonspecificTE | Mean alignment score to consensus TE |
| r1pstrand | Proportion of supporting reads on positive strand |
| fusion_tx_id | Fusion transcript ID |
| tx_support_exon | Read fragments spanning fusion exon |
| tx_support_intron | Read gaps matching fusion transcript |
| strand | Fusion transcript strand |
| pos_type | Genomic region of breakpoint |
| polyTE | Known non-reference TE at breakpoint |
| hardstart | Start of nearby reference genome where fusion sequence maps |
| hardend | End of nearby reference genome where fusion sequence maps |
| hardTE | RepeatMasker TE subfamily of nearby reference |
| hardDist | Distance from breakpoint to nearby reference |
| fusion_type | Type of TE fusion |
| fusion_tx_biotype | Biotype of fusion transcript |
| fusion_gene_id | Gene ID of fusion transcript |
| fusion_gene_name | Gene symbol of fusion transcript |
| Filter | Filter label for low-confidence fusions |
