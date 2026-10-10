import pandas as pd
from pathlib import Path


# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

INPUT_FILE = BASE_DIR / "data" / "survey_height_weight_cleaned.csv"
OUTPUT_FILE = BASE_DIR / "data" / "survey_categorical_cleaned.csv"


# --------------------------------------------------
# 2. Load dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

# Remove extra spaces from column names
df.columns = df.columns.str.strip()


print("\n========== CATEGORICAL CLEANING ==========")

print("\nOriginal dataset shape:")
print(df.shape)


# --------------------------------------------------
# 3. Basic text cleaning
# --------------------------------------------------
# Remove unnecessary spaces from all text columns
# without changing the actual meaning of responses.

text_columns = df.select_dtypes(include="object").columns

for col in text_columns:
    df[col] = df[col].apply(
        lambda x: x.strip() if isinstance(x, str) else x
    )


# --------------------------------------------------
# 4. Standardize Yes / No / Don't Know responses
# --------------------------------------------------

yes_no_columns = [
    "Have you noticed a significant change in your periods during the last year",
    "Do you experience unusually heavy menstrual bleeding",
    "Do you experience exceesive facial & body hair growth",
    "Have you experienced unusual hair thinning or hair loss",
    "Have you experienced unexplained weight gain?",
    "Have you noticed dark or thickened skin, especially around your neck",
    "Does anyone from your family have a pcos",
    "Have you ever diagnosed by Doctor"
]


for col in yes_no_columns:

    if col not in df.columns:
        continue

    df[col] = df[col].apply(
        lambda x: x.strip().lower()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 5. Standardize Period Regularity
# --------------------------------------------------

col = "How regular are your periods"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip().lower()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({
        "regular": "Regular",
        "sometimes irregular": "Sometimes irregular",
        "irregular": "Irregular",
        "not sure": "Not Sure"
    })


# --------------------------------------------------
# 6. Standardize Missed Periods
# --------------------------------------------------

col = "How often do you miss you periods"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip().lower()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({
        "never": "Never",
        "rarely": "Rarely",
        "sometimes": "Sometimes",
        "frequently": "Frequently"
    })


# --------------------------------------------------
# 7. Standardize Period Duration
# --------------------------------------------------

col = "How does long your periods usually last"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 8. Standardize Heavy Bleeding
# --------------------------------------------------

col = "Do you experience unusually heavy menstrual bleeding"

if col in df.columns:

    df[col] = df[col].replace({
        "sometimes": "Sometimes",
        "rarely": "Rarely",
        "never": "Never",
        "not sure": "Not Sure",
        "frequently": "Frequently"
    })


# --------------------------------------------------
# 9. Standardize Acne
# --------------------------------------------------

col = "Do you experience acne"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({
        "mild": "Mild",
        "moderate": "Moderate",
        "no": "No",
        "not sure": "Not Sure"
    })


# --------------------------------------------------
# 10. Standardize Exercise Days
# --------------------------------------------------

col = "How many days per week do you perform exercise"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 11. Standardize Exercise Duration
# --------------------------------------------------

col = "Approximately how long do you exercise per session"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 12. Clean Physical Activity Type
# --------------------------------------------------
# This column will mainly be useful later for
# personalized recommendations.
#
# We only remove extra spaces here.
# We do NOT aggressively merge different
# activities.

col = "What type of physical activity do you usually perform"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 13. Standardize Sleep
# --------------------------------------------------

col = "How many hours do you usually sleep per night"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 14. Standardize Stress
# --------------------------------------------------

col = "How would you describe your usual stress level"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({
        "low": "Low",
        "moderate": "Moderate",
        "high": "High",
        "very high": "Very High"
    })


# --------------------------------------------------
# 15. Standardize Diet
# --------------------------------------------------
# Several responses in the survey represent the
# same broad category.

col = "What type of diet do you mainly follow"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip().lower()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({

        "vegetarian": "Vegetarian",

        "non-vegetarian": "Non-vegetarian",
        "non vegetarian": "Non-vegetarian",

        "both": "Both",
        "both balanced": "Both",
        "depends both": "Both",
        "depends, both": "Both",
        "mix": "Both",
        "boph": "Both",

        "eggitarian": "Eggitarian"
    })


# --------------------------------------------------
# 16. Standardize Meals Per Day
# --------------------------------------------------

col = "How many meals do you usually have per day"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )


# --------------------------------------------------
# 17. Standardize Family History
# --------------------------------------------------

col = "Does anyone from your family have a pcos"

if col in df.columns:

    df[col] = df[col].apply(
        lambda x: x.strip()
        if isinstance(x, str)
        else x
    )

    df[col] = df[col].replace({
        "yes": "Yes",
        "no": "No",
        "don't know": "Don't Know"
    })


# --------------------------------------------------
# 18. Display categorical values after cleaning
# --------------------------------------------------

print("\n========== UNIQUE VALUES AFTER CLEANING ==========")

categorical_columns = [
    "How regular are your periods",
    "How often do you miss you periods",
    "How does long your periods usually last",
    "Have you noticed a significant change in your periods during the last year",
    "Do you experience unusually heavy menstrual bleeding",
    "Do you experience exceesive facial & body hair growth",
    "Do you experience acne",
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
    "Does anyone from your family have a pcos",
    "Have you ever diagnosed by Doctor"
]


for col in categorical_columns:

    if col in df.columns:

        print(f"\n--- {col} ---")
        print(df[col].value_counts(dropna=False))


# --------------------------------------------------
# 19. Check missing values
# --------------------------------------------------

print("\n========== MISSING VALUES AFTER CLEANING ==========")

print(
    df.isnull().sum()
)


# --------------------------------------------------
# 20. Save cleaned dataset
# --------------------------------------------------

df.to_csv(
    OUTPUT_FILE,
    index=False
)

print("\n========== COMPLETE ==========")

print("Categorical cleaned file saved to:")

print(OUTPUT_FILE)

print("\nFinal dataset shape:")
print(df.shape)