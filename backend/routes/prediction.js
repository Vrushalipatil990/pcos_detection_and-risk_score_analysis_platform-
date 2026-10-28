
const express = require("express");

const router = express.Router();

const PYTHON_API_URL = "http://127.0.0.1:8001";

// POST /api/predict
router.post("/predict", async (req, res) => {
  try {
    const requiredFields = [
      "age",
      "bmi",
      "period_regularity",
      "missed_periods",
      "period_length",
      "period_change",
      "heavy_bleeding",
      "facial_body_hair",
      "acne",
      "hair_loss",
      "weight_gain",
      "dark_thickened_skin",
      "family_pcos",
    ];

    const missingFields = requiredFields.filter(
      (field) =>
        req.body[field] === undefined ||
        req.body[field] === null ||
        req.body[field] === ""
    );

    if (missingFields.length > 0) {
      return res.status(400).json({
        message: "Missing required prediction fields",
        missingFields,
      });
    }

    const response = await fetch(`${PYTHON_API_URL}/predict`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(req.body),
      signal: AbortSignal.timeout(15000),
    });

    const result = await response.json();

    if (!response.ok) {
      return res.status(response.status).json({
        message: "Prediction API returned an error",
        details: result,
      });
    }

    return res.status(200).json(result);
  } catch (error) {
    console.error("Prediction API error:", error.message);

    return res.status(502).json({
      message:
        "Unable to reach the Python prediction API. Check that it is running on port 8001.",
    });
  }
});

module.exports = router;
