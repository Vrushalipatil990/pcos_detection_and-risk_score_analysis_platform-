import pandas as pd
from pathlib import Path

# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent
INPUT_FILE = BASE_DIR / "data" / "Survey_responses.csv"

# --------------------------------------------------
# 2. Load dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

# Remove extra spaces from column names
df.columns = df.columns.str.strip()

print("\n========== DATASET SHAPE ==========")
print(df.shape)

print("\n========== COLUMN NAMES ==========")
for i, col in enumerate(df.columns, start=1):
    print(f"{i}. {col}")

# --------------------------------------------------
# 3. Missing values
# --------------------------------------------------

print("\n========== MISSING VALUES ==========")
print(df.isnull().sum())

# --------------------------------------------------
# 4. Data types
# --------------------------------------------------

print("\n========== DATA TYPES ==========")
print(df.dtypes)

# --------------------------------------------------
# 5. Target distribution
# --------------------------------------------------

target = "Have you ever diagnosed by Doctor"

print("\n========== TARGET DISTRIBUTION ==========")
print(df[target].value_counts(dropna=False))

# --------------------------------------------------
# 6. Unique values of important columns
# --------------------------------------------------

remaining_columns = [
    "Have you experienced unusual hair thinning or hair loss",
    "Have you experienced unexplained weight gain?",
    "Have you noticed dark or thickened skin, especially around your neck",
    "How many days per week do you perform exercise",
    "Approximately how long do you exercise per session",
    "What type of physical activity do you usually perform",
    "How many hours do you usually sleep per night",
    "How would you describe your usual stress level",
    "How frequently do you consume sugary drinks or foods",
    "How frequently do you consume fast food or highly processed food?",
    "How frequently do you eat fruits and vegetables?",
    "What type of diet do you mainly follow",
    "How many meals do you usually have per day?",
    "How often do you experienced sugar cravings",
    "Does anyone from your family have a pcos"
]

print("\n========== REMAINING UNIQUE VALUES ==========")

for col in remaining_columns:
    if col in df.columns:
        print(f"\n--- {col} ---")
        print(df[col].value_counts(dropna=False))
    else:
        print(f"\nCOLUMN NOT FOUND: {col}")