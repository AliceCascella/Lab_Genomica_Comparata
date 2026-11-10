
# Genome Assembly - Anopheles stephensi

## Overview

This section describes the genome assembly and refinement workflow for *Anopheles stephensi*, including initial assembly, polishing, contamination assessment and removal, and reference-based scaffolding.

The workflow consists of four main steps:

1. `00_assembly_raw`: Initial genome assembly and quality assessment
2. `01_polishing`: Assembly polishing and quality evaluation.
3. `02_contaminans`: Contamination assessment and removal.
4. `03_scaffolding`: Reference-based correction and scaffolding using RagTag.

## 1. Raw Genome Assembly

**Directory:** `00_assembly_raw/`

The initial genome assembly is stored in `Anoste_raw.fasta`.

Assembly quality was evaluated using assembly statistics and BUSCO.

**Assembly statistics:**

- Total assembly length: 224,118,468 bp.
- Number of contigs: 845.
- Largest contig: 32,930,212 bp.
- N50: 20,386,785 bp.
- N90: 748,623 bp.

**BUSCO assessment:**

BUSCO v6.0.0 was run using the `diptera_odb12` lineage dataset, containing 5,067 conserved orthologous groups.

- Complete BUSCOs: 96.0%.
- Single-copy BUSCOs: 95.2%.
- Duplicated BUSCOs: 0.7%.
- Fragmented BUSCOs: 0.6%.
- Missing BUSCOs: 3.5%.

## 2. Genome Polishing

**Directory:** `01_polishing/`

The initial assembly was polished to improve nucleotide sequence accuracy.

The resulting assembly is stored in `Anoste_pol.fasta`.

**Assembly statistics:**

- Total assembly length: 224,269,064 bp.
- Number of contigs: 845.
- Largest contig: 32,952,023 bp.
- N50: 20,402,433 bp.
- N90: 748,799 bp.

**BUSCO assessment:**

BUSCO v6.0.0 was run using the `diptera_odb12` lineage dataset.

- Complete BUSCOs: 96.2%.
- Single-copy BUSCOs: 95.5%.
- Duplicated BUSCOs: 0.7%.
- Fragmented BUSCOs: 0.6%.
- Missing BUSCOs: 3.2%.

Compared with the raw assembly, polishing increased the number of complete BUSCOs from 4,863 to 4,874.

K-mer-based comparisons between sequencing reads and the polished assembly were also performed to assess assembly quality.

## 3. Contamination Assessment and Removal

**Directory:** `02_contaminans/`

Potential contamination was investigated using BlobToolKit outputs, including taxonomic classification and sequencing coverage information.

The resulting decontaminated assembly is stored in `Anoste.decontaminated.fasta`.

**Assembly statistics:**

- Total assembly length: 215,545,609 bp.
- Number of sequences: 621.
- Largest sequence: 32,951,834 bp.
- N50: 24,424,754 bp.
- N90: 1,318,033 bp.

Compared with the polished assembly, the decontaminated assembly contains 224 fewer sequences and approximately 8.72 Mb less sequence data.

## 4. Reference-Based Genome Scaffolding

**Directory:** `03_scaffolding/`

Reference-based correction and scaffolding were performed using RagTag and an available *Anopheles stephensi* reference genome.

The final assembly is stored as `Anoste_chr.fasta` and contains three chromosome-associated sequences.

**Final assembly statistics:**

- Total assembly length: 202,147,033 bp.
- Number of sequences: 3.
- Largest sequence: 91,839,414 bp.
- N50: 88,252,832 bp.
- N90: 22,054,787 bp.

The final assembly contains the following sequence identifiers:

- `NC_050201.1_RagTag`
- `NC_050202.1_RagTag`
- `NC_050203.1_RagTag`

The three sequences were verified to match their corresponding sequences in the precomputed RagTag scaffolded assembly.

For additional details on the correction and scaffolding workflow, see [03_scaffolding/README.md](03_scaffolding/README.md).

## 5. Assembly Statistics Summary

| Metric | Raw | Polished | Decontaminated | Final |
|---|---:|---:|---:|---:|
| Total length (Mb) | 224.12 | 224.27 | 215.55 | 202.15 |
| Number of sequences | 845 | 845 | 621 | 3 |
| Largest sequence (Mb) | 32.93 | 32.95 | 32.95 | 91.84 |
| N50 (Mb) | 20.39 | 20.40 | 24.42 | 88.25 |
| N90 (Mb) | 0.75 | 0.75 | 1.32 | 22.05 |

The initial assembly showed high BUSCO completeness, which increased slightly after polishing.

Contamination removal reduced the total assembly length and number of sequences, while reference-based scaffolding produced a final assembly containing three chromosome-associated sequences.

## 6. Main Output Files

- `00_assembly_raw/Anoste_raw.fasta`: Initial genome assembly.
- `01_polishing/Anoste_pol.fasta`: Polished genome assembly.
- `02_contaminans/Anoste.decontaminated.fasta`: Decontaminated genome assembly.
- `03_scaffolding/Anoste_chr.fasta`: Final three-sequence assembly.

Additional quality assessment files, BUSCO reports, k-mer analysis results, BlobToolKit outputs, and RagTag supporting files are stored in their respective directories.

Large FASTA files are excluded from Git tracking.
