import pandas as pd
import joblib

from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.linear_model import LogisticRegression

from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    roc_auc_score,
    confusion_matrix,
    classification_report
)


# ============================================================
# SETTINGS
# ============================================================

DATA_FILE = "data/survey_selected_features.csv"
MODEL_FILE = "models/survey_logistic_regression.pkl"

TARGET_COLUMN = "Have you ever diagnosed by Doctor"


# ============================================================
# LOAD RAW SURVEY DATA
# ============================================================

df = pd.read_csv(DATA_FILE)

df.columns = df.columns.str.strip()

print("=" * 70)
print("FINAL SURVEY MODEL - LOGISTIC REGRESSION")
print("=" * 70)

print("\nDataset shape:", df.shape)


# ============================================================
# TARGET
# ============================================================

df[TARGET_COLUMN] = (
    df[TARGET_COLUMN]
    .astype(str)
    .str.strip()
    .str.lower()
)

df = df[
    df[TARGET_COLUMN].isin(["yes", "no"])
].copy()

df[TARGET_COLUMN] = df[TARGET_COLUMN].map({
    "no": 0,
    "yes": 1
})


# ============================================================
# FEATURES
# ============================================================

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

feature_columns = (
    numerical_features +
    categorical_features
)

X = df[feature_columns]
y = df[TARGET_COLUMN].astype(int)


print("\nRaw features:", X.shape[1])
print("Training will use the original 13 questionnaire features.")


# ============================================================
# TRAIN / TEST SPLIT
# ============================================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)

print("\nTraining samples:", len(X_train))
print("Testing samples :", len(X_test))


# ============================================================
# PREPROCESSING
# ============================================================

numeric_pipeline = Pipeline(
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


preprocessor = ColumnTransformer(
    transformers=[
        (
            "numerical",
            numeric_pipeline,
            numerical_features
        ),
        (
            "categorical",
            categorical_pipeline,
            categorical_features
        )
    ]
)


# ============================================================
# COMPLETE MODEL PIPELINE
# ============================================================

model = Pipeline(
    steps=[
        (
            "preprocessor",
            preprocessor
        ),
        (
            "classifier",
            LogisticRegression(
                class_weight="balanced",
                max_iter=2000,
                random_state=42
            )
        )
    ]
)


# ============================================================
# TRAIN
# ============================================================

print("\nTraining final model...")

model.fit(
    X_train,
    y_train
)

print("Training completed successfully!")


# ============================================================
# TEST
# ============================================================

y_pred = model.predict(X_test)

y_probability = model.predict_proba(
    X_test
)[:, 1]


# ============================================================
# METRICS
# ============================================================

accuracy = accuracy_score(
    y_test,
    y_pred
)

precision = precision_score(
    y_test,
    y_pred,
    zero_division=0
)

recall = recall_score(
    y_test,
    y_pred,
    zero_division=0
)

f1 = f1_score(
    y_test,
    y_pred,
    zero_division=0
)

roc_auc = roc_auc_score(
    y_test,
    y_probability
)


# ============================================================
# RESULTS
# ============================================================

print("\n")
print("=" * 70)
print("FINAL TEST RESULTS")
print("=" * 70)

print(f"\nAccuracy : {accuracy * 100:.2f}%")
print(f"Precision: {precision * 100:.2f}%")
print(f"Recall   : {recall * 100:.2f}%")
print(f"F1 Score : {f1 * 100:.2f}%")
print(f"ROC-AUC  : {roc_auc * 100:.2f}%")


# ============================================================
# CONFUSION MATRIX
# ============================================================

print("\nConfusion Matrix:")

print(
    confusion_matrix(
        y_test,
        y_pred
    )
)


# ============================================================
# CLASSIFICATION REPORT
# ============================================================

print("\nClassification Report:")

print(
    classification_report(
        y_test,
        y_pred,
        target_names=["No", "Yes"],
        zero_division=0
    )
)


# ============================================================
# SAVE COMPLETE PIPELINE
# ============================================================

joblib.dump(
    model,
    MODEL_FILE
)

print("\nFinal model saved to:")
print(MODEL_FILE)

print("\nSaved pipeline contains:")
print("  Raw questionnaire input")
print("       ↓")
print("  Missing-value handling")
print("       ↓")
print("  One-hot encoding")
print("       ↓")
print("  Standard scaling")
print("       ↓")
print("  Logistic Regression")

print("\nFinal survey model training completed successfully!")