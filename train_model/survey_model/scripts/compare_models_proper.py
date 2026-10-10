import pandas as pd
import numpy as np

from sklearn.model_selection import StratifiedKFold, cross_validate
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.linear_model import LogisticRegression

import xgboost as xgb


# ============================================================
# FILES
# ============================================================

DATA_FILE = "data/survey_selected_features.csv"
TARGET_COLUMN = "Have you ever diagnosed by Doctor"


# ============================================================
# LOAD ORIGINAL SELECTED SURVEY DATA
# ============================================================

df = pd.read_csv(DATA_FILE)

# Remove accidental spaces from column names
df.columns = df.columns.str.strip()

print("=" * 70)
print("PROPER LEAKAGE-FREE SURVEY MODEL COMPARISON")
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

# Keep only valid target values
df = df[
    df[TARGET_COLUMN].isin(["yes", "no"])
].copy()

# Convert target to 0/1
df[TARGET_COLUMN] = df[TARGET_COLUMN].map({
    "no": 0,
    "yes": 1
})


# ============================================================
# FEATURES / TARGET
# ============================================================

X = df.drop(columns=[TARGET_COLUMN])
y = df[TARGET_COLUMN].astype(int)


print("\nUsable samples:", len(X))
print("Number of raw features:", X.shape[1])

print("\nClass distribution:")
print(y.value_counts().sort_index())


# ============================================================
# DEFINE NUMERICAL AND CATEGORICAL FEATURES
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


# ============================================================
# PREPROCESSING
#
# IMPORTANT:
# This preprocessing is INSIDE the Pipeline.
# Therefore, during every CV fold:
#
# Training fold -> fit preprocessing
# Validation fold -> transform only
#
# This prevents preprocessing leakage.
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
# CLASS IMBALANCE
# ============================================================

negative_count = (y == 0).sum()
positive_count = (y == 1).sum()

scale_pos_weight = (
    negative_count / positive_count
)

print(
    "\nScale positive weight:",
    round(scale_pos_weight, 4)
)


# ============================================================
# CROSS VALIDATION
# ============================================================

cv = StratifiedKFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)


# ============================================================
# METRICS
# ============================================================

scoring = {

    "accuracy": "accuracy",

    "precision": "precision",

    "recall": "recall",

    "f1": "f1",

    "roc_auc": "roc_auc"
}


# ============================================================
# MODELS
# ============================================================

models = {

    # --------------------------------------------------------
    # LOGISTIC REGRESSION
    # --------------------------------------------------------

    "Logistic Regression": Pipeline(
        steps=[

            (
                "preprocessor",
                preprocessor
            ),

            (
                "model",
                LogisticRegression(
                    class_weight="balanced",
                    max_iter=2000,
                    random_state=42
                )
            )
        ]
    ),


    # --------------------------------------------------------
    # XGBOOST
    # --------------------------------------------------------

    "XGBoost": Pipeline(
        steps=[

            (
                "preprocessor",
                preprocessor
            ),

            (
                "model",
                xgb.XGBClassifier(

                    objective="binary:logistic",

                    eval_metric="logloss",

                    n_estimators=200,

                    max_depth=3,

                    learning_rate=0.05,

                    subsample=0.8,

                    colsample_bytree=0.8,

                    scale_pos_weight=scale_pos_weight,

                    random_state=42,

                    tree_method="hist"
                )
            )
        ]
    )
}


# ============================================================
# RUN MODELS
# ============================================================

all_results = []


for model_name, model in models.items():

    print("\n")
    print("=" * 70)
    print("MODEL:", model_name)
    print("=" * 70)

    results = cross_validate(
        model,
        X,
        y,
        cv=cv,
        scoring=scoring,
        n_jobs=1
    )


    # --------------------------------------------------------
    # FOLD RESULTS
    # --------------------------------------------------------

    print(
        "\nAccuracy:",
        np.round(
            results["test_accuracy"],
            4
        )
    )

    print(
        "Precision:",
        np.round(
            results["test_precision"],
            4
        )
    )

    print(
        "Recall:",
        np.round(
            results["test_recall"],
            4
        )
    )

    print(
        "F1:",
        np.round(
            results["test_f1"],
            4
        )
    )

    print(
        "ROC-AUC:",
        np.round(
            results["test_roc_auc"],
            4
        )
    )


    # --------------------------------------------------------
    # MEAN / STANDARD DEVIATION
    # --------------------------------------------------------

    row = {

        "Model": model_name,

        "Accuracy Mean":
            results["test_accuracy"].mean(),

        "Accuracy Std":
            results["test_accuracy"].std(),

        "Precision Mean":
            results["test_precision"].mean(),

        "Precision Std":
            results["test_precision"].std(),

        "Recall Mean":
            results["test_recall"].mean(),

        "Recall Std":
            results["test_recall"].std(),

        "F1 Mean":
            results["test_f1"].mean(),

        "F1 Std":
            results["test_f1"].std(),

        "ROC-AUC Mean":
            results["test_roc_auc"].mean(),

        "ROC-AUC Std":
            results["test_roc_auc"].std()
    }

    all_results.append(row)


# ============================================================
# FINAL COMPARISON
# ============================================================

comparison = pd.DataFrame(
    all_results
)


print("\n\n")
print("=" * 100)
print("FINAL LEAKAGE-FREE 5-FOLD CROSS-VALIDATION COMPARISON")
print("=" * 100)


display_columns = [

    "Model",

    "Accuracy Mean",
    "Accuracy Std",

    "Precision Mean",
    "Precision Std",

    "Recall Mean",
    "Recall Std",

    "F1 Mean",
    "F1 Std",

    "ROC-AUC Mean",
    "ROC-AUC Std"
]


print(
    comparison[
        display_columns
    ].round(4).to_string(index=False)
)


# ============================================================
# SAVE RESULTS
# ============================================================

output_file = (
    "models/model_comparison_proper_cv.csv"
)

comparison.to_csv(
    output_file,
    index=False
)


print("\n")
print("Results saved to:")
print(output_file)

print("\nProper model comparison completed successfully!")