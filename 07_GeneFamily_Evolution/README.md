
# Gene Family Evolution

## CAFE5

*CAFE5* (Computational Analysis of gene Family Evolution) is a software tool used to investigate changes in gene family size across a phylogeny.

It implements a stochastic birth-and-death model to estimate gene family turnover rates and identify statistically significant expansions and contractions. By combining gene copy numbers with a dated species tree, CAFE5 allows the reconstruction of ancestral gene family sizes and the investigation of lineage-specific evolutionary changes.

This analysis focuses on four *Anopheles* species, with *Culex quinquefasciatus* and *Drosophila simulans* included as comparative taxa.

### Dataset

| Abbreviation | Species |
|---|---|
| Anoara | *Anopheles arabiensis* |
| Anocol | *Anopheles coluzzii* |
| Anodar | *Anopheles | darlingi* |
| Anoste | *Anopheles stephensi* |
| Culqui | *Culex quinquefasciatus* |
| Drosim | *Drosophila simulans* |

---

### Data Preparation

CAFE5 requires two main input files:

1. A gene family count matrix.
2. An ultrametric species tree with branch lengths expressed in evolutionary time.

The gene count matrix was obtained from the OrthoFinder orthogroup results and formatted for CAFE5.

The original matrix contained 10,967 orthogroups. Families present in only one species were excluded, removing 674 orthogroups and producing a final input of 10,293 gene families.

The following command was used to prepare the matrix:

```bash 
awk -F '\t' '
BEGIN { OFS="\t" }
NR == 1 {
    print "Desc", "Family ID", "Anoara", "Anocol", "Anodar", "Anoste", "Culqui", "Drosim"
    next
}
{
    present = 0
    for (i = 2; i <= 7; i++)
        if ($i > 0) present++
    if (present >= 2)
        print "(null)", $1, $2, $3, $4, $5, $6, $7
}' gene_families.tsv > GeneCount_CAFE.tsv
```

The dated species tree was obtained from the divergence-time estimation performed in Step 06.

The following command was used to extract the tree in Newick format from the Nexus file:

```bash
sed -n 's/^tree 1 = //p' ../../06_DivergenceTime_Estimation/time_tree_ML.timetree.nex | sed 's/\[&date="[^"]*"\]//g' > timetree_CAFE.nwk
```

The resulting input files are stored in `00_input/`:

- `GeneCount_CAFE.tsv`
- `timetree_CAFE.nwk`
- `timetree_2Lambda.nwk`

---

### Generating the Error Model

Gene family size estimates may be affected by genome assembly and annotation errors.

CAFE5 allows the estimation of an error model to account for uncertainty in observed gene copy numbers.

The error model was generated using:

```bash
cafe5 -i GeneCount_CAFE.tsv \
      -t timetree_CAFE.nwk \
      -o ../01_CAFE5/Error_model \
      -e -c 8
```

The estimated error parameter was:

**Epsilon = 0.00842995**

The resulting `Base_error_model.txt` was used in all subsequent analyses.

---

### Single-Lambda Analysis

The single-lambda model assumes that gene family turnover occurs at a uniform rate across the entire phylogeny.

Five configurations were evaluated, corresponding to 1–5 gamma rate categories (K = 1–5).

Ten independent runs were performed for each configuration.

For example, the single-category model was executed using:

```bash
cafe5 -i GeneCount_CAFE.tsv \
      -t timetree_CAFE.nwk \
      -o ../01_CAFE5/00_1L/1K/1N \
      -e../01_CAFE5/Error_model/Base_error_model.txt \
      -c 8
```

For models with multiple gamma categories, the `-k` option was used to specify K.

The analyses were repeated 10 times for each configuration to compare likelihood estimates.

---

### Two-Lambda Analysis

To investigate variation in gene family turnover rates among lineages, a two-lambda model was also evaluated.

This model allows two different evolutionary rates to be assigned to selected branches of the phylogeny.

The lambda assignment was specified using a separate tree file, `timetree_2Lambda.nwk`, supplied to CAFE5 using the `-y` option.

The following rate assignment was used:

- **Lambda 1:** all branches except the terminal branch leading to *Culex quinquefasciatus*.
- **Lambda 2:** the terminal branch leading to *Culex quinquefasciatus*.

The lambda assignment tree was:

```text 
(((((Anoara:1,Anocol:1):1,Anoste:1):1,Anodar:1):1,Culqui:2):1,Drosim:1);
```

Five gamma configurations (K = 1–5) were tested, each with 10 independent runs.

A representative two-lambda command is:

```bash
cafe5 -i GeneCount_CAFE.tsv \
      -t timetree_CAFE.nwk \
      -y timetree_2Lambda.nwk \
      -o ../01_CAFE5/00_2L/4K/1N \ 
      -e../01_CAFE5/Error_model/Base_error_model.txt \
      -k 4 -c 8
```

In total, 100 CAFE5 runs were performed across the single- and two-lambda models.

---

### Key Parameters

- **Lambda (λ):** gene family turnover rate, describing the frequency of gene gain and loss per gene per unit of evolutionary time.
- **Gamma categories (K):** allow different gene families to evolve at different relative turnover rates.
- **Alpha (α):** shape parameter of the gamma distribution, describing variation in turnover rates among gene families.
- **Epsilon (ε):** parameter of the gene count error model, accounting for potential discrepancies between observed and true gene family sizes.

---

## Model Selection

The best negative log-likelihood value was selected from the 10 independent runs of each model configuration.

The results are summarized in:

`01_CAFE5/Model_selection/all_L_results.txt`

The models were compared using the Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC).

### AIC (Akaike Information Criterion)

AIC evaluates model fit while penalizing model complexity:

**AIC = 2k - 2ln(L)**

### BIC (Bayesian Information Criterion)

BIC also considers model complexity but applies a stronger penalty as sample size increases:

**BIC = k ln(n) - 2ln(L)**

Here, k is the number of parameters, L is the maximized likelihood, and n is the number of analyzed gene families.

The comparison used 8,324 gene families and treated the error model as fixed. The parameter-counting scheme included the number of lambda parameters and one additional gamma shape parameter when K was greater than 1.

The complete results are available in: 

`01_CAFE5/Model_selection/AIC_BIC.tsv`

### Best-Fitting Model

Both AIC and BIC selected the **two-lambda model with four gamma categories (2L/4K)**.

The best likelihood was obtained in replicate `7N`.

| Parameter | Value |
|---|---:|
| Model | 2L/4K |
| Best replicate | 7N |
| Negative log-likelihood | 66184.6 |
| AIC | 132375.20 | 
| BIC | 132396.28 |
| Lambda 1 | 0.000606725 |
| Lambda 2 | 0.001483100 |
| Gamma alpha | 0.729964 |
| Error epsilon | 0.00842995 |

Lambda 2 was approximately 2.44 times greater than Lambda 1, indicating a higher estimated gene family turnover rate along the *Culex quinquefasciatus* terminal branch under the selected model.

---

## Significant Gene Family Expansions and Contractions

The selected CAFE5 model was used to identify statistically significant gene family size changes along the terminal branches of the four *Anopheles* species.

Branch-specific probabilities were evaluated using a significance threshold of **p < 0.05**. 

The direction of change was determined using the gene family copy-number changes reported by CAFE5.

### Results

| Species | Significant expansions | Significant contractions |
|---|---:|---:|
| *Anopheles arabiensis* | 106 | 116 |
| *Anopheles coluzzii* | 63 | 123 |
| *Anopheles stephensi* | 87 | 75 |
| *Anopheles darlingi* | 43 | 40 |

Across the four *Anopheles* species:

- **277 distinct orthogroups** showed at least one significant expansion.
- **311 distinct orthogroups** showed at least one significant contraction.

The same orthogroup may occur in both lists if it expanded in one lineage and contracted in another.

The orthogroup identifiers are stored in:

- `02_results/OG_Anopheles_expansions.txt` 
- `02_results/OG_Anopheles_contractions.txt`

These results provide candidate gene families for subsequent functional annotation and comparative analyses.

---

## Gene Family Coverage

The initial CAFE5 input contained 10,293 orthogroups, while the analyzed family results contained 8,324 orthogroups.

The 1,969 orthogroups absent from the reported results all had zero gene copies in *Drosophila simulans*.

This pattern was confirmed by comparing the input matrix with the CAFE5 output. However, the precise mechanism responsible for the exclusion of these families was not independently established.

Therefore, the significant expansions and contractions reported here refer to the 8,324 orthogroups represented in the analyzed results.

---

## Repository Organization

```text
07_GeneFamily_Evolution/
├── 00_input/ 
│   ├── GeneCount_CAFE.tsv
│   ├── timetree_CAFE.nwk
│   └── timetree_2Lambda.nwk
├── 01_CAFE5/
│   ├── Error_model/
│   │   └── Base_error_model.txt
│   └── Model_selection/
│       ├── AIC_BIC.tsv
│       └── all_L_results.txt
├── 02_results/
│   ├── OG_Anopheles_expansions.txt
│   └── OG_Anopheles_contractions.txt
└── README.md
```

Only essential input files, the estimated error model, model-selection summaries, and final orthogroup lists are included in the GitHub repository. 

The complete CAFE5 run outputs are retained on the analysis server.
