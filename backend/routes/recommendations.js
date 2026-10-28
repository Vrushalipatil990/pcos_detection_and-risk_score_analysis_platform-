
const express = require("express");

const router = express.Router();

// POST /api/recommendations
router.post("/recommendations", (req, res) => {
  try {
    const {
      dietType,
      mealsPerDay,
      sugaryFoodFrequency,
      fastFoodFrequency,
      fruitsVegetables,
      exerciseDays,
      exerciseDuration,
      activityType,
      sleepHours,
      stressLevel,
      bmi,
    } = req.body;

    const recommendations = [];

    // Nutrition recommendations
    if (
      sugaryFoodFrequency === "Daily" ||
      sugaryFoodFrequency === "Very often"
    ) {
      recommendations.push({
        category: "Nutrition",
        title: "Reduce frequent sugary foods",
        advice:
          "Try replacing sugary drinks and snacks with water, whole fruit, or unsweetened alternatives.",
      });
    }

    if (
      fastFoodFrequency === "Daily" ||
      fastFoodFrequency === "Very often"
    ) {
      recommendations.push({
        category: "Nutrition",
        title: "Choose balanced meals",
        advice:
          "Try preparing balanced meals with vegetables, protein, and whole grains more often.",
      });
    }

    if (
      fruitsVegetables === "Low" ||
      fruitsVegetables === "Rarely"
    ) {
      recommendations.push({
        category: "Nutrition",
        title: "Add more fruits and vegetables",
        advice:
          "Include a variety of vegetables and whole fruits in your daily meals.",
      });
    }

    if (dietType === "Vegetarian") {
      recommendations.push({
        category: "Nutrition",
        title: "Include vegetarian protein sources",
        advice:
          "Consider dal, beans, chickpeas, paneer, tofu, nuts, and seeds as suitable protein options.",
      });
    } else if (dietType === "Non-vegetarian") {
      recommendations.push({
        category: "Nutrition",
        title: "Include varied protein sources",
        advice:
          "Consider eggs, fish, lean meat, dal, and beans as suitable protein options.",
      });
    }

    // Lifestyle recommendations
    if (Number(exerciseDays) < 3) {
      recommendations.push({
        category: "Activity",
        title: "Build a regular movement routine",
        advice:
          "If suitable for you, start with comfortable walks and gradually build a consistent activity routine.",
      });
    }

    if (Number(sleepHours) < 7) {
      recommendations.push({
        category: "Sleep",
        title: "Support your sleep routine",
        advice:
          "Try maintaining a consistent bedtime and wake-up time. Individual sleep needs can vary.",
      });
    }

    if (
      stressLevel === "High" ||
      stressLevel === "Very high"
    ) {
      recommendations.push({
        category: "Wellbeing",
        title: "Make time for stress management",
        advice:
          "Consider relaxing activities such as gentle movement, breathing exercises, or talking with someone you trust.",
      });
    }

    // General recommendation if no specific rule matched
    if (recommendations.length === 0) {
      recommendations.push({
        category: "Wellbeing",
        title: "Maintain balanced habits",
        advice:
          "Continue eating varied, balanced meals, staying active in ways that suit you, and maintaining a regular sleep routine.",
      });
    }

    return res.status(200).json({
      success: true,
      recommendations,
      note:
        "These are general wellness suggestions, not a diagnosis or individualized medical treatment.",
    });
  } catch (error) {
    console.error("Recommendation error:", error.message);

    return res.status(500).json({
      success: false,
      message: "Unable to generate recommendations.",
    });
  }
});

module.exports = router;
