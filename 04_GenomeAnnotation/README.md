# Genome Annotation

Genome annotation is the process of identifying and describing functional elements within an assembled genome.

These features are typically represented in GFF3 format, which records their genomic coordinates and attributes.

## Repetitive Element Annotation

Repetitive elements can interfere with genome annotation, particularly with the identification of protein-coding regions. Therefore, these elements should be identified and masked before proceeding with gene prediction.

For accurate annotation, transcriptomic or proteomic evidence is recommended, as it provides additional information supporting gene structure prediction and, where available, alternative transcript isoforms.

The reference workflow uses **RepeatModeler** and **RepeatMasker** to identify and mask repetitive elements.

RepeatModeler identifies repetitive DNA families and generates a library of consensus sequences representing the repetitive elements present in the genome.

RepeatMasker subsequently uses this library to identify and mask repetitive regions in the genome assembly.

Due to its computational requirements, RepeatModeler was executed in advance by the instructor. The resulting repeat library was provided at: 
`/home/PERSONALE/mirko.martini3/Lab_CompGeno/00_practice/00_data/02_Annotation/Anoste_RepeatModeler_library.fa`

## First Round of Annotation (MAKER)

The software used for genome annotation is **MAKER**. To run correctly, MAKER requires several control and configuration files, which can be generated using the following command:

```bash
maker -CTL
```

This command generates the files required to run MAKER. Rather than relying exclusively on command-line arguments, MAKER reads the input files and parameters specified in its configuration files.

The main configuration file, `maker_opts.ctl`, contains the settings for the genome assembly, protein homology evidence, repeat masking, and gene prediction.

The following sections describe the configuration parameters used in the reference workflow.

### Genome and annotation evidence

```text
#-----Genome (these are always required)
genome=Anoste_pol.decontaminated #genome sequence (FASTA file or FASTA embedded in GFF3)
organism_type=eukaryotic #eukaryotic or prokaryotic; default is eukaryotic

#-----Re-annotation Using MAKER Derived GFF3
maker_gff= #MAKER-derived GFF3 file
est_pass=0 #use ESTs in maker_gff: 1 = yes, 0 = no
altest_pass=0 #use alternate organism ESTs in maker_gff
protein_pass=0 #use protein alignments in maker_gff
rm_pass=0 #use repeats in maker_gff
model_pass=0 #use gene models in maker_gff
pred_pass=0 #use ab initio predictions in maker_gff 
other_pass=0 #pass through other features in maker_gff

#-----EST Evidence
est= #ESTs or assembled mRNA-seq sequences in FASTA format
altest= #EST/cDNA sequences from another organism 
est_gff= #aligned ESTs or mRNA-seq evidence in GFF3 format
altest_gff= #aligned ESTs from a closely related species

#-----Protein Homology Evidence
protein=<PROTEOME> #protein sequences in FASTA format
protein_gff= #aligned protein homology evidence in GFF3 format
```

### Repeat masking and gene prediction

```text
#-----Repeat Masking
model_org=<EMPTY> #model organism for RepBase masking 
rmlib=<RepeatModeler_library> #organism-specific repeat library
repeat_protein= #FASTA file of transposable element proteins
rm_gff= #pre-identified repeat elements in GFF3 format
prok_rm=0 #repeat masking for prokaryotes 
softmask=1 #use soft masking rather than hard masking

#-----Gene Prediction
snaphmm= #SNAP HMM file
gmhmm= #GeneMark HMM file 
augustus_species= #Augustus species model 
fgenesh_par_file= #FGENESH parameter file
pred_gff= #ab initio predictions from an external GFF3 file
model_gff= #annotated gene models from an external GFF3 file
est2genome=0 #infer gene predictions directly from EST evidence
protein2genome=<0 OR 1> #infer predictions from protein homology
trna=0 #identify tRNAs with tRNAscan 
snoscan_rrna= #rRNA file for snoRNA identification
unmask=0 #run ab initio predictions on unmasked sequences
```

### Additional MAKER Configuration Parameters

The remaining parameters in `maker_opts.ctl` control external applications, annotation behaviour, and computational settings.

```text
#-----Other Annotation Feature Types
other_gff= #extra features to pass through to the final MAKER GFF3

#-----External Application Behavior Options
alt_peptide=C #amino acid used to replace non-standard amino acids
cpus=<CPUS> #maximum number of CPUs used by BLAST and RepeatMasker
```
#-----MAKER Behavior Options
max_dna_len=100000 #maximum sequence length for splitting contigs
min_contig=1 #minimum contig length for annotation

pred_flank=200 #flanking sequence around evidence clusters
pred_stats=<0 or 1> #report AED and QI statistics
AED_threshold=1 #maximum allowed Annotation Edit Distance
min_protein=50 #minimum predicted protein length
alt_splice=0 #additional alternative splicing analysis
always_complete=0 #enforce start and stop codons 
map_forward=0 #transfer attributes from previous annotations
keep_preds=0 #retain unsupported gene predictions

split_hit=10000 #maximum expected intron length 
single_exon=0 #consider single-exon EST evidence 
single_length=250 #minimum length for single-exon EST evidence
correct_est_fusion=0 #avoid fusion genes in EST-based annotation

tries=2 #number of attempts if a contig fails
clean_try=0 #remove previous data before retrying
clean_up=0 #remove intermediate analysis files
TMP= #alternative temporary directory
```
### Running MAKER

After configuring the control files, MAKER can be launched using:

```bash
maker -base <OUTPUT_PREFIX>
``` 

Once the annotation is completed, the resulting FASTA and GFF3 files are merged using:

```bash
fasta_merge -d <DATASTORE_INDEX_FILE>
gff3_merge -d <DATASTORE_INDEX_FILE>
```

### Annotation Statistics with AGAT

The quality and characteristics of the resulting annotation can be evaluated using **AGAT (Another Gff Analysis Toolkit)**.

AGAT provides tools to calculate summary statistics for gene models and repetitive elements.

```bash
agat_sp_statistics.pl --gff file.gff -o <output_file>
agat_sq_repeats_analyzer.pl -i <input_file> -o <output_file>
```

The first command generates statistics on gene models, including genes, transcripts, exons, and introns.

The second command summarizes repetitive elements annotated in the genome.

This completes the first round of MAKER annotation in the reference workflow.

## Second Round of Annotation (SNAP and Augustus)

### SNAP

SNAP is a gene prediction tool designed to identify protein-coding genes within DNA sequences, particularly in de novo assembled genomes.

It uses a probabilistic approach based on Hidden Markov Models (HMMs) and can be trained using a set of known gene models to improve prediction accuracy.

In the reference workflow, SNAP was trained using gene models obtained from the first round of MAKER annotation.

The following commands describe the SNAP training procedure:

```bash
maker2zff -c 0 -e 0 -l 80 -x 0.1 -d <datastore_index>
fathom <ANN_FILE> <DNA_FILE> -gene-stats
fathom <ANN_FILE> <DNA_FILE> -validate
fathom <ANN_FILE> <DNA_FILE> -categorize 1000
fathom <UNI_ANN_FILE> <UNI_DNA_FILE> -export 1000 -plus
forge <EXPORT_ANN> <EXPORT_DNA>
hmm-assembler.pl <MODEL_NAME> <FORGE_DIRECTORY> > <OUTPUT_HMM_FILE>
```

The `maker2zff` command extracts gene models from MAKER output and converts them into ZFF format for SNAP training.

The `fathom` commands evaluate and validate the selected gene models, prepare training regions, and export the corresponding sequences.

The `forge` program estimates the parameters required for gene prediction, while `hmm-assembler.pl` generates the final SNAP HMM model. 

Protein-to-genome alignment evidence from the initial MAKER annotation supports the identification of gene models used for SNAP training.

### Augustus

Augustus is a widely used gene prediction tool for identifying protein-coding genes in eukaryotic genomes. 

It employs an ab initio approach based on generalized Hidden Markov Models (GHMMs), allowing gene structure prediction even in the absence of external transcriptomic evidence.

Training Augustus can be computationally demanding. In the reference workflow, BUSCO was used to support Augustus training using conserved single-copy orthologs.

The command used in the course protocol was:

```bash
busco -i ../../03_GenomeAssembly/03_scaffolding/Anoste_chr.fasta -c 30 -l $BUSCO/culicidae_odb12 --augustus --long -m genome --out Anoste_cu --augustus_parameters='--progress=true'
```

### Second MAKER Round

After training SNAP and Augustus, a second round of MAKER annotation can be performed by updating the MAKER configuration files to include the newly trained gene prediction models.

The resulting annotation can then be merged and evaluated using the same procedures described for the first round.

In the reference workflow, the second annotation round produced improved gene models compared with the initial annotation.

