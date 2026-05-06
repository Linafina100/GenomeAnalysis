# Load packages
library(ggplot2)
library(patchwork) 

# Load data
raw_data <- read.csv("gene_counts_renamed.csv", header=TRUE)
raw_data <- raw_data[raw_data[, 1] != "" & !is.na(raw_data[, 1]), ]

# Extract just the numeric count columns (Columns 4 through 9)
counts <- raw_data[, 4:9]
counts[is.na(counts)] <- 0
counts <- round(counts)

# Calculate total counts per gene
gene_totals <- rowSums(counts)

# Create two dataframes: one with all data, one with zeros removed
plot_data_all <- data.frame(TotalCounts = gene_totals)
plot_data_expressed <- subset(plot_data_all, TotalCounts > 0)

# Create plot with all data
p1 <- ggplot(plot_data_all, aes(x = log10(TotalCounts + 1))) +
  geom_histogram(bins = 60, fill = "#A9CDE3", color = "black", alpha = 0.9) +
  theme_minimal() +
  labs(
    title = "All Genes",
    subtitle = "Includes unexpressed genes (zeros)",
    x = "Total Counts (log10)",
    y = "Frequency"
  ) +
  geom_vline(xintercept = log10(10 + 1), linetype="dashed", color = "#B82125", linewidth=1)

# 4. CREATE PLOT 2: Expressed Genes Only (Light Blue)
p2 <- ggplot(plot_data_expressed, aes(x = log10(TotalCounts + 1))) +
  # Using the exact same light blue here
  geom_histogram(bins = 60, fill = "#A9CDE3", color = "black", alpha = 0.9) +
  theme_minimal() +
  labs(
    title = "Expressed Genes Only",
    subtitle = "Zero-count genes removed",
    x = "Total Counts (log10)",
    y = "Frequency"
  ) +
  geom_vline(xintercept = log10(10 + 1), linetype="dashed", color = "#B82125", linewidth=1) +
  annotate("text", x = log10(10 + 1) + 0.15, y = Inf, label = "10 Count Threshold", 
           vjust = 2, hjust = 0, color="#B82125", fontface="bold")

# Add subplots together
png("Histogram_Read_Counts_LightBlue.png", width=12, height=5, units="in", res=300)
p1 + p2 + plot_annotation(
  title = 'Distribution of Read Counts per Gene',
  theme = theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5))
)
dev.off()

print("Subplots generated!")