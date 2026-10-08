import pandas as pd
import numpy as np

DATA_FILE = "data/clinical_preprocessed.csv"
TRAIN_FILE = "data/clinical_train.csv"
TEST_FILE = "data/clinical_test.csv"

TARGET_COLUMN = "PCOS (Y/N)"

# --------------------------------------------------
# Load preprocessed clinical dataset
# --------------------------------------------------

df = pd.read_csv(DATA_FILE)

print("Dataset shape:", df.shape)

# --------------------------------------------------
# Create fixed stratified 80/20 split
# --------------------------------------------------

y = df[TARGET_COLUMN].astype(int)

np.random.seed(42)

train_indices = []
test_indices = []

for class_value in [0, 1]:

    class_indices = np.where(
        y.to_numpy() == class_value
    )[0]

    np.random.shuffle(class_indices)

    test_count = int(len(class_indices) * 0.20)

    test_indices.extend(class_indices[:test_count])
    train_indices.extend(class_indices[test_count:])

# Convert to NumPy arrays
train_indices = np.array(train_indices)
test_indices = np.array(test_indices)

# Shuffle both sets
np.random.shuffle(train_indices)
np.random.shuffle(test_indices)

# --------------------------------------------------
# Create train and test datasets
# --------------------------------------------------

train_data = df.iloc[train_indices].copy()
test_data = df.iloc[test_indices].copy()

# --------------------------------------------------
# Save datasets
# --------------------------------------------------

train_data.to_csv(TRAIN_FILE, index=False)
test_data.to_csv(TEST_FILE, index=False)

# --------------------------------------------------
# Display results
# --------------------------------------------------

print("\nDatasets created successfully!")

print("\nTraining samples:", len(train_data))
print("Testing samples :", len(test_data))

print("\nTraining class distribution:")
print(train_data[TARGET_COLUMN].value_counts())

print("\nTesting class distribution:")
print(test_data[TARGET_COLUMN].value_counts())

print("\nSaved files:")
print("Training:", TRAIN_FILE)
print("Testing :", TEST_FILE)