import pandas as pd


# ============================================================
# PCOSense - Clinical Dataset Preprocessing
# ============================================================

INPUT_FILE = "data/PCOS_extended_dataset.csv"
OUTPUT_FILE = "data/clinical_preprocessed.csv"


# ------------------------------------------------------------
# 1. Load dataset
# ------------------------------------------------------------
df = pd.read_csv(INPUT_FILE)

print("Original dataset shape:", df.shape)


# ------------------------------------------------------------
# 2. Remove identifier columns
# ------------------------------------------------------------
DROP_COLUMNS = [
    "Sl. No",
    "Patient File No."
]

df = df.drop(columns=DROP_COLUMNS)


# ------------------------------------------------------------
# 3. Clean numeric columns stored as strings
# ------------------------------------------------------------

# II beta-HCG:
# Correct malformed values such as "1.99." → "1.99"
beta_hcg_col = "II    beta-HCG(mIU/mL)"

df[beta_hcg_col] = (
    df[beta_hcg_col]
    .astype(str)
    .str.replace(r"\.$", "", regex=True)
)

df[beta_hcg_col] = pd.to_numeric(
    df[beta_hcg_col],
    errors="coerce"
)


# AMH:
# Values such as "a" are treated as missing
amh_col = "AMH(ng/mL)"

df[amh_col] = pd.to_numeric(
    df[amh_col],
    errors="coerce"
)


# ------------------------------------------------------------
# 4. Handle missing values
# ------------------------------------------------------------

# Numeric columns
numeric_columns = df.select_dtypes(
    include=["int64", "float64"]
).columns

for column in numeric_columns:
    if df[column].isnull().any():
        df[column] = df[column].fillna(
            df[column].median()
        )


# ------------------------------------------------------------
# 5. Separate features and target
# ------------------------------------------------------------

TARGET_COLUMN = "PCOS (Y/N)"

X = df.drop(columns=[TARGET_COLUMN])
y = df[TARGET_COLUMN]


# ------------------------------------------------------------
# 6. Save preprocessed dataset
# ------------------------------------------------------------

processed_df = pd.concat(
    [X, y],
    axis=1
)

processed_df.to_csv(
    OUTPUT_FILE,
    index=False
)


# ------------------------------------------------------------
# 7. Display results
# ------------------------------------------------------------

print("Preprocessed dataset shape:", processed_df.shape)

print("\nRemaining missing values:")
print(processed_df.isnull().sum().sum())

print("\nPCOS distribution:")
print(y.value_counts())

print("\nPreprocessing completed successfully!")
print("Saved to:", OUTPUT_FILE)