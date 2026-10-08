from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import numpy as np
import xgboost as xgb
from pathlib import Path


# ============================================================
# FASTAPI APPLICATION
# ============================================================

app = FastAPI(
    title="PCOSense Clinical Prediction API",
    description="Clinical PCOS risk prediction using XGBoost",
    version="1.0.0"
)


# ============================================================
# FILE PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

MODEL_FILE = BASE_DIR / "models" / "clinical_xgboost.json"
TRAIN_FILE = BASE_DIR / "data" / "clinical_train.csv"

TARGET_COLUMN = "PCOS (Y/N)"


# ============================================================
# LOAD TRAINING DATA
# ============================================================

train_df = pd.read_csv(TRAIN_FILE)

FEATURE_COLUMNS = [
    column
    for column in train_df.columns
    if column != TARGET_COLUMN
]


# ============================================================
# LOAD XGBOOST MODEL
# ============================================================

model = xgb.Booster()

model.load_model(
    str(MODEL_FILE)
)


# ============================================================
# INPUT DATA MODEL
# ============================================================

class ClinicalData(BaseModel):

    age: float
    weight: float
    height: float
    bmi: float

    blood_group: float

    pulse_rate: float
    respiratory_rate: float

    hb: float

    cycle_regular: float
    cycle_length: float

    marriage_status_years: float

    pregnant: float
    abortions: float

    beta_hcg_1: float
    beta_hcg_2: float

    fsh: float
    lh: float
    fsh_lh: float

    hip: float
    waist: float
    waist_hip_ratio: float

    tsh: float

    amh: float | None = None

    prolactin: float
    vitamin_d3: float
    progesterone: float
    rbs: float

    weight_gain: float
    hair_growth: float
    skin_darkening: float
    hair_loss: float
    pimples: float

    fast_food: float
    regular_exercise: float

    bp_systolic: float
    bp_diastolic: float

    follicle_left: float
    follicle_right: float

    avg_follicle_size_left: float
    avg_follicle_size_right: float

    endometrium: float


# ============================================================
# PREPARE FEATURES
# ============================================================

def prepare_features(data: ClinicalData):

    values = {

        " Age (yrs)": data.age,

        "Weight (Kg)": data.weight,

        "Height(Cm) ": data.height,

        "BMI": data.bmi,

        "Blood Group": data.blood_group,

        "Pulse rate(bpm) ": data.pulse_rate,

        "RR (breaths/min)": data.respiratory_rate,

        "Hb(g/dl)": data.hb,

        "Cycle(R/I)": data.cycle_regular,

        "Cycle length(days)": data.cycle_length,

        "Marraige Status (Yrs)": data.marriage_status_years,

        "Pregnant(Y/N)": data.pregnant,

        "No. of abortions": data.abortions,

        "  I   beta-HCG(mIU/mL)": data.beta_hcg_1,

        "II    beta-HCG(mIU/mL)": data.beta_hcg_2,

        "FSH(mIU/mL)": data.fsh,

        "LH(mIU/mL)": data.lh,

        "FSH/LH": data.fsh_lh,

        "Hip(inch)": data.hip,

        "Waist(inch)": data.waist,

        "Waist:Hip Ratio": data.waist_hip_ratio,

        "TSH (mIU/L)": data.tsh,

        "AMH(ng/mL)": data.amh,

        "PRL(ng/mL)": data.prolactin,

        "Vit D3 (ng/mL)": data.vitamin_d3,

        "PRG(ng/mL)": data.progesterone,

        "RBS(mg/dl)": data.rbs,

        "Weight gain(Y/N)": data.weight_gain,

        "hair growth(Y/N)": data.hair_growth,

        "Skin darkening (Y/N)": data.skin_darkening,

        "Hair loss(Y/N)": data.hair_loss,

        "Pimples(Y/N)": data.pimples,

        "Fast food (Y/N)": data.fast_food,

        "Reg.Exercise(Y/N)": data.regular_exercise,

        "BP _Systolic (mmHg)": data.bp_systolic,

        "BP _Diastolic (mmHg)": data.bp_diastolic,

        "Follicle No. (L)": data.follicle_left,

        "Follicle No. (R)": data.follicle_right,

        "Avg. F size (L) (mm)": data.avg_follicle_size_left,

        "Avg. F size (R) (mm)": data.avg_follicle_size_right,

        "Endometrium (mm)": data.endometrium
    }


    # Create dataframe using EXACT training feature order

    df = pd.DataFrame(
        [
            [
                values[column]
                for column in FEATURE_COLUMNS
            ]
        ],
        columns=FEATURE_COLUMNS
    )


    return df


# ============================================================
# ROOT ENDPOINT
# ============================================================

@app.get("/")
def root():

    return {

        "message": "PCOSense Clinical Prediction API",

        "status": "running",

        "model": "XGBoost",

        "features": len(FEATURE_COLUMNS)

    }


# ============================================================
# PREDICTION ENDPOINT
# ============================================================

@app.post("/predict")
def predict(data: ClinicalData):

    try:

        # ----------------------------------------------------
        # STEP 1: Prepare input
        # ----------------------------------------------------

        features = prepare_features(data)


        # ----------------------------------------------------
        # STEP 2: Convert to XGBoost DMatrix
        # ----------------------------------------------------

        X = features.to_numpy(
            dtype=np.float32
        )

        dmatrix = xgb.DMatrix(X)


        # ----------------------------------------------------
        # STEP 3: PCOS probability
        # ----------------------------------------------------

        probability = float(
            model.predict(dmatrix)[0]
        )


        risk_score = probability * 100


        # ----------------------------------------------------
        # STEP 4: Risk level
        # ----------------------------------------------------

        if risk_score < 30:

            risk_level = "Low"

        elif risk_score < 70:

            risk_level = "Moderate"

        else:

            risk_level = "High"


        # ----------------------------------------------------
        # STEP 5: Native XGBoost Tree SHAP contributions
        # ----------------------------------------------------

        shap_values = model.predict(
            dmatrix,
            pred_contribs=True
        )[0]


        # XGBoost returns:
        #
        # 41 feature contributions
        # +
        # 1 bias/base value
        #
        # Therefore remove the last value.

        feature_contributions = shap_values[:-1]


        # ----------------------------------------------------
        # STEP 6: Create explanations
        # ----------------------------------------------------

        explanations = []


        for feature, value, contribution in zip(
            FEATURE_COLUMNS,
            X[0],
            feature_contributions
        ):

            contribution = float(
                contribution
            )

            value = float(value)


            # Determine direction

            if contribution > 0:

                impact = "increases PCOS risk"

            elif contribution < 0:

                impact = "decreases PCOS risk"

            else:

                impact = "no significant impact"


            explanations.append({

                "feature": feature,

                "value": round(
                    value,
                    4
                ),

                "contribution": round(
                    contribution,
                    4
                ),

                "impact": impact

            })


        # ----------------------------------------------------
        # STEP 7: Sort by strongest contribution
        # ----------------------------------------------------

        explanations.sort(
            key=lambda item: abs(
                item["contribution"]
            ),
            reverse=True
        )


        # ----------------------------------------------------
        # STEP 8: Return top 5 features
        # ----------------------------------------------------

        top_explanations = explanations[:5]


        # ----------------------------------------------------
        # STEP 9: API response
        # ----------------------------------------------------

        return {

            "success": True,

            "pcos_probability": round(
                risk_score,
                2
            ),

            "risk_level": risk_level,

            "explanations": top_explanations

        }


    except Exception as e:

        raise HTTPException(

            status_code=500,

            detail=str(e)

        )