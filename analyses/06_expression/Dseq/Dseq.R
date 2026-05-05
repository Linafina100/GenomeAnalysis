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

# --- Generate the Volcano Plot (ggplot2 Style) ---
library(ggplot2)

# Convert DESeq2 results to a normal dataframe so ggplot can read it
res_df <- as.data.frame(res)

# Create a new column called "Significance" and label every gene
res_df$Significance <- "Not Sig"
res_df$Significance[res_df$log2FoldChange > 1 & res_df$padj < 0.05] <- "Up"
res_df$Significance[res_df$log2FoldChange < -1 & res_df$padj < 0.05] <- "Down"

# Open a PDF and draw the plot
pdf("DESeq2_Volcano_Plot.pdf", width=7, height=6)

ggplot(res_df, aes(x=log2FoldChange, y=-log10(padj), color=Significance)) +
  geom_point(alpha=0.9, size=1.5) +
  # Use the exact colors from your screenshot
  scale_color_manual(values=c("Down"="#4A81D4", "Not Sig"="#BDBDBD", "Up"="#B82125")) +
  theme_classic() +
  labs(x="logFC", y="-log10(Pvalue)", color="") +
  theme(legend.position="right")

dev.off()


# --- Generate the Heatmap (Clean Labels) ---
library(pheatmap)

# Grab the top 20 most statistically significant genes
top_genes <- order(res$padj)[1:20]

# Extract their normalized expression values
mat <- assay(vsd)[top_genes, ]

# Center the data by subtracting the average
mat <- mat - rowMeans(mat)

# fix labels, short and readable
short_names <- c("Control_1", "Control_2", "Control_3", "Heat_1", "Heat_2", "Heat_3")
colnames(mat) <- short_names

# Create a label box so the heatmap knows which samples are Heat and Control
df <- as.data.frame(colData(dds)[,c("condition")])
rownames(df) <- short_names 
colnames(df) <- c("Condition")

# Open PDF and draw the heatmap
pdf("DESeq2_Heatmap.pdf", width=7, height=6)
pheatmap(mat, 
         annotation_col=df, 
         main="Top 20 Differentially Expressed Genes",
         cellwidth = 30, 
         cellheight = 15)
dev.off()

print("Volcano Plot and Clean Heatmap successfully generated!")