# === Step 1: Load on-target dataset ===
df_on_target <- read.csv("on_target_activity.csv", stringsAsFactors = FALSE)
df_off_target <- read.csv("off_target_activity_dataset.csv", stringsAsFactors = FALSE)
# === Step 2: Keep only needed columns ===
df_on_target_selected <- df_on_target[, c("GeneName", "GuideID", "GuideSeq", "TargetSeqContext", "log2FC.D14")]
colnames(df_on_target_selected) <- c("GeneName", "GuideID", "GuideSeq", "TargetSeqContext", "log2FC")
colnames(df_off_target) <- c("GeneName", "GuideID", "GuideSeq", "TargetSeqContext", "log2FC")
# === Step 4: Now combine with the off-target + hek293 combined dataset ===

# Load the previously combined off-target + HEK293 file if not already in memory
# Merge vertically
df_final_combined <- bind_rows(df_off_target, df_on_target_selected)

# === Step 5: Save ===
write.csv(df_final_combined, "final_activity_dataset.csv", row.names = FALSE)
