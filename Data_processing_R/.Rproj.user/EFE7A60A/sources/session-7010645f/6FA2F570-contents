library(dplyr)

# === Step 1: Load Supplementary Data 5 (MOESM7_ESM: On-target gRNA annotation) ===
df_supp5 <- read.delim("41587_2023_1830_MOESM7_ESM.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
colnames(df_supp5)
# Rename "ID" to "GuideID", and "UID" to "GuideUID"
df_supp5 <- dplyr::rename(df_supp5,
                          GuideID = "ID",
                          GuideUID = "UID")

# === Step 2: Load Supplementary Data 7 (MOESM9_ESM: On-target activity scores) ===
df_supp7 <- read.delim("41587_2023_1830_MOESM9_ESM.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# === Step 3: Merge datasets using "GuideID" as key ===
df_on_target_merged <- merge(df_supp5, df_supp7, by = "GuideUID", all = FALSE)

# === Step 4: Keep only perfect-match guides (Type = "PM") ===
df_on_target_pm <- df_on_target_merged %>% filter(Type == "PM")

# ----- Step 1: Extract and clean the target positions from the GuideID -----
df_on_target_parsed <- df_on_target_pm %>%
  mutate(
    pos_info = str_extract(GuideID, "\\d+-\\d+"),           # Extract coordinate info, e.g. "1046-1068"
    start = as.numeric(str_extract(pos_info, "^\\d+")),   # Extract the start position
    end = as.numeric(str_extract(pos_info, "\\d+$"))      # Extract the end position
  )

df_on_target_parsed <- df_on_target_parsed %>%
  left_join(dplyr::select(df_cdna_on_target, TargetGene, cdna))

# ----- Step 3: Extract the target sequence context from the cDNA sequence -----
df_on_target_parsed <- df_on_target_parsed %>%
  mutate(
    TargetSeq = ifelse(
      !is.na(cdna) & !is.na(start) & !is.na(end),
      substr(cdna, start, end),
      NA
    )
  )

df_aaa <- df_on_target_parsed %>%
  dplyr::select(
    GeneName,
    GuideID,
    GuideSeq,
    end,
    start,
    log2FC.D7,
    log2FC.D14,
    TargetSeqContext,
    )
write.csv(df_aaa, "on_target_activity.csv", row.names = FALSE)