import pandas as pd
from pathlib import Path


# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

INPUT_FILE = BASE_DIR / "data" / "survey_categorical_cleaned.csv"
OUTPUT_FILE = BASE_DIR / "data" / "survey_selected_features.csv"


# --------------------------------------------------
# 2. Load dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

# Remove extra spaces from column names
df.columns = df.columns.str.strip()

print("\n========== FEATURE SELECTION ==========")

print("\nOriginal dataset shape:")
print(df.shape)


# --------------------------------------------------
# 3. Define ML prediction features
# --------------------------------------------------
#
# These features are selected for PCOS risk prediction.
#
# We use:
# - Age
# - BMI
# - Menstrual characteristics
# - PCOS-related symptoms
# - Family history
#
# Height and Weight are retained in the cleaned dataset,
# but BMI is used as the main body-measure feature.
#
# --------------------------------------------------

prediction_features = [

    # Demographic / body measurement
    "Age",
    "BMI",

    # Menstrual characteristics
    "How regular are your periods",
    "How often do you miss you periods",
    "How does long your periods usually last",
    "Have you noticed a significant change in your periods during the last year",
    "Do you experience unusually heavy menstrual bleeding",

    # PCOS-related symptoms
    "Do you experience exceesive facial & body hair growth",
    "Do you experience acne",
    "Have you experienced unusual hair thinning or hair loss",
    "Have you experienced unexplained weight gain?",
    "Have you noticed dark or thickened skin, especially around your neck",

    # Family history
    "Does anyone from your family have a pcos"
]


# --------------------------------------------------
# 4. Define target
# --------------------------------------------------

target_column = "Have you ever diagnosed by Doctor"


# --------------------------------------------------
# 5. Check whether required columns exist
# --------------------------------------------------

required_columns = prediction_features + [target_column]

missing_columns = [
    col for col in required_columns
    if col not in df.columns
]

if missing_columns:

    print("\nERROR: The following required columns are missing:")

    for col in missing_columns:
        print("-", col)

    raise ValueError(
        "Feature selection cannot continue because "
        "required columns are missing."
    )


# --------------------------------------------------
# 6. Keep only selected features + target
# --------------------------------------------------

selected_columns = prediction_features + [target_column]

selected_df = df[selected_columns].copy()


# --------------------------------------------------
# 7. Remove rows with missing target
# --------------------------------------------------
#
# The target is the doctor's diagnosis response.
# The 2 rows without a target cannot be used for
# supervised model training.
#
# --------------------------------------------------

before_target_filter = len(selected_df)

selected_df = selected_df.dropna(
    subset=[target_column]
)

after_target_filter = len(selected_df)

removed_target_rows = (
    before_target_filter - after_target_filter
)


# --------------------------------------------------
# 8. Display selected features
# --------------------------------------------------

print("\n========== SELECTED ML FEATURES ==========")

for i, feature in enumerate(prediction_features, start=1):
    print(f"{i}. {feature}")


print("\nTarget:")
print(target_column)


# --------------------------------------------------
# 9. Display dataset information
# --------------------------------------------------

print("\n========== TARGET DISTRIBUTION ==========")

print(
    selected_df[target_column]
    .value_counts(dropna=False)
)


print("\n========== MISSING VALUES ==========")

print(
    selected_df.isnull().sum()
)


# --------------------------------------------------
# 10. Display final shape
# --------------------------------------------------

print("\n========== FINAL SELECTED DATASET ==========")

print("Shape before removing missing target:")
print((before_target_filter, len(selected_columns)))

print("Rows removed because target was missing:")
print(removed_target_rows)

print("Final shape:")
print(selected_df.shape)


# --------------------------------------------------
# 11. Save selected dataset
# --------------------------------------------------

selected_df.to_csv(
    OUTPUT_FILE,
    index=False
)

print("\n========== COMPLETE ==========")

print("Selected feature dataset saved to:")

print(OUTPUT_FILE)