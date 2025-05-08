# CBMF4761-Project
# Project Structure & File Descriptions
# Data_processing_R                                                                                                                                                      
| File                                                       | Description                                                                                                                                                              |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `41587_2023_1830_MOESM3_ESM.csv` to `MOESM16_ESM.csv/.txt` | Supplementary data files from the *Nature Biotech* TIGER paper. Includes gRNA annotations, sequence contexts, off-target mismatches, and experimental activity (log₂FC). |
| `on_target_data_processing.R`                              | R script to load and clean on-target guide data, including filtering for perfect-match guides and joining with target metadata.                                          |
| `off_target_data_processing.R`                             | Processes and filters mismatch-containing off-target guides (SM, DM, TM), including alignment and subtype classification.                                                |
| `combine_on_off_data.R`                                    | Merges on-target and off-target datasets into one unified CSV used in model training.                                                                                    |
| `library.R`                                                | Shared utility functions (e.g., file loaders, sequence matchers).                                                                                                        |
| `variance_by_biological_factors.R`                         | Analyzes contribution of known biological features (e.g. mfe, accessibility) to guide activity variance.                                                                 |
| `CBMF4761.Rproj`                                           | RStudio project file for reproducibility and version control within RStudio.                                                                                             |

# Jupyter Notebooks
| Notebook            | Purpose                                                                                                                                                                                                 |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CNN.ipynb`         | Trains and evaluates shallow and deep **Convolutional Neural Networks** (CNNs) on guide activity prediction. Useful as a baseline.                                                                      |
| `RNN.ipynb`         | Implements **BiLSTM** (bidirectional LSTM) and CNN+RNN hybrid architectures with self-attention. Includes Integrated Gradients interpretation and performance plots.                                    |
| `Transformer.ipynb` | Implements Transformer encoder-only and encoder–decoder models, with alignment-based input preparation and optional cross-attention between guide and target. Best performance among all tested models. |

# Quick start
Run the R script in the folder Data_processing_R to obtain the dataset used for training, and the rest can all be done on google colab, by downloading and running all the ipynb files on colab.

# Requirements
GPU is optional but recommended.Training the largest Transformer (~1.5M parameters) takes ~5min on an RTX3060; ~45min on CPU.

Package "captum" may be required to download, if error exists "no module named captum". 

Running notebooks on large files / custom data
1.Place your FASTA / screening summary as my_guides.csv with columns TargetSeqContext, GuideSeq, log2FC, TargetGene. 
2.Open CNN/RNN/Transformer.ipynb → “Replace dataset” cell → change path to your file.
3.Tune hyper‑parameters in “Config” cell (batch size, epochs, model depth).


<details>
<summary><strong>Project tree</strong></summary>

    .
    ├── Data_processing_R
    │   ├── 41587_2023_1830_MOESM10_ESM.txt
    │   ├── 41587_2023_1830_MOESM11_ESM.txt
    │   ├── 41587_2023_1830_MOESM12_ESM.txt
    │   ├── 41587_2023_1830_MOESM13_ESM.csv
    │   ├── 41587_2023_1830_MOESM14_ESM.txt
    │   ├── 41587_2023_1830_MOESM15_ESM.txt
    │   ├── 41587_2023_1830_MOESM16_ESM.csv
    │   ├── 41587_2023_1830_MOESM3_ESM.csv
    │   ├── 41587_2023_1830_MOESM4_ESM.csv
    │   ├── 41587_2023_1830_MOESM5_ESM.csv
    │   ├── 41587_2023_1830_MOESM6_ESM.csv
    │   ├── 41587_2023_1830_MOESM7_ESM.txt
    │   ├── 41587_2023_1830_MOESM8_ESM.csv
    │   ├── 41587_2023_1830_MOESM9_ESM.txt
    │   ├── CBMF4761.Rproj
    │   ├── combine_on_off_data.R
    │   ├── library.R
    │   ├── off_target_data_processing.R
    │   ├── on_target_data_processing.R
    │   └── variance_by_biological_factors.R
    ├── CNN.ipynb
    ├── README.md
    ├── RNN.ipynb
    └── Transformer.ipynb
    
    2 directories, 24 files
</details>

