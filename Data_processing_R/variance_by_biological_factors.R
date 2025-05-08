library(ggplot2)
library(dplyr)

# === Step 1: Load Data ===

# Load Supplementary Data 9 (MOESM12)
df_supp9 <- read.delim("41587_2023_1830_MOESM12_ESM.txt", header = TRUE, sep = "\t")

# Load Supplementary Data 12 (MOESM15)
df_supp12 <- read.delim("41587_2023_1830_MOESM15_ESM.txt", header = TRUE, sep = "\t")
colnames(df_supp9)[1] <- "GuideUID" 

df <- dplyr::inner_join(df_supp9, df_supp12, by = "GuideUID")
# Your data frame already subsetted:
# df contains columns: biological features + Observed.log2FC.D14

# Step 1: Calculate R-squared for each feature
features <- c("mfe", "hybrid_mfe_1_23", "hybMFE_15.9", "hybMFE_3.12", 
              "log_unpaired", "log10_unpaired_p11", "log10_unpaired_p19", 
              "log10_unpaired_p25", "Dist2Junction_5p", "Dist2Junction_3p", "g_quad")

r2_results <- sapply(features, function(feature) {
  fmla <- as.formula(paste("Observed.log2FC.D14 ~", feature))
  model <- lm(fmla, data = df)
  summary(model)$r.squared
})

# Put into data frame
r2_df <- data.frame(
  Feature = names(r2_results),
  R_squared = r2_results
)

# Step 2: Bar plot of R-squared
ggplot(r2_df, aes(x = reorder(Feature, R_squared), y = R_squared)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(x = "Feature", y = "R-squared", title = "Variance Explained by Biological Features") +
  coord_flip()

# Step 3: Scatter plot for strongest feature
ggplot(df, aes(x = hybrid_mfe_1_23, y = Observed.log2FC.D14)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", color = "red") +
  theme_minimal() +
  labs(title = "Hybrid MFE vs log2FC")
