# 05 - Orthology Inference and Phylogenomics

This step focuses on the identification of orthologous genes and the reconstruction of evolutionary relationships among six Diptera species.

The dataset includes four Anopheles species (Anoara, Anocol, Anodar, Anoste), Culex quinquefasciatus (Culqui), and Drosophila simulans (Drosim), used as the outgroup.

## Orthogroup inference - OrthoFinder

OrthoFinder was used to identify orthologous gene groups across the six species. The software distinguishes orthologs from paralogs by combining sequence similarity searches with gene-tree inference.

The analysis was performed using:

```bash 
orthofinder -t 8 -a 8 -f .
```

Results are stored in `OrthoFinder/Results_Dec01/`.

OrthoFinder identified:
- 10,967 orthogroups
- 73,812 genes assigned to orthogroups (87.8%)
- 7,194 orthogroups containing all six species
- 5,475 single-copy orthogroups

## Paralog filtering - DISCO

DISCO decomposes gene trees containing duplication events into smaller subtrees, allowing the identification of orthology-consistent groups for downstream analyses.

The DISCO-related results are organized into:

- `00_DISCO_preliminary_attempt/`: files from an earlier attempt.
- `01_DISCO/`: gene trees and decomposition results.
- `02_disco_OG/`: protein FASTA files reconstructed from decomposed gene trees.

The available results include 9,521 gene-tree files, 10,389 decomposed trees, and 10,389 corresponding protein FASTA files.

## Multiple sequence alignment - MAFFT

Multiple sequence alignment was performed using MAFFT to identify homologous amino-acid positions across species.

The following command was used to align the selected orthogroups:

```bash
for OG in *.faa; do
    mafft --auto --anysymbol "$OG" > ../../../03_aligned/${OG/.faa/_aligned.faa}
done
```

The resulting alignments are stored in:

`03_aligned/00_single_complete/`

## Alignment trimming - BMGE

The alignments were trimmed using BMGE (Block Mapping and Gathering with Entropy), which identifies and removes poorly aligned or phylogenetically unreliable regions based on entropy and substitution patterns.

The following command was used:

```bash
for OG in *.faa; do
    bmge -i "$OG" -t AA -m BLOSUM62 -e 0.5 -g 0.4 -of ../04_trimmed/${OG/_aligned.faa/_trimmed.faa}
done
```

The trimmed alignments are stored in:

`04_trimmed/00_single_complete/`

## Concatenation

The trimmed alignments were concatenated into a single amino-acid supermatrix for phylogenetic reconstruction.

The resulting file is:

`04_trimmed/00_single_complete/conc_species_tree.faa`

The concatenated alignment contains six taxa and 131,324 amino-acid positions.

## Species-tree reconstruction - IQ-TREE

The species tree was reconstructed using IQ-TREE, applying a maximum-likelihood approach to the concatenated amino-acid alignment.

The following command was used:

```bash
iqtree -m TESTNEW -b 100 -s conc_species_tree.faa --prefix species_tree -nt 9
```

The best-fitting substitution model selected according to BIC was:

`Q.INSECT+F+I+R3`

Results are stored in `05_tree/00_species/`.

The main output files include:
- `species_tree.treefile`: maximum-likelihood tree
- `species_tree.contree`: bootstrap consensus tree
- `species_tree.iqtree`: detailed analysis report
- `species_tree.log`: execution log
