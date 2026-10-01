import pandas as pd
import numpy as np
import xgboost as xgb

from pathlib import Path


# ============================================================
# PCOSense - Clinical XGBoost Model Training
# ============================================================

DATA_FILE = "data/clinical_preprocessed.csv"
MODEL_FILE = "models/clinical_xgboost.json"


# ------------------------------------------------------------
# 1. Load preprocessed dataset
# ------------------------------------------------------------

df = pd.read_csv(DATA_FILE)

print("Dataset shape:", df.shape)


# ------------------------------------------------------------
# 2. Separate features and target
# ------------------------------------------------------------

TARGET_COLUMN = "PCOS (Y/N)"

X = df.drop(columns=[TARGET_COLUMN])
y = df[TARGET_COLUMN].astype(int)

print("\nFeature count:", X.shape[1])

print("\nTarget distribution:")
print(y.value_counts())


# ------------------------------------------------------------
# 3. Convert data to NumPy
# ------------------------------------------------------------

X = X.astype(float).to_numpy()
y = y.to_numpy()


# ------------------------------------------------------------
# 4. Stratified 80/20 Train-Test Split
# ------------------------------------------------------------

np.random.seed(42)

train_indices = []
test_indices = []

for class_value in [0, 1]:

    class_indices = np.where(y == class_value)[0]

    np.random.shuffle(class_indices)

    test_count = int(len(class_indices) * 0.20)

    test_indices.extend(class_indices[:test_count])
    train_indices.extend(class_indices[test_count:])


train_indices = np.array(train_indices)
test_indices = np.array(test_indices)

np.random.shuffle(train_indices)
np.random.shuffle(test_indices)


X_train = X[train_indices]
X_test = X[test_indices]

y_train = y[train_indices]
y_test = y[test_indices]

# ------------------------------------------------------------
# 5. Create XGBoost DMatrix
# ------------------------------------------------------------

dtrain = xgb.DMatrix(
    X_train,
    label=y_train
)

dtest = xgb.DMatrix(
    X_test,
    label=y_test
)


# ------------------------------------------------------------
# 6. XGBoost Parameters
# ------------------------------------------------------------

params = {
    "objective": "binary:logistic",
    "eval_metric": "logloss",
    "max_depth": 5,
    "learning_rate": 0.05,
    "subsample": 0.8,
    "colsample_bytree": 0.8,
    "seed": 42
}


# ------------------------------------------------------------
# 7. Train Clinical Model
# ------------------------------------------------------------

print("\nTraining XGBoost clinical model...")

model = xgb.train(
    params=params,
    dtrain=dtrain,
    num_boost_round=300,
    evals=[
        (dtrain, "train"),
        (dtest, "test")
    ],
    verbose_eval=False
)

print("Training completed successfully!")


# ------------------------------------------------------------
# 8. Predictions
# ------------------------------------------------------------

probabilities = model.predict(dtest)

predictions = (probabilities >= 0.5).astype(int)


# ------------------------------------------------------------
# 9. Evaluation Metrics
# ------------------------------------------------------------

TP = np.sum((y_test == 1) & (predictions == 1))
TN = np.sum((y_test == 0) & (predictions == 0))
FP = np.sum((y_test == 0) & (predictions == 1))
FN = np.sum((y_test == 1) & (predictions == 0))


accuracy = (TP + TN) / len(y_test)

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


# ------------------------------------------------------------
# 10. ROC-AUC Calculation
# ------------------------------------------------------------

def calculate_auc(y_true, probabilities):

    positive_probabilities = probabilities[y_true == 1]
    negative_probabilities = probabilities[y_true == 0]

    if len(positive_probabilities) == 0 or len(negative_probabilities) == 0:
        return 0

    # Compare every positive prediction probability
    # against every negative prediction probability.
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
    y_test,
    probabilities
)

# ------------------------------------------------------------
# 11. Display Results
# ------------------------------------------------------------

print("\n" + "=" * 60)
print("CLINICAL XGBOOST MODEL RESULTS")
print("=" * 60)

print(f"Accuracy : {accuracy:.4f}")
print(f"Precision: {precision:.4f}")
print(f"Recall   : {recall:.4f}")
print(f"F1 Score : {f1:.4f}")
print(f"ROC-AUC  : {roc_auc:.4f}")


# ------------------------------------------------------------
# 12. Confusion Matrix
# ------------------------------------------------------------

print("\nConfusion Matrix:")
print("-----------------")

print(f"True Negatives : {TN}")
print(f"False Positives: {FP}")
print(f"False Negatives: {FN}")
print(f"True Positives : {TP}")


# ------------------------------------------------------------
# 13. Save Model
# ------------------------------------------------------------

Path("../models").mkdir(
    parents=True,
    exist_ok=True
)

model.save_model(MODEL_FILE)

print("\nModel saved successfully!")
print("Saved to:", MODEL_FILE)


# ------------------------------------------------------------
# 14. Feature Importance
# ------------------------------------------------------------

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
        (
            feature_names[index],
            score
        )
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