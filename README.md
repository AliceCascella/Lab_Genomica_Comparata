# Comparative Genomics Laboratory

This repository contains the comparative genomics pipeline developed for the Comparative Genomics course at the University of Bologna (UniBo).

The project focuses on mosquitoes (Culicidae), a family of insects that includes several species of medical importance due to their role as vectors of pathogens responsible for diseases such as malaria.

The workflow covers genome quality assessment, genome assembly and annotation, orthology inference, phylogenomic reconstruction, divergence time estimation, gene family evolution, and functional annotation.

The repository contains:

- [00_data](00_data): Input datasets and reference files used throughout the comparative genomics analyses.
- [02_KmerBased_GenomeSurvey](02_KmerBased_GenomeSurvey): Genome survey based on k-mer analysis to assess sequencing data and estimate genome characteristics.
- [03_GenomeAssembly](03_GenomeAssembly): Workflow for de novo genome assembly, including assembly evaluation and scaffolding.
- [04_GenomeAnnotation](04_GenomeAnnotation): Genome annotation workflow for *Anopheles stephensi*, including repetitive element identification, MAKER annotation, and gene prediction.
- [05_OG.Inference_Phylogenomic](05_OG.Inference_Phylogenomic): Orthology inference, orthogroup identification, and phylogenomic reconstruction of the species tree.
- [06_DivergenceTime_Estimation](06_DivergenceTime_Estimation): Estimation of evolutionary divergence times based on the reconstructed species phylogeny.
- [07_GeneFamily_Evolution](07_GeneFamily_Evolution): Analysis of gene family expansion and contraction during mosquito evolution.
- [08_GeneAnnotation_Functional_Enrichment](08_GeneAnnotation_Functional_Enrichment): Functional annotation and enrichment analyses to investigate the biological functions and evolutionary patterns of gene families.

Each directory documents the corresponding analysis steps and contains the available scripts, input files, results, and README documentation.
