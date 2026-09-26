const express = require("express");
const bcrypt = require("bcrypt");
const db = require("../db");

const router = express.Router();

// ==================== SIGNUP ====================

router.post("/signup", async (req, res) => {
  try {
    const { fullName, email, password } = req.body;

    // Check required fields
    if (!fullName || !email || !password) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    // Check whether email already exists
    const checkUserSql = "SELECT id FROM users WHERE email = ?";

    db.query(checkUserSql, [email], async (err, results) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({
          message: "Database error",
        });
      }

      if (results.length > 0) {
        return res.status(409).json({
          message: "Email already registered",
        });
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Insert user
      const insertUserSql = `
        INSERT INTO users (full_name, email, password)
        VALUES (?, ?, ?)
      `;

      db.query(
        insertUserSql,
        [fullName, email, hashedPassword],
        (err, result) => {
          if (err) {
            console.error("Insert error:", err);
            return res.status(500).json({
              message: "Failed to create account",
            });
          }

          res.status(201).json({
            message: "Account created successfully",
            userId: result.insertId,
          });
        }
      );
    });
  } catch (error) {
    console.error("Signup error:", error);

    res.status(500).json({
      message: "Server error",
    });
  }
});

// ==================== LOGIN ====================

router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: "Email and password are required",
      });
    }

    const sql = "SELECT * FROM users WHERE email = ?";

    db.query(sql, [email], async (err, results) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({
          message: "Database error",
        });
      }

      if (results.length === 0) {
        return res.status(401).json({
          message: "Invalid email or password",
        });
      }

      const user = results[0];

      // Compare entered password with hashed password
      const passwordMatch = await bcrypt.compare(
        password,
        user.password
      );

      if (!passwordMatch) {
        return res.status(401).json({
          message: "Invalid email or password",
        });
      }

      res.status(200).json({
        message: "Login successful",
        user: {
          id: user.id,
          fullName: user.full_name,
          email: user.email,
        },
      });
    });
  } catch (error) {
    console.error("Login error:", error);

    res.status(500).json({
      message: "Server error",
    });
  }
});

module.exports = router;