import pandas as pd
import re
from pathlib import Path


# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

INPUT_FILE = BASE_DIR / "data" / "Survey_responses.csv"
OUTPUT_FILE = BASE_DIR / "data" / "survey_height_weight_cleaned.csv"


# --------------------------------------------------
# 2. Load dataset
# --------------------------------------------------

df = pd.read_csv(INPUT_FILE)

# Remove extra spaces from column names
df.columns = df.columns.str.strip()


# --------------------------------------------------
# 3. Clean Height
# --------------------------------------------------

def clean_height(value):
    """
    Convert height values into centimeters.

    Examples:
        5'2       -> 157.48 cm
        5'4       -> 162.56 cm
        160 cm    -> 160 cm
        5.4       -> 162.56 cm
        5.7 feet  -> 170.18 cm
    """

    if pd.isna(value):
        return None

    value = str(value).strip().lower()

    # Remove unnecessary spaces
    value = value.replace(" ", "")

    # Convert backtick to apostrophe
    # Example: 5`7 -> 5'7
    value = value.replace("`", "'")

    # Empty or invalid values
    if value in ["", "-", "na", "n/a", "none"]:
        return None

    # ----------------------------------------------
    # Format: 5'2, 5’2, 5'2"
    # ----------------------------------------------

    feet_inches = re.match(
    r"""^(\d+)[\'’:](\d+)(?:")?$""",
    value
)

    if feet_inches:
        feet = float(feet_inches.group(1))
        inches = float(feet_inches.group(2))

        # Invalid inch value
        if inches >= 12:
            return None

        height_cm = (feet * 30.48) + (inches * 2.54)

        # Plausibility check
        if 130 <= height_cm <= 220:
            return height_cm

        return None

    # ----------------------------------------------
    # Format: 5 feet / 5 ft
    # Also handle values like 5.7 feet
    # as 5 ft 7 in
    # ----------------------------------------------

    feet_only = re.match(
        r"^(\d+(?:\.\d+)?)(?:feet|foot|ft)$",
        value
    )

    if feet_only:

        number = float(feet_only.group(1))

        # Example: 5 feet -> exactly 5 feet
        if number.is_integer():
            feet = int(number)
            inches = 0

        else:
            # Example: 5.7 feet -> 5 ft 7 in
            feet = int(number)
            inches = round((number - feet) * 10)

        if inches >= 12:
            return None

        height_cm = (feet * 30.48) + (inches * 2.54)

        if 130 <= height_cm <= 220:
            return height_cm

        return None

    # ----------------------------------------------
    # Format: 160 cm / 154cm
    # ----------------------------------------------

    cm_value = re.match(
        r"^(\d+(?:\.\d+)?)cm$",
        value
    )

    if cm_value:

        height_cm = float(cm_value.group(1))

        if 130 <= height_cm <= 220:
            return height_cm

        return None

    # ----------------------------------------------
    # Numeric values
    # ----------------------------------------------

    try:
        number = float(value)

    except ValueError:
        return None

    # Clearly centimeter values
    if 130 <= number <= 220:
        return number

    # ----------------------------------------------
    # Decimal feet-style entries
    #
    # Example:
    # 5.4 -> 5 ft 4 in
    # 5.7 -> 5 ft 7 in
    # ----------------------------------------------

    if 4.5 <= number <= 6.5:

        feet = int(number)
        decimal_part = number - feet

        inches = round(decimal_part * 10)

        if inches >= 12:
            return None

        height_cm = (feet * 30.48) + (inches * 2.54)

        if 130 <= height_cm <= 220:
            return height_cm

    # Anything suspicious becomes missing
    return None


df["Height_cm"] = df["Height"].apply(clean_height)


# --------------------------------------------------
# 4. Clean Weight
# --------------------------------------------------

def clean_weight(value):
    """
    Convert weight values into kilograms.
    """

    if pd.isna(value):
        return None

    value = str(value).strip().lower()

    # Remove spaces
    value = value.replace(" ", "")

    # Missing values
    if value in ["", "-", "na", "n/a", "none"]:
        return None

    # Remove kg if present
    value = value.replace("kg", "")

    try:
        weight = float(value)

    except ValueError:
        return None

    # Plausibility check for adult weight
    if 30 <= weight <= 200:
        return weight

    return None


df["Weight_kg"] = df["Weight"].apply(clean_weight)


# --------------------------------------------------
# 5. Calculate BMI
# --------------------------------------------------

df["BMI"] = (
    df["Weight_kg"] /
    ((df["Height_cm"] / 100) ** 2)
)


# --------------------------------------------------
# 6. Display conversion results
# --------------------------------------------------

print("\n========== HEIGHT & WEIGHT CLEANING ==========")

print("\n--- Height Conversion ---")

print(
    df[["Height", "Height_cm"]]
    .to_string(index=False)
)

print("\n--- Weight Conversion ---")

print(
    df[["Weight", "Weight_kg"]]
    .to_string(index=False)
)

print("\n--- BMI ---")

print(
    df[["Height_cm", "Weight_kg", "BMI"]]
    .to_string(index=False)
)


# --------------------------------------------------
# 7. Missing values after cleaning
# --------------------------------------------------

print("\n========== MISSING VALUES ==========")

print(
    df[["Height_cm", "Weight_kg", "BMI"]]
    .isnull()
    .sum()
)


# --------------------------------------------------
# 8. Save cleaned dataset
# --------------------------------------------------

df.to_csv(OUTPUT_FILE, index=False)

print("\n========== COMPLETE ==========")

print("Cleaned file saved to:")
print(OUTPUT_FILE)