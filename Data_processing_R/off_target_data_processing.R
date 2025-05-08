library(dplyr)
library(stringr)
library(Biostrings)

#HEK293 off target data
# === Step 1: Load datasets ===
df_moesm4 <- read.csv("41587_2023_1830_MOESM4_ESM.csv", stringsAsFactors = FALSE)
df_moesm6 <- read.csv("41587_2023_1830_MOESM6_ESM.csv", stringsAsFactors = FALSE)

# === Step 2: Merge TargetGene and GuideID into one single column ===
df_moesm4 <- df_moesm4 %>%
  mutate(GuideID = paste(TargetGene, GuideID, sep = "_"))

# Verify column merging
head(df_moesm4$GuideID)

# === Step 3: Merge MOESM4 with MOESM6 ===
df_hek293 <- df_moesm4 %>%
  inner_join(df_moesm6, by = "GuideID")

# === Step 4: Filter out perfect-match (PM) gRNAs, keeping only mutated (SM/RDM) ===
df_hek293_mutated <- df_hek293 %>%
  filter(Type != "PM")

# === Step 5: Define parsing function for mutated gRNAs ===
parse_mutated_guide <- function(guide_id) {
  # Match pattern: "Gene_crRNAxxxx:xxx-xxx_SM_Px-N:N|Px-N:N"
  base_info <- str_match(guide_id, "(.*)_crRNA\\d+:(\\d+)-(\\d+)_.*_(.+)")
  if (any(is.na(base_info))) return(NULL)
  
  gene <- base_info[2]
  pos_start <- as.numeric(base_info[3])
  pos_end <- as.numeric(base_info[4])
  mutations <- base_info[5]
  
  list(
    gene = gene,
    pos_start = pos_start,
    pos_end = pos_end,
    mutations = mutations
  )
}

# === Step 6: Apply parsing function ===
df_hek293_parsed <- df_hek293_mutated %>%
  rowwise() %>%
  mutate(parsed_info = list(parse_mutated_guide(GuideID))) %>%
  filter(!is.null(parsed_info)) %>%
  mutate(
    GeneName = parsed_info$gene,
    pos_start = parsed_info$pos_start,
    pos_end = parsed_info$pos_end,
    mutations = parsed_info$mutations
  ) %>%
  ungroup()

# === Step 7: Define function to revert mutations to get perfect-match gRNA ===
revert_mutations <- function(seq, mutations) {
  seq_split <- unlist(strsplit(seq, ""))
  muts <- unlist(strsplit(mutations, "\\|"))
  for (mut in muts) {
    pos_nt <- str_match(mut, "P(\\d+)-([ACGT]):([ACGT])")
    if (any(is.na(pos_nt))) next
    pos <- as.numeric(pos_nt[2])
    original_nt <- pos_nt[3] # revert mutation
    seq_split[pos] <- original_nt
  }
  paste(seq_split, collapse = "")
}

# === Step 8: Apply mutation reversion and get target sequence context ===
df_hek293_final <- df_hek293_parsed %>%
  rowwise() %>%
  mutate(
    PerfectGuideSeq = revert_mutations(GuideSeq, mutations),
    TargetSeqContext = as.character(reverseComplement(DNAString(PerfectGuideSeq)))
  ) %>%
  ungroup()

# === Step 9: Finalize dataset ===
df_hek293_final <- df_hek293_final[, c("TargetGene","GuideID", "GuideSeq", "TargetSeqContext", "Log2FC.D30")]

df_supp9 <- read.delim("41587_2023_1830_MOESM12_ESM.txt", header = TRUE, sep = "\t")

# HAP1 off target data
# Load Supplementary Data 12 (MOESM15)
df_supp12 <- read.delim("41587_2023_1830_MOESM15_ESM.txt", header = TRUE, sep = "\t")

# === Step 2: Check column names carefully ===
colnames(df_supp9)
colnames(df_supp12)

# Suppose df_supp9 has the column "UID" and df_supp12 has "GuideUID"
# Rename UID in df_supp9 to match df_supp12
colnames(df_supp9)[1] <- "GuideUID" 

# Verify the renaming is correct:
colnames(df_supp9)

# === Step 3: Perform merge by GuideUID ===
df_off_target <- dplyr::inner_join(df_supp9, df_supp12, by = "GuideUID")

# Select key columns clearly
df_off_target <- df_off_target[, c("GeneName", "ID", "GuideSeq.x", "TargetSeqContext", "Observed.log2FC.D14")]

# Rename columns in df_off_target to match df_hek293_final
colnames(df_off_target) <- c("TargetGene", "GuideID", "GuideSeq", "TargetSeqContext", "Log2FC.D30")

# Combine the two datasets by appending rows
df_combined <- dplyr::bind_rows(df_hek293_final, df_off_target)

write.csv(df_combined, "off_target_activity_dataset.csv", row.names = FALSE)