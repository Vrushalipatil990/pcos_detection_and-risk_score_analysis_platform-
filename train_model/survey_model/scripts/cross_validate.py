import pandas as pd
import numpy as np
import xgboost as xgb

from sklearn.model_selection import StratifiedKFold, cross_validate


# ============================================================
# LOAD TRAINING DATA
# ============================================================

X_train = pd.read_csv("data/X_train.csv")
y_train = pd.read_csv("data/y_train.csv").iloc[:, 0].astype(int)

X_train = X_train.astype(float)


# ============================================================
# CLASS BALANCE
# ============================================================

negative_count = (y_train == 0).sum()
positive_count = (y_train == 1).sum()

scale_pos_weight = negative_count / positive_count

print("Training samples:", len(X_train))
print("Number of features:", X_train.shape[1])
print("Class 0:", negative_count)
print("Class 1:", positive_count)
print("Scale positive weight:", round(scale_pos_weight, 4))


# ============================================================
# XGBOOST MODEL
# ============================================================

model = xgb.XGBClassifier(
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


# ============================================================
# STRATIFIED 5-FOLD CROSS VALIDATION
# ============================================================

cv = StratifiedKFold(
    n_splits=5,
    shuffle=True,
    random_state=42
)


scoring = {
    "accuracy": "accuracy",
    "precision": "precision",
    "recall": "recall",
    "f1": "f1",
    "roc_auc": "roc_auc"
}


print("\nRunning 5-fold cross-validation...")

results = cross_validate(
    model,
    X_train,
    y_train,
    cv=cv,
    scoring=scoring
)


# ============================================================
# DISPLAY FOLD RESULTS
# ============================================================

print("\n" + "=" * 60)
print("5-FOLD CROSS-VALIDATION RESULTS")
print("=" * 60)

for metric in scoring.keys():

    values = results[
        "test_" + metric
    ]

    print(
        f"\n{metric.upper()}:"
    )

    print(
        "Fold scores:",
        np.round(values, 4)
    )

    print(
        "Mean:",
        round(values.mean(), 4)
    )

    print(
        "Std :",
        round(values.std(), 4)
    )


print("\nCross-validation completed successfully!")