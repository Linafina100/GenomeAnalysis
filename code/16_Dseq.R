# Load packages
library(ggplot2)   
library(ggrepel)
library(pheatmap)
library(DESeq2)    

# Load data and split from counts
raw_data <- read.csv("gene_counts_renamed.csv", header=TRUE)

# Delete any empty/blank rows Excel left behind at the bottom
raw_data <- raw_data[raw_data[, 1] != "" & !is.na(raw_data[, 1]), ]

# Start by assuming we will use Column 2 (Annotation)
best_names <- raw_data[, 2]

# Labeling logic

# PFAM genes with no annotation
use_pfam_index <- (raw_data[, 2] == raw_data[, 1]) & (raw_data[, 3] != "-") & (raw_data[, 3] != "")
best_names[use_pfam_index] <- paste0(raw_data[use_pfam_index, 3], " [PFAM]")

# Genes with only gene ID
is_hypothetical <- (best_names == raw_data[, 1])
best_names[is_hypothetical] <- paste0(best_names[is_hypothetical], " [hypo]")

# Save names into a dictionary 
gene_dict <- best_names
names(gene_dict) <- raw_data[, 1]

# Set the hidden row names to the unique gene IDs (Column 1)
rownames(raw_data) <- raw_data[, 1]

# Grab columns 4 through 9 (count data)
counts <- raw_data[, 4:9]

# If there are any random empty cells inside the data, make them 0
counts[is.na(counts)] <- 0

# Force numbers to integers
counts <- round(counts)

# Run DESeq2 and export results
colData <- data.frame(condition = factor(c("Control", "Control", "Control", "Heat", "Heat", "Heat")))
rownames(colData) <- colnames(counts)

dds <- DESeqDataSetFromMatrix(countData = counts, colData = colData, design = ~ condition)
dds <- DESeq(dds)

res <- results(dds, contrast=c("condition", "Heat", "Control"))
write.csv(as.data.frame(res), file="Heat_vs_Control_DESeq2_Results.csv")

vsd <- varianceStabilizingTransformation(dds, blind=FALSE)

# Define global colours
my_colors <- c("Control" = "#00BFC4", "Heat" = "#F8766D") 

# Generate PCA plot
pcaData <- plotPCA(vsd, intgroup="condition", returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

png("DESeq2_PCA_Plot.png", width=7, height=6, units="in", res=300)
ggplot(pcaData, aes(PC1, PC2, color=condition)) +
  geom_point(size=4) +
  scale_color_manual(values=my_colors) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  theme_bw() +
  ggtitle("PCA: Heat vs Control")
dev.off()

# Gene name mapping
res_df <- as.data.frame(res)
res_df$Significance <- "Not Sig"
res_df$Significance[res_df$log2FoldChange > 1 & res_df$padj < 0.05] <- "Up"
res_df$Significance[res_df$log2FoldChange < -1 & res_df$padj < 0.05] <- "Down"

# Map the clean names using the dictionary
res_df$GeneName <- gene_dict[rownames(res_df)]

# Generate the volcano plot
res_df <- res_df[order(res_df$padj), ] 
top10_genes <- head(res_df, 10)

png("DESeq2_Volcano_Plot.png", width=7, height=6, units="in", res=300)
ggplot(res_df, aes(x=log2FoldChange, y=-log10(padj), color=Significance)) +
  geom_point(alpha=0.9, size=1.5) +
  scale_color_manual(values=c("Down"="#4A81D4", "Not Sig"="#BDBDBD", "Up"="#B82125")) +
  geom_text_repel(data=top10_genes, aes(label=GeneName), color="black", size=4, max.overlaps=Inf) +
  theme_classic() +
  labs(x="log2FC", y="-log10(Pvalue)", color="") +
  theme(legend.position="right")
dev.off()

# Generate annotated heatmap
top_genes <- order(res$padj)[1:20]
mat <- assay(vsd)[top_genes, ]
mat <- mat - rowMeans(mat)

rownames(mat) <- res_df[rownames(mat), "GeneName"]

short_names <- c("Control_1", "Control_2", "Control_3", "Heat_1", "Heat_2", "Heat_3")
colnames(mat) <- short_names

df <- as.data.frame(colData(dds)[,c("condition")])
rownames(df) <- short_names
colnames(df) <- c("Condition")

ann_colors <- list(Condition = my_colors)

png("DESeq2_Heatmap.png", width=7, height=6, units="in", res=300)
pheatmap(mat, 
         annotation_col=df, 
         annotation_colors=ann_colors, 
         main="Top 20 Differentially Expressed Genes",
         cellwidth = 30, 
         cellheight = 15)
dev.off()

print("Final annotated plots generated successfully with Excel data!")




