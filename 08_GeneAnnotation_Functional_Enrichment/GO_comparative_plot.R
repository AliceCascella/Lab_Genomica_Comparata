#!/usr/bin/env Rscript

# Step 08 - Comparative GO enrichment visualization
#CAFE5 expanded and contracted orthogroups
#topGO (elim + Fisher) and REVIGO results

library(ggplot2)

# Input files
ontologies <- c("BP", "MF", "CC")
directions <- c("expansions", "contractions")

# Read REVIGO results
all_data <- list()

for (direction in directions) {
  for (ontology in ontologies) {

    file <- file.path(
      paste0("topGO_", direction),
      paste0("REVIGO_", direction, "_", ontology, ".tsv")
    )

    x <- read.delim(file, stringsAsFactors = FALSE)
   
    # Select representative GO terms
    x <- subset(
      x,
      !is.na(Dispensability) & Dispensability < 0.15
    )

    x$Ontology <- ontology
    x$Direction <- direction

    all_data[[paste(direction, ontology, sep = "_")]] <- x
  }
}
go_data <- do.call(rbind, all_data)

# Convert REVIGO values to -log10(p-value)
go_data$Significance <- -as.numeric(go_data$Value)

# Order categories and directions
go_data$Ontology <- factor(
  go_data$Ontology,
  levels = c("BP", "MF", "CC")
)

go_data$Direction <- factor(
  go_data$Direction, 
  levels = c("expansions", "contractions"),
  labels = c("Expansions", "Contractions")
)

# Order GO terms within each panel
go_data$TermLabel <- paste(
  go_data$Name,
  go_data$Ontology,
  go_data$Direction,
  sep = "___"
)

term_order <- go_data$TermLabel[ 
  order(go_data$Significance)
]

go_data$TermLabel <- factor(
  go_data$TermLabel,
  levels = unique(term_order)
)

# Create comparative figure
p <- ggplot(
  go_data,
  aes(x = Significance, y = TermLabel, fill = Direction)
) +
  geom_col(width = 0.75) +
  facet_wrap( 
    vars(Direction, Ontology),
    ncol = 3,
    scales = "free_y",
    labeller = label_value
  ) +
  scale_y_discrete(
    labels = function(x) sub("___.*", "", x)
  ) +
  scale_fill_manual(
    values = c(
      "Expansions" = "#3B82B8", 
      "Contractions" = "#D45A55"
    )
  ) +
  labs(
    title = "GO enrichment of expanded and contracted gene families",
    subtitle = "Representative GO terms identified by topGO and REVIGO",
    x = expression(-log[10](italic(p))),
    y = NULL,
    fill = "Gene family change"
  )+
  theme_bw(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold"),
    axis.text.y = element_text(size = 7), 
    legend.position = "bottom",
    panel.grid.major.y = element_blank(),
    plot.title = element_text(face = "bold")
  )

# Save figures
dir.create("02_figures", showWarnings = FALSE)

ggsave(
  "02_figures/GO_enrichment_comparative.pdf",
  plot = p,
  width = 20, 
  height = 15
)

ggsave(
  "02_figures/GO_enrichment_comparative.png",
  plot = p,
  width = 20,
  height = 15,
  dpi = 300
)

cat("Comparative GO enrichment figures generated.\n")
cat("Total representative GO terms:", nrow(go_data), "\n")
