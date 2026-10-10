import pandas as pd
import joblib


# ============================================================
# LOAD SAVED MODEL
# ============================================================

MODEL_FILE = "models/survey_logistic_regression.pkl"

model = joblib.load(MODEL_FILE)

print("=" * 70)
print("SURVEY MODEL - NEW USER TEST")
print("=" * 70)

print("\nSaved model loaded successfully!")


# ============================================================
# SIMULATED NEW USER
#
# This is NOT training data.
# It is only used to test the prediction pipeline.
# ============================================================

new_user = pd.DataFrame([{

    "Age": 23,

    "BMI": 26.5,

    "How regular are your periods":
        "Sometimes irregular",

    "How often do you miss you periods":
        "Rarely",

    "How does long your periods usually last":
        "6-7 days",

    "Have you noticed a significant change in your periods during the last year":
        "Yes",

    "Do you experience unusually heavy menstrual bleeding":
        "No",

    "Do you experience exceesive facial & body hair growth":
        "Yes",

    "Do you experience acne":
        "Yes",

    "Have you experienced unusual hair thinning or hair loss":
        "No",

    "Have you experienced unexplained weight gain?":
        "Yes",

    "Have you noticed dark or thickened skin, especially around your neck":
        "No",

    "Does anyone from your family have a pcos":
        "Yes"
}])


# ============================================================
# PREDICTION
# ============================================================

prediction = model.predict(new_user)[0]

probability = model.predict_proba(
    new_user
)[0][1]


# ============================================================
# RISK LEVEL
# ============================================================

if probability < 0.30:

    risk_level = "Low"

elif probability < 0.70:

    risk_level = "Moderate"

else:

    risk_level = "High"


# ============================================================
# DISPLAY RESULT
# ============================================================

print("\n")
print("=" * 70)
print("NEW USER PREDICTION")
print("=" * 70)

print("\nPrediction:", prediction)

print(
    f"PCOS Risk Probability: "
    f"{probability * 100:.2f}%"
)

print(
    "Risk Level:",
    risk_level
)

print("\nInterpretation:")

if prediction == 1:

    print(
        "The survey model estimates a higher "
        "PCOS-associated risk based on the "
        "provided questionnaire responses."
    )

else:

    print(
        "The survey model estimates a lower "
        "PCOS-associated risk based on the "
        "provided questionnaire responses."
    )


print("\nIMPORTANT:")
print(
    "This is a model-based screening estimate, "
    "not a medical diagnosis."
)

print("\nTest completed successfully!")