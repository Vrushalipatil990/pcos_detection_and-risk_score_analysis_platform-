import pandas as pd
import numpy as np

from sklearn.model_selection import StratifiedKFold
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
    roc_auc_score
)

from imblearn.pipeline import Pipeline as ImbPipeline
from imblearn.over_sampling import SMOTE


# ============================================================
# SETTINGS
# ============================================================

DATA_FILE = "data/survey_selected_features.csv"

TARGET_COLUMN = "Have you ever diagnosed by Doctor"


# ============================================================
# LOAD DATA
# ============================================================

df = pd.read_csv(DATA_FILE)

df.columns = df.columns.str.strip()

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
# CROSS VALIDATION
# ============================================================

cv = StratifiedKFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)


# ============================================================
# MODELS
# ============================================================

models = {

    "Current Logistic Regression": Pipeline(
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
    ),

    "SMOTE + Logistic Regression": ImbPipeline(
        steps=[
            (
                "preprocessor",
                preprocessor
            ),
            (
                "smote",
                SMOTE(
                    random_state=42
                )
            ),
            (
                "classifier",
                LogisticRegression(
                    max_iter=2000,
                    random_state=42
                )
            )
        ]
    )
}


# ============================================================
# EVALUATION
# ============================================================

all_results = []


for model_name, model in models.items():

    print("\n")
    print("=" * 70)
    print("MODEL:", model_name)
    print("=" * 70)

    fold_accuracy = []
    fold_precision = []
    fold_recall = []
    fold_f1 = []
    fold_auc = []


    for fold, (train_index, test_index) in enumerate(
        cv.split(X, y),
        start=1
    ):

        X_train = X.iloc[train_index]
        X_valid = X.iloc[test_index]

        y_train = y.iloc[train_index]
        y_valid = y.iloc[test_index]


        model.fit(
            X_train,
            y_train
        )


        y_pred = model.predict(
            X_valid
        )

        y_prob = model.predict_proba(
            X_valid
        )[:, 1]


        accuracy = accuracy_score(
            y_valid,
            y_pred
        )

        precision = precision_score(
            y_valid,
            y_pred,
            zero_division=0
        )

        recall = recall_score(
            y_valid,
            y_pred,
            zero_division=0
        )

        f1 = f1_score(
            y_valid,
            y_pred,
            zero_division=0
        )

        auc = roc_auc_score(
            y_valid,
            y_prob
        )


        fold_accuracy.append(accuracy)
        fold_precision.append(precision)
        fold_recall.append(recall)
        fold_f1.append(f1)
        fold_auc.append(auc)


        print(
            f"\nFold {fold}:"
        )

        print(
            f"  Accuracy : {accuracy:.4f}"
        )

        print(
            f"  Precision: {precision:.4f}"
        )

        print(
            f"  Recall   : {recall:.4f}"
        )

        print(
            f"  F1       : {f1:.4f}"
        )

        print(
            f"  ROC-AUC  : {auc:.4f}"
        )


    # ========================================================
    # MEAN RESULTS
    # ========================================================

    row = {

        "Model": model_name,

        "Accuracy Mean":
            np.mean(fold_accuracy),

        "Accuracy Std":
            np.std(fold_accuracy),

        "Precision Mean":
            np.mean(fold_precision),

        "Precision Std":
            np.std(fold_precision),

        "Recall Mean":
            np.mean(fold_recall),

        "Recall Std":
            np.std(fold_recall),

        "F1 Mean":
            np.mean(fold_f1),

        "F1 Std":
            np.std(fold_f1),

        "ROC-AUC Mean":
            np.mean(fold_auc),

        "ROC-AUC Std":
            np.std(fold_auc)
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
print("SMOTE VS CURRENT MODEL")
print("=" * 100)

print(
    comparison.round(4).to_string(
        index=False
    )
)


# ============================================================
# SAVE RESULTS
# ============================================================

output_file = (
    "models/smote_comparison_cv.csv"
)

comparison.to_csv(
    output_file,
    index=False
)


print("\nResults saved to:")
print(output_file)

print("\nSMOTE experiment completed successfully!")