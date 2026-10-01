import pandas as pd
import numpy as np


# ============================================================
# PCOSense - Create Clinical Test Dataset
# ============================================================

DATA_FILE = "data/clinical_preprocessed.csv"
OUTPUT_FILE = "data/clinical_test.csv"


# ------------------------------------------------------------
# 1. Load preprocessed dataset
# ------------------------------------------------------------

df = pd.read_csv(DATA_FILE)

print("Dataset shape:", df.shape)


# ------------------------------------------------------------
# 2. Separate target
# ------------------------------------------------------------

TARGET_COLUMN = "PCOS (Y/N)"

y = df[TARGET_COLUMN].astype(int)


# ------------------------------------------------------------
# 3. Create the same stratified 80/20 split
# ------------------------------------------------------------

np.random.seed(42)

train_indices = []
test_indices = []


for class_value in [0, 1]:

    class_indices = np.where(
        y.to_numpy() == class_value
    )[0]

    np.random.shuffle(class_indices)

    test_count = int(
        len(class_indices) * 0.20
    )

    test_indices.extend(
        class_indices[:test_count]
    )

    train_indices.extend(
        class_indices[test_count:]
    )


test_indices = np.array(test_indices)

np.random.shuffle(test_indices)


# ------------------------------------------------------------
# 4. Create test dataset
# ------------------------------------------------------------

test_data = df.iloc[test_indices].copy()


# ------------------------------------------------------------
# 5. Save test dataset
# ------------------------------------------------------------

test_data.to_csv(
    OUTPUT_FILE,
    index=False
)


# ------------------------------------------------------------
# 6. Display results
# ------------------------------------------------------------

print("\nTest dataset created successfully!")

print("Testing samples:", len(test_data))

print("\nTest class distribution:")
print(
    test_data[TARGET_COLUMN].value_counts()
)

print("\nSaved to:", OUTPUT_FILE)