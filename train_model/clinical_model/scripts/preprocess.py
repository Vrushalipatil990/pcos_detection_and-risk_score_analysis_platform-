import pandas as pd

# --------------------------------------------------
# File paths
# --------------------------------------------------

INPUT_FILE = "data/PCOS_extended_dataset.csv"
OUTPUT_FILE = "data/clinical_preprocessed.csv"

TARGET_COLUMN = "PCOS (Y/N)"

# --------------------------------------------------
# Load dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

print("Original dataset shape:", df.shape)

# --------------------------------------------------
# Drop unnecessary columns
# --------------------------------------------------

DROP_COLUMNS = [
    "Sl. No",
    "Patient File No."
]

df = df.drop(columns=DROP_COLUMNS)

# --------------------------------------------------
# Clean II beta-HCG
# --------------------------------------------------

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

# --------------------------------------------------
# Clean AMH
# --------------------------------------------------

amh_col = "AMH(ng/mL)"

df[amh_col] = pd.to_numeric(
    df[amh_col],
    errors="coerce"
)

# --------------------------------------------------
# Convert remaining numeric columns
# --------------------------------------------------

for column in df.columns:

    if column == TARGET_COLUMN:
        continue

    # Try converting object columns to numeric
    if df[column].dtype == "object":

        converted = pd.to_numeric(
            df[column],
            errors="coerce"
        )

        # Use converted version if it is
        # mostly numeric
        if converted.notna().sum() > 0:
            df[column] = converted

# --------------------------------------------------
# Ensure target is numeric
# --------------------------------------------------

df[TARGET_COLUMN] = pd.to_numeric(
    df[TARGET_COLUMN],
    errors="coerce"
)

# --------------------------------------------------
# Display missing values
#
# IMPORTANT:
# We do NOT fill missing values here.
# XGBoost can handle NaN values directly.
# --------------------------------------------------

missing_values = df.isnull().sum()

print("\nMissing values after cleaning:")

print(
    missing_values[
        missing_values > 0
    ]
)

print(
    "\nTotal missing values:",
    df.isnull().sum().sum()
)

# --------------------------------------------------
# Save preprocessed dataset
# --------------------------------------------------

df.to_csv(
    OUTPUT_FILE,
    index=False
)

print(
    "\nPreprocessed dataset shape:",
    df.shape
)

print("\nPCOS distribution:")
print(
    df[TARGET_COLUMN].value_counts()
)

print("\nPreprocessing completed successfully!")
print("Saved to:", OUTPUT_FILE)