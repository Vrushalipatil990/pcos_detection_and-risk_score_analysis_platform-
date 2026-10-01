import pandas as pd
import numpy as np
import xgboost as xgb


# ============================================================
# PCOSense - Clinical Model Independent Testing
# ============================================================

TEST_DATA_FILE = "data/clinical_test.csv"
MODEL_FILE = "models/clinical_xgboost.json"


# ------------------------------------------------------------
# 1. Load Test Dataset
# ------------------------------------------------------------

df = pd.read_csv(TEST_DATA_FILE)

print("Test dataset shape:", df.shape)


# ------------------------------------------------------------
# 2. Separate Features and Target
# ------------------------------------------------------------

TARGET_COLUMN = "PCOS (Y/N)"

X = df.drop(columns=[TARGET_COLUMN])
y = df[TARGET_COLUMN].astype(int)

print("Feature count:", X.shape[1])
print("Testing samples:", len(y))

print("\nTest class distribution:")
print(y.value_counts())


# ------------------------------------------------------------
# 3. Convert Features to NumPy
# ------------------------------------------------------------

X = X.astype(float).to_numpy()
y = y.to_numpy()


# ------------------------------------------------------------
# 4. Load Saved XGBoost Model
# ------------------------------------------------------------

print("\nLoading saved clinical model...")

model = xgb.Booster()
model.load_model(MODEL_FILE)

print("Model loaded successfully!")


# ------------------------------------------------------------
# 5. Create DMatrix
# ------------------------------------------------------------

dtest = xgb.DMatrix(X)


# ------------------------------------------------------------
# 6. Generate Predictions
# ------------------------------------------------------------

print("\nGenerating predictions...")

probabilities = model.predict(dtest)

predictions = (probabilities >= 0.5).astype(int)

print("Predictions generated successfully!")


# ------------------------------------------------------------
# 7. Calculate Confusion Matrix
# ------------------------------------------------------------

TP = np.sum((y == 1) & (predictions == 1))
TN = np.sum((y == 0) & (predictions == 0))
FP = np.sum((y == 0) & (predictions == 1))
FN = np.sum((y == 1) & (predictions == 0))


# ------------------------------------------------------------
# 8. Calculate Evaluation Metrics
# ------------------------------------------------------------

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


# ------------------------------------------------------------
# 9. ROC-AUC Calculation
# ------------------------------------------------------------

def calculate_auc(y_true, probabilities):

    positive_probabilities = probabilities[y_true == 1]
    negative_probabilities = probabilities[y_true == 0]

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

    if total_pairs == 0:
        return 0

    return (
        correct + (0.5 * ties)
    ) / total_pairs


roc_auc = calculate_auc(
    y,
    probabilities
)


# ------------------------------------------------------------
# 10. Display Results
# ------------------------------------------------------------

print("\n" + "=" * 60)
print("INDEPENDENT CLINICAL MODEL TEST RESULTS")
print("=" * 60)

print(f"Accuracy : {accuracy:.4f}")
print(f"Precision: {precision:.4f}")
print(f"Recall   : {recall:.4f}")
print(f"F1 Score : {f1:.4f}")
print(f"ROC-AUC  : {roc_auc:.4f}")


# ------------------------------------------------------------
# 11. Confusion Matrix
# ------------------------------------------------------------

print("\nConfusion Matrix:")
print("-----------------")

print(f"True Negatives : {TN}")
print(f"False Positives: {FP}")
print(f"False Negatives: {FN}")
print(f"True Positives : {TP}")


print("\nIndependent clinical model testing completed successfully!")