require("dotenv").config();
const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

app.get("/projects", async (req, res) => {
  // LoanFactory コントラクトからプロジェクト一覧を取得
  res.json({ projects: [] });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
