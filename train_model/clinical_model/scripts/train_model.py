import pandas as pd
import numpy as np
import xgboost as xgb
from pathlib import Path

# --------------------------------------------------
# File paths
# --------------------------------------------------

TRAIN_FILE = "data/clinical_train.csv"
MODEL_FILE = "models/clinical_xgboost.json"

TARGET_COLUMN = "PCOS (Y/N)"

# --------------------------------------------------
# Load training dataset
# --------------------------------------------------

df = pd.read_csv(TRAIN_FILE)

print("Training dataset shape:", df.shape)

# --------------------------------------------------
# Separate features and target
# --------------------------------------------------

X = df.drop(columns=[TARGET_COLUMN])
y = df[TARGET_COLUMN].astype(int)

print("\nFeature count:", X.shape[1])

print("\nTraining target distribution:")
print(y.value_counts())

# --------------------------------------------------
# Convert data to numeric format
# --------------------------------------------------

X = X.astype(float).to_numpy()
y = y.to_numpy()

# --------------------------------------------------
# Create XGBoost training matrix
# --------------------------------------------------

dtrain = xgb.DMatrix(
    X,
    label=y
)

# --------------------------------------------------
# XGBoost parameters
# --------------------------------------------------

params = {
    "objective": "binary:logistic",
    "eval_metric": "logloss",
    "max_depth": 5,
    "learning_rate": 0.05,
    "subsample": 0.8,
    "colsample_bytree": 0.8,
    "seed": 42
}

# --------------------------------------------------
# Train model
# --------------------------------------------------

print("\nTraining XGBoost clinical model...")

model = xgb.train(
    params=params,
    dtrain=dtrain,
    num_boost_round=300,
    evals=[
        (dtrain, "train")
    ],
    verbose_eval=False
)

print("Training completed successfully!")

# --------------------------------------------------
# Training predictions
# --------------------------------------------------

train_probabilities = model.predict(dtrain)

train_predictions = (
    train_probabilities >= 0.5
).astype(int)

# --------------------------------------------------
# Calculate training confusion matrix
# --------------------------------------------------

TN = np.sum(
    (y == 0) & (train_predictions == 0)
)

FP = np.sum(
    (y == 0) & (train_predictions == 1)
)

FN = np.sum(
    (y == 1) & (train_predictions == 0)
)

TP = np.sum(
    (y == 1) & (train_predictions == 1)
)

# --------------------------------------------------
# Calculate training metrics
# --------------------------------------------------

accuracy = (TP + TN) / len(y)

precision = (
    TP / (TP + FP)
    if (TP + FP) > 0
    else 0
)

recall = (
    TP / (TP + FN)
    if (TP + FN) > 0
    else 0
)

f1 = (
    2 * precision * recall / (precision + recall)
    if (precision + recall) > 0
    else 0
)

# --------------------------------------------------
# Calculate ROC-AUC
# --------------------------------------------------

def calculate_auc(y_true, probabilities):

    positive_probabilities = probabilities[y_true == 1]
    negative_probabilities = probabilities[y_true == 0]

    if (
        len(positive_probabilities) == 0
        or len(negative_probabilities) == 0
    ):
        return 0

    correct = 0
    ties = 0

    for positive in positive_probabilities:

        for negative in negative_probabilities:

            if positive > negative:
                correct += 1

            elif positive == negative:
                ties += 1

    total_pairs = (
        len(positive_probabilities)
        * len(negative_probabilities)
    )

    auc = (
        correct + (0.5 * ties)
    ) / total_pairs

    return auc


roc_auc = calculate_auc(
    y,
    train_probabilities
)

# --------------------------------------------------
# Display training results
# --------------------------------------------------

print("\n" + "=" * 60)
print("CLINICAL XGBOOST TRAINING RESULTS")
print("=" * 60)

print(
    f"Accuracy : {accuracy:.4f} "
    f"({accuracy * 100:.2f}%)"
)

print(
    f"Precision: {precision:.4f} "
    f"({precision * 100:.2f}%)"
)

print(
    f"Recall   : {recall:.4f} "
    f"({recall * 100:.2f}%)"
)

print(
    f"F1 Score : {f1:.4f} "
    f"({f1 * 100:.2f}%)"
)

print(
    f"ROC-AUC  : {roc_auc:.4f}"
)

print("\nTraining Confusion Matrix:")
print("---------------------------")

print(f"True Negatives : {TN}")
print(f"False Positives: {FP}")
print(f"False Negatives: {FN}")
print(f"True Positives : {TP}")

# --------------------------------------------------
# Save model
# --------------------------------------------------

Path(MODEL_FILE).parent.mkdir(
    parents=True,
    exist_ok=True
)

model.save_model(MODEL_FILE)

print("\nModel saved successfully!")
print("Saved to:", MODEL_FILE)

# --------------------------------------------------
# Feature importance
# --------------------------------------------------

print("\nTop 15 Feature Importances:")
print("---------------------------")

feature_names = df.drop(
    columns=[TARGET_COLUMN]
).columns

importance = model.get_score(
    importance_type="gain"
)

feature_importance = []

for feature, score in importance.items():

    index = int(feature[1:])

    feature_importance.append(
        (feature_names[index], score)
    )

feature_importance.sort(
    key=lambda x: x[1],
    reverse=True
)

for feature, score in feature_importance[:15]:

    print(
        f"{feature:<40} {score:.4f}"
    )

print("\nClinical model training completed successfully!")