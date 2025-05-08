# CBMF4761-Project
| Path / file            | Purpose                                                                                                                                                                               |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`data_processing/`** | Scripts & raw data needed to reproducibly build the training/validation dataset.                                                                                                      |
| `├── build_dataset.R`  | **R** script that ingests the original tiling‑screen CSVs, filters indels, labels guide types (PM/SM/DM/TM), performs gene‑wise split and writes `cas13d_dataset.csv`.                |
| `├── raw/`             | Original files from **Wessels *et al.* 2023** (HEK‑293 & HAP1 screens).                                                                                                               |
| **`CNN.ipynb`**        | Colab / Jupyter notebook that trains and evaluates the shallow and deep CNN baselines (0.6 M–2 M parameters).                                                                         |
| **`RNN.ipynb`**        | Notebook with CNN + BiLSTM + self‑attention, Transformer encoder variants, encoder–decoder cross‑attention model, plus Integrated‑Gradients interpretability & calibration utilities. |
| `README.md`            | You are here.                                                                                                                                                                         |

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

