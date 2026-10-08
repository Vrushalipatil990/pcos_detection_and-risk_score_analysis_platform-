import pandas as pd
import numpy as np

from sklearn.model_selection import StratifiedKFold, cross_validate
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

import xgboost as xgb


# ============================================================
# LOAD DATA
# ============================================================

X_train = pd.read_csv("data/X_train.csv")
y_train = pd.read_csv("data/y_train.csv").iloc[:, 0].astype(int)

X_test = pd.read_csv("data/X_test.csv")
y_test = pd.read_csv("data/y_test.csv").iloc[:, 0].astype(int)


# Make sure all features are numeric
X_train = X_train.astype(float)
X_test = X_test.astype(float)


print("=" * 70)
print("SURVEY MODEL - MODEL COMPARISON")
print("=" * 70)

print("\nTraining samples :", len(X_train))
print("Testing samples  :", len(X_test))
print("Number of features:", X_train.shape[1])

print("\nTraining class distribution:")
print(y_train.value_counts().sort_index())


# ============================================================
# HANDLE CLASS IMBALANCE
# ============================================================

negative_count = (y_train == 0).sum()
positive_count = (y_train == 1).sum()

scale_pos_weight = negative_count / positive_count

print(
    "\nScale positive weight:",
    round(scale_pos_weight, 4)
)


# ============================================================
# 5-FOLD STRATIFIED CROSS VALIDATION
# ============================================================

cv = StratifiedKFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)


# ============================================================
# EVALUATION METRICS
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
                "imputer",
                SimpleImputer(
                    strategy="median"
                )
            ),

            (
                "scaler",
                StandardScaler()
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

    "XGBoost": xgb.XGBClassifier(

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
}


# ============================================================
# RUN CROSS VALIDATION
# ============================================================

all_results = []


for model_name, model in models.items():

    print("\n")
    print("=" * 70)
    print("MODEL:", model_name)
    print("=" * 70)

    results = cross_validate(
        model,
        X_train,
        y_train,
        cv=cv,
        scoring=scoring,
        n_jobs=1
    )


    # --------------------------------------------------------
    # Print fold results
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
    # Calculate mean and standard deviation
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
# CREATE COMPARISON TABLE
# ============================================================

comparison = pd.DataFrame(
    all_results
)


print("\n\n")
print("=" * 90)
print("5-FOLD CROSS-VALIDATION MODEL COMPARISON")
print("=" * 90)


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

output_file = "models/model_comparison_cv.csv"

comparison.to_csv(
    output_file,
    index=False
)


print("\n")
print("Comparison saved to:")
print(output_file)

print("\nModel comparison completed successfully!")