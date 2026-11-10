
# 06 - Divergence Time Estimation

The species tree obtained in the previous step was used to estimate divergence times among the six Diptera species and reconstruct an ultrametric phylogenetic tree. 

The analysis was performed using IQ-TREE and its LSD2 (Least Squares Dating) algorithm, with divergence-time calibrations obtained from [TimeTree](https://timetree.org/).

## Topology verification

Before estimating divergence times, the maximum-likelihood species tree was examined to evaluate its topology.

The original IQ-TREE reconstruction recovered an unexpected placement of *Culex quinquefasciatus* and *Drosophila simulans*. Therefore, alternative phylogenetic hypotheses were compared using topology tests implemented in IQ-TREE.

The corrected candidate topologies were:

```text
T1: (Anoara,Anocol,((Anodar,(Culqui,Drosim)),Anoste));

T2: (Drosim,Culqui,((Anoara,Anocol),(Anoste,Anodar)));
``` 

The comparison was performed using the concatenated amino-acid alignment generated in the previous step.

The results are stored in `00_topology_check/`, including:

- `candidate_trees_corrected.nwk`: alternative topologies. 
- `topology_test_corrected.iqtree`: statistical comparison of the candidate trees.

The approximately unbiased (AU) test strongly favored the original maximum-likelihood topology over the alternative:

- T1: AU p-value = 1
- T2: AU p-value = 6.42e-10

The alternative topology was therefore rejected by the AU test, while the original topology was retained as the maximum-likelihood result.

## Divergence-time calibration

To estimate divergence times, calibration points were obtained from [TimeTree.org](https://timetree.org/), which provides published estimates of evolutionary divergence between taxa.

The following species pairs were examined:

| Species pair | Divergence time (MYA) |
|---|---:| 
| Anopheles arabiensis - Anopheles coluzzii | 1.90 | 
| Anopheles darlingi - Anopheles stephensi | 84 | 
| Anopheles darlingi - Culex quinquefasciatus | 138 | 
| Culex quinquefasciatus - Drosophila simulans | 252 |

These estimates were used to guide the calibration of the species tree.

The calibration constraints were recorded in:

`calibration.txt`

IQ-TREE accepts calibration constraints specifying the taxa defining a node and the corresponding divergence time.

For example:

```text 
taxon1,taxon2 -50
taxon3,taxon4 -100
```

The actual calibration constraints used in the analysis are provided in `calibration.txt`.

## Species-tree dating - IQ-TREE and LSD2

Divergence-time estimation was performed using IQ-TREE and LSD2, which estimates node ages by minimizing the differences between observed branch lengths and expected evolutionary distances under a molecular-clock model.

The analysis used the amino-acid alignment generated in the previous phylogenomic step, together with the calibration constraints obtained from TimeTree.

The general IQ-TREE command structure was:

```bash
iqtree -s ../05_OG.Inference_Phylogenomic/05_tree/00_species/conc_species_tree.faa \
       --date calibration.txt \
       --date-tip 0 \
       -m Q.INSECT+F+I+R3 \
       -nt 9 \
       --prefix time_tree_ML \ 
       --date-options "-u 1"
```

The `--date` option specifies the calibration file, while `--date-options "-u 1"` sets the minimum branch duration to one time unit.

The final dated tree was generated in NEXUS format, allowing visualization and further evolutionary analyses.

## Results

The main output files are:

- `time_tree_ML.log`: IQ-TREE execution log.
- `time_tree_ML.timetree.nex`: dated phylogenetic tree in NEXUS format.
- `calibration.txt`: divergence-time calibration constraints.

The resulting ultrametric tree provides estimated divergence times among the six Diptera species and can be used for downstream comparative genomic analyses.
