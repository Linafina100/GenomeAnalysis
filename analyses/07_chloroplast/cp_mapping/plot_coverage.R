# Read the depth file
depth_data <- read.table("cp.depth", header=FALSE)
colnames(depth_data) <- c("Contig", "Position", "Depth")

# Create a clean vector PDF plot (bypasses the X11 screen error)
pdf("Chloroplast_Coverage_Plot.pdf", width=10, height=5)

plot(depth_data$Position, depth_data$Depth, type="l", col="darkblue", 
     xlab="Position in Chloroplast Genome (bp)", 
     ylab="Coverage Depth", 
     main="Chloroplast Genome Coverage",
     lwd=0.5)

dev.off()
