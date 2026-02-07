# 📊 Vit-Track Dashboard – Patient Vitamin Deficiency Analysis

Vit-Track is an end-to-end **Power BI healthcare analytics project** that transforms raw patient health records into an **interactive, clinically meaningful dashboard**.  
The goal is to make vitamin and mineral deficiencies easy to identify at the **individual patient level**.

---

## 🔍 Project Overview

The project covers the full workflow:
- Raw patient data ingestion
- Data cleaning and transformation
- Feature engineering (age groups, BMI groups, symptom categories)
- Interactive Power BI dashboard with DAX-driven insights

Each dashboard view updates dynamically when a **Patient ID** is selected.

---

## 📦 Dataset Description

Each row represents **one patient** and includes:

### 🧬 Demographics
- Age, Gender

### 🏃 Lifestyle
- Smoking status  
- Alcohol consumption  
- Exercise level  
- Diet type  
- Sun exposure  
- Income level  
- Latitude region  

### 🥗 Nutrition Intake (% RDA)
- Vitamins A, C, D, E, B12  
- Folate, Calcium, Iron  

### 🧪 Clinical Lab Results
- Hemoglobin  
- Serum Vitamin D  
- Serum Vitamin B12  
- Serum Folate  

### ⚕️ Health Indicators
- Symptoms count  
- Individual symptom flags (Yes/No)  
- Disease diagnosis  
- Multiple deficiency indicator  

---

## ⚙️ Data Transformation

Key transformation steps:
- Added **unique Patient ID**
- Standardized column names and categorical values
- Created **Age Groups** and **BMI Groups**
- Normalized symptom data into individual Yes/No indicators
- Derived **symptom severity groups**
- Flagged patients with **multiple nutrient deficiencies**

---

## 📊 Dashboard Features

### 🔹 Header
- Patient ID selector
- Dashboard title
- Diagnosed disease

### 🔹 Symptoms & Health Status
- Binary symptom indicators (Yes / No)

### 🔹 Laboratory Results
- Semi-circular gauges for vitamins, minerals, hemoglobin, and folate
- Color-coded results:
  - 🟢 Normal
  - 🔴 Deficient

### 🔹 Lifestyle & Demographics
- Smoking, alcohol, exercise, diet
- Age group, BMI group, income, region

All visuals update dynamically based on the selected patient.

---

## 🧠 DAX & Interactivity

Key DAX logic includes:
- Categorizing lab values into **Low / Normal / High**
- Dynamic gauge scaling using dataset-wide maximum values
- Patient-level card values using `SELECTEDVALUE()`

This ensures:
- Clinically interpretable visuals
- Responsive and interactive analysis
- Reduced cognitive load for users

---

## 🚀 Impact

- End-to-end healthcare analytics workflow
- Demonstrates **Power BI modeling & DAX proficiency**
- Patient-level interactivity
- Clean, clinically focused dashboard design
- Reproducible and well-documented project

---

## 📌 Tools Used
- Power BI
- DAX
- Data Modeling & Feature Engineering

---

📈 *Vit-Track turns complex patient lab data into actionable health insights.*
