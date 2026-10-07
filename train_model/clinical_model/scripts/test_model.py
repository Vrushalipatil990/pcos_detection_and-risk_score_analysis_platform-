import csv
import numpy as np
import xgboost as xgb

MODEL_FILE = "models/clinical_xgboost.json"
TEST_FILE = "data/clinical_test.csv"
TARGET_COLUMN = "PCOS (Y/N)"

print("=" * 60)
print("PCOSense - Clinical XGBoost Model Testing")
print("=" * 60)

# Load test CSV using Python's built-in csv module
with open(TEST_FILE, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)
    rows = list(reader)

print("Test dataset rows:", len(rows))

# Get feature columns
feature_columns = [col for col in reader.fieldnames if col != TARGET_COLUMN]

X = []
y = []

for row in rows:
    values = []

    for column in feature_columns:
        value = row[column]

        try:
            values.append(float(value))
        except ValueError:
            print(f"Non-numeric value found in {column}: {value}")
            values.append(0.0)

    X.append(values)
    y.append(int(float(row[TARGET_COLUMN])))

X = np.array(X, dtype=np.float32)
y = np.array(y, dtype=np.int32)

print("Number of features:", X.shape[1])

# Load saved XGBoost model
model = xgb.Booster()
model.load_model(MODEL_FILE)

print("Saved model loaded successfully.")

# Generate predictions
dtest = xgb.DMatrix(X)
probabilities = model.predict(dtest)

predictions = (probabilities >= 0.5).astype(int)

# Calculate confusion matrix
tn = np.sum((y == 0) & (predictions == 0))
fp = np.sum((y == 0) & (predictions == 1))
fn = np.sum((y == 1) & (predictions == 0))
tp = np.sum((y == 1) & (predictions == 1))

accuracy = (tp + tn) / len(y)
precision = tp / (tp + fp) if (tp + fp) > 0 else 0
recall = tp / (tp + fn) if (tp + fn) > 0 else 0
f1 = (
    2 * precision * recall / (precision + recall)
    if (precision + recall) > 0
    else 0
)

print()
print("=" * 60)
print("CLINICAL MODEL TEST RESULTS")
print("=" * 60)

print(f"Accuracy  : {accuracy:.4f} ({accuracy * 100:.2f}%)")
print(f"Precision : {precision:.4f} ({precision * 100:.2f}%)")
print(f"Recall    : {recall:.4f} ({recall * 100:.2f}%)")
print(f"F1 Score  : {f1:.4f} ({f1 * 100:.2f}%)")

print()
print("Confusion Matrix:")
print(f"TN: {tn}")
print(f"FP: {fp}")
print(f"FN: {fn}")
print(f"TP: {tp}")

print()
print("=" * 60)
print("Independent clinical model testing completed successfully!")
print("=" * 60)