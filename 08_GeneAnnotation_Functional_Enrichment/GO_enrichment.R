#!/usr/bin/env Rscript

# Step 08 - Gene Annotation and Functional Enrichment
#GO enrichment of significantly expanded and contracted
#Anopheles orthogroups identified by CAFE5.
#Method: topGO, elim algorithm, Fisher's exact test.

library(topGO)

# Load GO annotations
gene_universe <- readMappings(file = "go_back_CAFE.tsv")
geneUniverse <- names(gene_universe)

cat("Annotated CAFE5 orthogroups:", length(geneUniverse), "\n")

# Lists of orthogroups of interest
interest_lists <- list(
  expansions = scan("OG_Anopheles_expansions.txt",
                    what = character(), quiet = TRUE),
  contractions = scan("OG_Anopheles_contractions.txt",
                      what = character(), quiet = TRUE)
)

# GO enrichment function
GOenrichment <- function(genesOfInterest, trait_name) {

  output_dir <- paste0("topGO_", trait_name)
  dir.create(output_dir, showWarnings = FALSE)
  
  # Identify genes of interest within the annotated background
  geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
  names(geneList) <- geneUniverse

  cat("\nAnalysis:", trait_name, "\n")
  cat("Genes of interest with GO:",
      sum(geneList == 1), "\n")

ontology_values <- c("BP", "MF", "CC")

for (ontology_value in ontology_values) {

  cat("Running ontology:", ontology_value, "\n")

  # Build topGO data object
  GOdata <- new(
    "topGOdata",
    ontology = ontology_value,
    allGenes = geneList,
    annot = annFUN.gene2GO,
    gene2GO = gene_universe
  )
  # Elim algorithm with Fisher's exact test
  elim_result <- runTest(
    GOdata,
    algorithm = "elim",
    statistic = "fisher"
  )

  # Extract results
  num_nodes <- min(1000, length(score(elim_result)))

  results <- GenTable(
    GOdata,
    elim_Fisher = elim_result,
    orderBy = "elim_Fisher",
    topNodes = num_nodes,
    numChar = 1000
    )

  # Filter by the same p-value

  results$p_value <- suppressWarnings(
    as.numeric(sub("^<", "", results$elim_Fisher))
  )

  results <- subset(results, !is.na(p_value) & p_value < 0.05)
  
  # Save significant GO terms
  output_file <- file.path(
    output_dir,
    paste0("topGOe_", trait_name, "_", ontology_value, ".txt")
  )

  write.table(
    results, 
    file = output_file,
    quote = FALSE,
    sep = "\t",
    row.names = FALSE
  )

  cat("Significant GO terms:", nrow(results), "\n")
  cat("Saved:", output_file, "\n")
  }
}

# Run both analyses
for (trait_name in names(interest_lists)) {
  GOenrichment(interest_lists[[trait_name]], trait_name)
}
cat("\nGO enrichment analyses completed.\n")
