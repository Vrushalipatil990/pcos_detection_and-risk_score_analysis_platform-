import csv
import numpy as np
import xgboost as xgb

MODEL_FILE = "models/clinical_xgboost.json"
TEST_FILE = "data/clinical_test.csv"
TARGET_COLUMN = "PCOS (Y/N)"

print("=" * 60)
print("PCOSense - Clinical XGBoost Model Testing")
print("=" * 60)

# --------------------------------------------------
# Load test dataset
# --------------------------------------------------

with open(TEST_FILE, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)
    rows = list(reader)

print("Test dataset rows:", len(rows))

feature_columns = [
    col for col in reader.fieldnames
    if col != TARGET_COLUMN
]

# --------------------------------------------------
# Prepare test data
# --------------------------------------------------

X = []
y = []

for row in rows:

    values = []

    for column in feature_columns:

        value = row[column].strip()

        # Keep missing values as NaN
        if value == "":
            values.append(np.nan)

        else:
            try:
                values.append(float(value))

            except ValueError:
                raise ValueError(
                    f"Unexpected non-numeric value found "
                    f"in {column}: {value}"
                )

    X.append(values)

    y.append(
        int(float(row[TARGET_COLUMN]))
    )

X = np.array(X, dtype=np.float32)
y = np.array(y, dtype=np.int32)

print("Number of features:", X.shape[1])

# --------------------------------------------------
# Count missing values
# --------------------------------------------------

missing_count = np.isnan(X).sum()

print("Missing feature values:", missing_count)

# --------------------------------------------------
# Load trained model
# --------------------------------------------------

model = xgb.Booster()
model.load_model(MODEL_FILE)

print("Saved model loaded successfully.")

# --------------------------------------------------
# Make predictions
# --------------------------------------------------

dtest = xgb.DMatrix(X)

probabilities = model.predict(dtest)

predictions = (
    probabilities >= 0.5
).astype(int)

# --------------------------------------------------
# Confusion Matrix
# --------------------------------------------------

tn = np.sum(
    (y == 0) & (predictions == 0)
)

fp = np.sum(
    (y == 0) & (predictions == 1)
)

fn = np.sum(
    (y == 1) & (predictions == 0)
)

tp = np.sum(
    (y == 1) & (predictions == 1)
)

# --------------------------------------------------
# Calculate metrics
# --------------------------------------------------

accuracy = (
    (tp + tn) / len(y)
)

precision = (
    tp / (tp + fp)
    if (tp + fp) > 0
    else 0
)

recall = (
    tp / (tp + fn)
    if (tp + fn) > 0
    else 0
)

f1 = (
    2 * precision * recall
    / (precision + recall)
    if (precision + recall) > 0
    else 0
)

# --------------------------------------------------
# Calculate ROC-AUC
# --------------------------------------------------

def calculate_auc(y_true, probabilities):

    positive_probabilities = probabilities[
        y_true == 1
    ]

    negative_probabilities = probabilities[
        y_true == 0
    ]

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

    return (
        correct + (0.5 * ties)
    ) / total_pairs


roc_auc = calculate_auc(
    y,
    probabilities
)

# --------------------------------------------------
# Display results
# --------------------------------------------------

print()
print("=" * 60)
print("CLINICAL MODEL TEST RESULTS")
print("=" * 60)

print(
    f"Accuracy  : {accuracy:.4f} "
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

print()
print("Confusion Matrix:")
print("-----------------")

print(f"TN: {tn}")
print(f"FP: {fp}")
print(f"FN: {fn}")
print(f"TP: {tp}")

print()
print("=" * 60)
print("Independent clinical model testing completed successfully!")
print("=" * 60)