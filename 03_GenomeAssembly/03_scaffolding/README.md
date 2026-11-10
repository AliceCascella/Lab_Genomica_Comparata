
# Reference-Based Genome Scaffolding - Anopheles stephensi

## Overview

This step describes the reference-based correction and scaffolding of the *Anopheles stephensi* genome assembly using **RagTag**.

The aim was to improve assembly contiguity by aligning the decontaminated draft assembly against a reference genome, correcting potential misassemblies, and ordering and orienting contigs into larger scaffolds.

## 1. Input Data

The following files were used in the original workflow:

- `Anoste_noContaminants.fasta`: Decontaminated draft genome assembly. 
- `GCF_013141755.1_UCI_ANSTEP_V1.0_genomic.fna`: Reference genome of *Anopheles stephensi*.

## 2. Reference-Based Assembly Correction

RagTag's `correct` module was used to identify potential misassemblies by aligning the draft genome against the reference assembly.

The general command structure is:
```bash
ragtag.py correct -t 20 <REFERENCE_GENOME> <DRAFT_GENOME>
```
This is an illustrative command following the course workflow, not a verified record of the exact RagTag invocation.

The available alignment log confirms that minimap2 v2.28-r1209 was run with the `asm5` preset and 50 threads:

```bash
minimap2 -x asm5 -t 50 GCF_013141755.1_UCI_ANSTEP_V1.0_genomic.fna Anoste_noContaminants.fasta
```

The corrected assembly was saved as: 

`ragtag_output/ragtag.correct.fasta`

## 3. Reference-Based Scaffolding

The corrected assembly was subsequently used as input for RagTag's `scaffold` module.

The general command structure is: 

```bash
ragtag.py scaffold -C -t 20 -o <OUTPUT_DIR> <REFERENCE_GENOME> <CORRECTED_DRAFT_GENOME>
```

This is an illustrative command following the course workflow. The exact RagTag options used to generate the provided results have not been independently verified.

The available alignment log records:

```bash
minimap2 -x asm5 -t 50 GCF_013141755.1_UCI_ANSTEP_V1.0_genomic.fna ragtag_output/ragtag.correct.fasta
```

The resulting scaffolded assembly was saved as:

`ragtag_output/ragtag.scaffold.fasta`

## 4. Assembly Statistics

Assembly statistics were obtained from the precomputed `.stats` files.

| Metric | Corrected assembly | Scaffolded assembly | Final chromosome assembly |
| ---|---:|---:|---:|
| Total length (bp) | 217,662,927 | 217,737,827 | 202,147,033 |
| Number of sequences | 883 | 134 | 3 |
| Largest sequence (bp) | 32,951,834 | 91,839,414 | 91,839,414 |
| N50 (bp) | 24,424,754 | 88,252,832 | 88,252,832 |
| N90 (bp) | 883,435 | 22,054,787 | 22,054,787 | 
| Number of Ns | 0 | 74,900 | 6,700 |
| Number of gaps | 0 | 749 | 67 |

Reference-based scaffolding substantially improved assembly contiguity, reducing the number of sequences from 883 to 134 and increasing N50 from approximately 24.42 Mb to 88.25 Mb.

## 5. Final Chromosome Assembly

The final assembly, `Anoste_chr.fasta`, contains three chromosome-associated sequences:

```text
NC_050201.1_RagTag
NC_050202.1_RagTag
NC_050203.1_RagTag
```

These three sequences were confirmed to be identical at the nucleotide level to their corresponding sequences in `ragtag.scaffold.fasta`, using sequence-specific MD5 comparisons.

The final assembly therefore represents a subset of the scaffolded assembly containing these three sequences, excluding the remaining scaffolds.

The final assembly has a total length of approximately 202.15 Mb and an N50 of approximately 88.25 Mb.

## 6. Output Files

The directory contains:

- `Anoste_chr.stats`: Statistics for the final three-sequence assembly.
- `ragtag_output/Anoste_corrected.stats`: Corrected assembly statistics.
- `ragtag_output/Anoste_scaffold.stats`: Scaffolded assembly statistics.
- `ragtag_output/ragtag.correct.agp`: Assembly correction information.
- `ragtag_output/ragtag.scaffold.agp`: Scaffold structure and component placement.
- `ragtag_output/*.asm.paf`: Reference alignment files.
- `ragtag_output/*.log`: Minimap2 alignment logs.
- `ragtag_output/ragtag.scaffold.confidence.txt`: Scaffolding confidence information.
- Additional small indexing and diagnostic files.


