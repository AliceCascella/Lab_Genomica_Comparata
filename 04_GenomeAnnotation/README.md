# Genome Annotation
**Note on data provenance:** The MAKER annotation statistics included in this directory were obtained from the 
instructor-provided practical materials. The MAKER annotation workflow described below is the reference course procedure and 
was not independently executed as part of this project. Genome annotation of a newly assembled genome allows the 
identification of its functional features. This process relies on the GFF format, which is essential for mapping the 
coordinates of different features along the genome. Functional annotation involves assigning specific biological functions to 
nucleotide sequences, effectively mapping functional roles to precise genomic coordinates.
## Repetitive Element Annotation
Repetitive elements can significantly interfere with genome analysis, especially when focusing on coding regions. The aim of 
this step is to mask these elements, ensuring that they are excluded from consideration by subsequent annotation software. To 
obtain high-quality annotation, the use of a transcriptome (or proteome) as a reference is recommended. This provides 
additional biological evidence, as it contains important information about isoform diversity. For a rapid and approximate 
annotation of transposable elements, we use [*RepeatModeler*](https://github.com/Dfam-consortium/RepeatModeler) and 
[*RepeatMasker*](https://github.com/Dfam-consortium/RepeatMasker). Briefly, RepeatModeler identifies a set of consensus 
sequences representing the repeats present in the genome. This library is then used by RepeatMasker to annotate the assembly.
> Due to computational limitations, RepeatModeler was run in advance by the instructor. The consensus library is available at:
>
> `/home/PERSONALE/mirko.martini3/Lab_CompGeno/00_practice/00_data/02_Annotation/Anoste_RepeatModeler_library.fa`
## First Round of Annotation (MAKER)
The software used for annotation is *MAKER*. To function correctly, it requires several control and configuration files, which 
are generated using the following command: ```bash maker -CTL ``` This command generates the files required for MAKER to run. 
The program relies on configuration files rather than standard command-line arguments; it is designed to read inputs and 
settings from these preconfigured files. All required parameters were configured in the reference workflow. ```text
#-----Genome (these are always required)
genome=Anoste_pol.decontaminated #genome sequence (fasta file or fasta embedded in GFF3 file) organism_type=eukaryotic 
#eukaryotic or prokaryotic. Default is eukaryotic -----Re-annotation Using MAKER Derived GFF3
maker_gff= #MAKER derived GFF3 file est_pass=0 #use ESTs in maker_gff: 1 = yes, 0 = no altest_pass=0 #use alternate organism 
ESTs in maker_gff: 1 = yes, 0 = no protein_pass=0 #use protein alignments in maker_gff: 1 = yes, 0 = no rm_pass=0 #use repeats 
in maker_gff: 1 = yes, 0 = no model_pass=0 #use gene models in maker_gff: 1 = yes, 0 = no pred_pass=0 #use ab-initio 
predictions in maker_gff: 1 = yes, 0 = no other_pass=0 #passthrough anything else in maker_gff: 1 = yes, 0 = no
#-----EST Evidence (for best results provide a file for at least one)
est= #set of ESTs or assembled mRNA-seq in fasta format altest= #EST/cDNA sequence file in fasta format from an alternate 
organism est_gff= #aligned ESTs or mRNA-seq from an external GFF3 file altest_gff= #aligned ESTs from a closely related 
species in GFF3 format
#-----Protein Homology Evidence (for best results provide a file for at least one)
protein=<PROTEOME> #protein sequence file in fasta format (i.e. from multiple organisms) protein_gff= #aligned protein 
homology evidence from an external GFF3 file
#-----Repeat Masking (leave values blank to skip repeat masking)
model_org=<EMPTY> #select a model organism for RepBase masking in RepeatMasker rmlib=<RepeatModeler_library> #provide an 
organism-specific repeat library in fasta format for RepeatMasker repeat_protein= #provide a fasta file of transposable 
element proteins for RepeatRunner rm_gff= #pre-identified repeat elements from an external GFF3 file prok_rm=0 #forces MAKER 
to repeatmask prokaryotes (no reason to change this), 1 = yes, 0 = no softmask=1 #use soft-masking rather than hard-masking in 
BLAST (i.e. seg and dust filtering)
#-----Gene Prediction
snaphmm= #SNAP HMM file gmhmm= #GeneMark HMM file augustus_species= #Augustus gene prediction species model fgenesh_par_file= 
#FGENESH parameter file
pred_gff= #ab-initio predictions from an external GFF3 file model_gff= #annotated gene models from an external GFF3 file 
(annotation pass-through) est2genome=0 #infer gene predictions directly from ESTs, 1 = yes, 0 = no protein2genome=<0 OR 1> 
#infer predictions from protein homology, 1 = yes, 0 = no
trna=0 #find tRNAs with tRNAscan, 1 = yes, 0 = no snoscan_rrna= #rRNA file to have Snoscan find snoRNAs unmask=0 #also run 
ab-initio prediction programs on unmasked sequence, 1 = yes, 0 = no
#-----Other Annotation Feature Types (features MAKER doesn't recognize)
other_gff= #extra features to pass-through to final MAKER generated GFF3 file
#-----External Application Behavior Options
alt_peptide=C #amino acid used to replace non-standard amino acids in BLAST databases cpus=<CPUS> #max number of cpus to use 
in BLAST and RepeatMasker (not for MPI, leave 1 when using MPI)
#-----MAKER Behavior Options
max_dna_len=100000 #length for dividing up contigs into chunks (increases/decreases memory usage) min_contig=1 #skip genome 
contigs below this length (under 10kb are often useless) pred_flank=200 #flank for extending evidence clusters sent to gene 
predictors pred_stats=<0 or 1> #report AED and QI statistics for all predictions as well as models AED_threshold=1 #Maximum 
Annotation Edit Distance allowed (bound by 0 and 1) min_protein=50 #require at least this many amino acids in predicted 
proteins alt_splice=0 #Take extra steps to try and find alternative splicing, 1 = yes, 0 = no always_complete=0 #extra steps 
to force start and stop codons, 1 = yes, 0 = no map_forward=0 #map names and attributes forward from old GFF3 genes, 1 = yes, 
0 = no keep_preds=0 #Concordance threshold to add unsupported gene prediction (bound by 0 and 1) split_hit=10000 #length for 
the splitting of hits (expected max intron size for evidence alignments) single_exon=0 #consider single exon EST evidence when 
generating annotations, 1 = yes, 0 = no single_length=250 #min length required for single exon ESTs if 'single_exon is 
enabled' correct_est_fusion=0 #limits use of ESTs in annotation to avoid fusion genes tries=2 #number of times to try a contig 
if there is a failure for some reason clean_try=0 #remove all data from previous run before retrying, 1 = yes, 0 = no 
clean_up=0 #removes theVoid directory with individual analysis files, 1 = yes, 0 = no TMP= #specify a directory other than the 
system default temporary directory ``` MAKER was subsequently launched in the reference workflow: ```bash maker -base <OUTPUT 
PREFIX> ``` Once the procedure was completed, the resulting `.fasta` and `.gff` files had to be merged. ```bash fasta_merge -d 
<DATASTORE INDEX FILE> gff3_merge -d <DATASTORE INDEX FILE> ``` Summary statistics can then be evaluated. One of the commonly 
used tools is *AGAT*, which provides statistics on gene models and repetitive elements. ```bash agat_sp_statistics.pl --gff 
file.gff -o <output_file> # Gene models summary statistics agat_sq_repeats_analyzer.pl -i <input_file> -o <output_file> # 
Repeats' summary statistics ``` This concludes the first round of MAKER annotation. ---
## Second Round of Annotation (SNAP and Augustus)
SNAP is a gene prediction tool designed to identify protein-coding genes within DNA sequences, particularly in de novo 
assembled genomes. It uses a probabilistic HMM (Hidden Markov Model) approach and can be trained using a set of known genes to 
significantly improve its predictive accuracy. SNAP was run in the reference workflow using a custom script with the following 
sequence of commands: ```bash maker2zff -c 0 -e 0 -l 80 -x 0.1 -d <datastore_index> #Extract gene models based on multiple 
filtering criteria and convert MAKER output into .zff files for SNAP fathom <.ANN FILE> <.DNA FILE> -gene-stats #Print summary 
statistics of the selected gene models fathom <.ANN FILE> <.DNA FILE> -validate #Validate gene models and print summary 
statistics fathom <.ANN FILE> <.DNA FILE> -categorize 1000 #Extract gene models together with 1000 bp at both ends for 
training fathom <UNI.ANN FILE> <UNI.DNA FILE> -export 1000 -plus #Export and convert unique genes to the plus strand forge 
<export.ann> <export.dna> #Run the parameter estimation program, preferably in another directory hmm-assembler.pl <NAME> 
<FORGE DIRECTORY> > <OUTPUT HMM FILE> ```
> The protein-genome alignment results must be provided to SNAP to identify and define protein prediction models.
Augustus is a widely used gene prediction tool for identifying protein-coding genes in eukaryotic genomes. It employs an ab 
initio approach based on a generalized Hidden Markov Model (HMM), allowing it to predict gene structures even in the absence 
of external transcriptomic evidence. Running Augustus as a standalone tool is extremely computationally demanding. However, 
BUSCO allows a more time-efficient execution of the software. ```bash busco -i 
../../03_GenomeAssembly/03_scaffolding/Anoste_chr.fasta -c 30 -l $BUSCO/culicidae_odb12 --augustus --long -m genome --out 
Anoste_cu --augustus_parameters='--progress=true' ``` At this point, the second round of MAKER can be started, ensuring that 
the parameters are correctly updated to include the newly trained models.
> Annotation quality improves significantly from the first to the second round in the reference workflow.
---
