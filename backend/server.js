const express = require("express");
const cors = require("cors");
const db = require("./db");

const authRoutes = require("./routes/auth");
const predictionRoutes = require("./routes/prediction");
const recommendationRoutes = require("./routes/recommendations");
const menstrualRoutes = require("./routes/menstrual");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Test route
app.get("/", (req, res) => {
  res.send("PCOSense backend is running!");
});

app.use("/api", authRoutes);
app.use("/api", predictionRoutes);
app.use("/api", recommendationRoutes);
app.use("/api/menstrual", menstrualRoutes);

// Start server
// const PORT = 3000;
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});