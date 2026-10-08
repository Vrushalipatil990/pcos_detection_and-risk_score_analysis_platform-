import pandas as pd
import numpy as np
from pathlib import Path

from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.impute import SimpleImputer


# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

INPUT_FILE = BASE_DIR / "data" / "survey_selected_features.csv"

X_TRAIN_FILE = BASE_DIR / "data" / "X_train.csv"
X_TEST_FILE = BASE_DIR / "data" / "X_test.csv"
Y_TRAIN_FILE = BASE_DIR / "data" / "y_train.csv"
Y_TEST_FILE = BASE_DIR / "data" / "y_test.csv"


# --------------------------------------------------
# 2. Load selected dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

df.columns = df.columns.str.strip()

print("\n========== MODEL PREPROCESSING ==========")

print("\nInput dataset shape:")
print(df.shape)


# --------------------------------------------------
# 3. Define target
# --------------------------------------------------

TARGET = "Have you ever diagnosed by Doctor"


# --------------------------------------------------
# 4. Separate X and y
# --------------------------------------------------

X = df.drop(columns=[TARGET])

y = df[TARGET].map({
    "no": 0,
    "yes": 1
})


# --------------------------------------------------
# 5. Check target conversion
# --------------------------------------------------

print("\n========== TARGET ENCODING ==========")

print(y.value_counts(dropna=False))

if y.isnull().any():
    raise ValueError(
        "Target contains unexpected values after encoding."
    )


# --------------------------------------------------
# 6. Identify numerical and categorical features
# --------------------------------------------------

numerical_features = [
    "Age",
    "BMI"
]

categorical_features = [
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
    "Does anyone from your family have a pcos"
]


# --------------------------------------------------
# 7. Verify columns
# --------------------------------------------------

required_features = numerical_features + categorical_features

missing_features = [
    col for col in required_features
    if col not in X.columns
]

if missing_features:

    print("\nERROR: Missing features:")

    for col in missing_features:
        print("-", col)

    raise ValueError(
        "Some expected model features are missing."
    )


# --------------------------------------------------
# 8. Train/Test Split
# --------------------------------------------------
#
# Stratification keeps approximately the same
# yes/no class distribution in train and test data.
#
# --------------------------------------------------

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)


print("\n========== TRAIN / TEST SPLIT ==========")

print("Training samples:", len(X_train))
print("Testing samples:", len(X_test))

print("\nTraining target distribution:")
print(y_train.value_counts())

print("\nTesting target distribution:")
print(y_test.value_counts())


# --------------------------------------------------
# 9. Numerical preprocessing
# --------------------------------------------------
#
# BMI has 8 missing values.
#
# We replace missing numerical values with the
# median calculated from the training data.
#
# StandardScaler puts numerical features on a
# comparable scale.
#
# --------------------------------------------------

numerical_pipeline = Pipeline(
    steps=[
        (
            "imputer",
            SimpleImputer(strategy="median")
        ),
        (
            "scaler",
            StandardScaler()
        )
    ]
)


# --------------------------------------------------
# 10. Categorical preprocessing
# --------------------------------------------------
#
# Missing categorical values are replaced by the
# most frequent category.
#
# OneHotEncoder converts categories into numerical
# columns that ML models can understand.
#
# handle_unknown="ignore" ensures that a new user
# category does not crash the model.
#
# --------------------------------------------------

categorical_pipeline = Pipeline(
    steps=[
        (
            "imputer",
            SimpleImputer(strategy="most_frequent")
        ),
        (
            "onehot",
            OneHotEncoder(
                handle_unknown="ignore",
                sparse_output=False
            )
        )
    ]
)


# --------------------------------------------------
# 11. Combine preprocessing pipelines
# --------------------------------------------------

preprocessor = ColumnTransformer(
    transformers=[
        (
            "numerical",
            numerical_pipeline,
            numerical_features
        ),
        (
            "categorical",
            categorical_pipeline,
            categorical_features
        )
    ]
)


# --------------------------------------------------
# 12. Fit preprocessing ONLY on training data
# --------------------------------------------------
#
# This prevents information from the test set from
# leaking into the training process.
#
# --------------------------------------------------

X_train_processed = preprocessor.fit_transform(X_train)

X_test_processed = preprocessor.transform(X_test)


# --------------------------------------------------
# 13. Get encoded feature names
# --------------------------------------------------

feature_names = preprocessor.get_feature_names_out()


# --------------------------------------------------
# 14. Convert processed data to DataFrames
# --------------------------------------------------

X_train_processed = pd.DataFrame(
    X_train_processed,
    columns=feature_names,
    index=X_train.index
)

X_test_processed = pd.DataFrame(
    X_test_processed,
    columns=feature_names,
    index=X_test.index
)


# --------------------------------------------------
# 15. Save processed datasets
# --------------------------------------------------

X_train_processed.to_csv(
    X_TRAIN_FILE,
    index=False
)

X_test_processed.to_csv(
    X_TEST_FILE,
    index=False
)

y_train.to_csv(
    Y_TRAIN_FILE,
    index=False,
    header=True
)

y_test.to_csv(
    Y_TEST_FILE,
    index=False,
    header=True
)


# --------------------------------------------------
# 16. Display final information
# --------------------------------------------------

print("\n========== PREPROCESSING COMPLETE ==========")

print("\nOriginal features:", X.shape[1])

print("Encoded features:", X_train_processed.shape[1])

print("\nProcessed training shape:")
print(X_train_processed.shape)

print("\nProcessed testing shape:")
print(X_test_processed.shape)

print("\nMissing values in X_train:")
print(X_train_processed.isnull().sum().sum())

print("\nMissing values in X_test:")
print(X_test_processed.isnull().sum().sum())


# --------------------------------------------------
# 17. Display sample of processed data
# --------------------------------------------------

print("\n========== PROCESSED DATA SAMPLE ==========")

print(
    X_train_processed.head()
)


# --------------------------------------------------
# 18. Display saved files
# --------------------------------------------------

print("\n========== FILES SAVED ==========")

print(X_TRAIN_FILE)
print(X_TEST_FILE)
print(Y_TRAIN_FILE)
print(Y_TEST_FILE)