library(DESeq2)

# Load clean count matrix
counts <- read.table("clean_gene_counts.txt", header=TRUE, row.names=1)

# Create metadata table
colData <- data.frame(
  condition = factor(c("Control", "Control", "Control", "Heat", "Heat", "Heat"))
)
rownames(colData) <- colnames(counts)

# Build the DESeq2 object and run the analysis
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = colData,
                              design = ~ condition)

# Run the actual differential expression math
dds <- DESeq(dds)

# Extract the results (Comparing Heat vs Control)
res <- results(dds, contrast=c("condition", "Heat", "Control"))

# 6. Save the final results to a spreadsheet
write.csv(as.data.frame(res), file="Heat_vs_Control_DESeq2_Results.csv")

print("DESeq2 complete!")

# --- Generate the PCA Plot ---
# Transform the raw counts so they can be graphed properly
vsd <- vst(dds, blind=FALSE)

# Open a PDF file to save the plot into
pdf("DESeq2_PCA_Plot.pdf")

# Draw the plot, coloring the dots by 'condition' (Heat vs Control)
plotPCA(vsd, intgroup="condition")

# Close and save the PDF
dev.off()

print("Files generated!")