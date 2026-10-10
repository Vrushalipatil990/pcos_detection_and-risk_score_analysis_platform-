from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib
import os


# --------------------------------------------------
# FastAPI application
# --------------------------------------------------

app = FastAPI(
    title="PCOSense Survey Prediction API",
    description="PCOS-associated risk prediction using the Google Survey model",
    version="1.0"
)


# --------------------------------------------------
# Load trained model
# --------------------------------------------------

MODEL_PATH = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    "models",
    "survey_logistic_regression.pkl"
)

model = joblib.load(MODEL_PATH)


# --------------------------------------------------
# Input data model
# --------------------------------------------------

class SurveyData(BaseModel):

    age: float
    bmi: float

    period_regularity: str
    missed_periods: str
    period_length: str
    period_change: str
    heavy_bleeding: str

    facial_body_hair: str
    acne: str
    hair_loss: str
    weight_gain: str
    dark_thickened_skin: str
    family_pcos: str


# --------------------------------------------------
# Root endpoint
# --------------------------------------------------

@app.get("/")
def home():

    return {
        "message": "PCOSense Survey Prediction API",
        "status": "running",
        "model": "Logistic Regression"
    }


# --------------------------------------------------
# Prediction endpoint
# --------------------------------------------------

@app.post("/predict")
def predict(data: SurveyData):

    # Convert API input to DataFrame
    input_data = pd.DataFrame([{
        "Age": data.age,
        "BMI": data.bmi,

        "How regular are your periods": data.period_regularity,
        "How often do you miss you periods": data.missed_periods,
        "How does long your periods usually last": data.period_length,
        "Have you noticed a significant change in your periods during the last year": data.period_change,
        "Do you experience unusually heavy menstrual bleeding": data.heavy_bleeding,

        "Do you experience exceesive facial & body hair growth": data.facial_body_hair,
        "Do you experience acne": data.acne,
        "Have you experienced unusual hair thinning or hair loss": data.hair_loss,
        "Have you experienced unexplained weight gain?": data.weight_gain,
        "Have you noticed dark or thickened skin, especially around your neck": data.dark_thickened_skin,
        "Does anyone from your family have a pcos": data.family_pcos
    }])


    # Prediction
    prediction = int(model.predict(input_data)[0])

    probability = float(
        model.predict_proba(input_data)[0][1]
    )

    probability_percent = probability * 100


    # Risk classification
    if probability_percent < 30:
        risk_level = "Low"

    elif probability_percent < 70:
        risk_level = "Moderate"

    else:
        risk_level = "High"


    return {
        "prediction": prediction,
        "pcos_probability": round(probability_percent, 2),
        "risk_level": risk_level,
        "interpretation": (
            "Higher PCOS-associated risk based on questionnaire"
            if prediction == 1
            else
            "Lower PCOS-associated risk based on questionnaire"
        ),
        "note": "This is a screening estimate and not a medical diagnosis."
    }