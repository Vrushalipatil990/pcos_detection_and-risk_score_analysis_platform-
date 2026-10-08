import pandas as pd
import numpy as np
import xgboost as xgb

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
# FILE PATHS
# ============================================================

TRAIN_X_FILE = "data/X_train.csv"
TEST_X_FILE = "data/X_test.csv"

TRAIN_Y_FILE = "data/y_train.csv"
TEST_Y_FILE = "data/y_test.csv"

MODEL_FILE = "models/survey_xgboost.json"


# ============================================================
# LOAD DATA
# ============================================================

X_train = pd.read_csv(TRAIN_X_FILE)
X_test = pd.read_csv(TEST_X_FILE)

y_train = pd.read_csv(TRAIN_Y_FILE).iloc[:, 0].astype(int)
y_test = pd.read_csv(TEST_Y_FILE).iloc[:, 0].astype(int)


print("Training data shape:", X_train.shape)
print("Testing data shape :", X_test.shape)

print("\nTraining class distribution:")
print(y_train.value_counts())

print("\nTesting class distribution:")
print(y_test.value_counts())


# ============================================================
# CALCULATE CLASS WEIGHT
# ============================================================

negative_count = (y_train == 0).sum()
positive_count = (y_train == 1).sum()

scale_pos_weight = negative_count / positive_count

print(
    "\nScale positive weight:",
    round(scale_pos_weight, 4)
)


# ============================================================
# CONVERT DATA TO NUMERIC
# ============================================================

X_train = X_train.astype(float)
X_test = X_test.astype(float)


# ============================================================
# CREATE XGBOOST MODEL
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
# TRAIN MODEL
# ============================================================

print("\nTraining survey XGBoost model...")

model.fit(
    X_train,
    y_train
)

print("Training completed!")


# ============================================================
# SAVE MODEL
# ============================================================

model.save_model(MODEL_FILE)

print("\nModel saved to:")
print(MODEL_FILE)


# ============================================================
# PREDICTION
# ============================================================

y_pred = model.predict(X_test)

y_probability = model.predict_proba(
    X_test
)[:, 1]


# ============================================================
# EVALUATION
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

cm = confusion_matrix(
    y_test,
    y_pred
)


# ============================================================
# DISPLAY RESULTS
# ============================================================

print("\n" + "=" * 60)
print("SURVEY MODEL TEST RESULTS")
print("=" * 60)

print(
    f"\nAccuracy  : {accuracy:.4f} "
    f"({accuracy * 100:.2f}%)"
)

print(
    f"Precision : {precision:.4f} "
    f"({precision * 100:.2f}%)"
)

print(
    f"Recall    : {recall:.4f} "
    f"({recall * 100:.2f}%)"
)

print(
    f"F1 Score  : {f1:.4f} "
    f"({f1 * 100:.2f}%)"
)

print(
    f"ROC-AUC   : {roc_auc:.4f} "
    f"({roc_auc * 100:.2f}%)"
)


# ============================================================
# CONFUSION MATRIX
# ============================================================

print("\nConfusion Matrix:")

print(
    "TN:",
    cm[0, 0]
)

print(
    "FP:",
    cm[0, 1]
)

print(
    "FN:",
    cm[1, 0]
)

print(
    "TP:",
    cm[1, 1]
)


# ============================================================
# CLASSIFICATION REPORT
# ============================================================

print("\nClassification Report:")

print(
    classification_report(
        y_test,
        y_pred,
        target_names=[
            "No Doctor Diagnosis",
            "Doctor Diagnosis"
        ],
        zero_division=0
    )
)


# ============================================================
# FEATURE IMPORTANCE
# ============================================================

feature_importance = pd.DataFrame({

    "feature": X_train.columns,

    "importance": model.feature_importances_

})

feature_importance = feature_importance.sort_values(
    by="importance",
    ascending=False
)


print("\nTop 15 Features:")

print(
    feature_importance.head(15).to_string(
        index=False
    )
)

print("\nSurvey model training completed successfully!")