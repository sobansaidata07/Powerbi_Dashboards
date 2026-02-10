📊 **Hospital Patient Data Analysis**

---

📝 **Project Overview**

This project analyzes hospital patient datasets to extract insights on patient demographics, treatments, costs, and hospital performance.  

**Dataset 1 (Patient Info):**  
Age, Admission Date, Blood Type, Diagnosis, Discharge Date, Full Prescription, Gender, Patient Name, Patient ID, Total Bill, Treatment, Year of Admission  

**Dataset 2 (Hospital Operations):**  
Daily Cost, Doctor Name, Hospital Name, Recovery Rating, Room Number  

---

⚙️ **Data Preparation & Transformation**

- Replaced null values in **Patient Name** with **Patient ID**  
- Kept nulls in **Hospital Name** and **Recovery Rating**  
- Converted **Admission** and **Discharge Dates** to date format and extracted **Year of Admission**  
- Converted **Patient ID** to text for slicer search  
- Created **age bins** for visualization  

---

📏 **Measures & KPIs**

- Used **SELECTEDVALUES()** for all key columns  
- KPIs:  
  - Best Doctor (by recovery rating)  
  - Total Hospital Income  
  - Average Hospital Income  
  - Number of Patients  
  - Number of Doctors  
  - Total Daily Cost  
  - Average Daily Cost  

---

📊 **Visualizations**

- **Pie Charts:** Gender, Treatment, Treatment Type  
- **Bar Charts:** Age Groups, Diagnosis, Blood Type, Recovery Rating  
- **Slicers:** Year of Admission, Hospital Name  

---

🔍 **Observations**

- Blood Type: Most common AB+, B-; least O+, O-  
- Diagnoses: Diabetes and Asthma dominate  
- Age Groups: 71–90 most common, then 31–50  
- Recovery Rating: Mostly 9 (good recovery), then 2 (mixed)  
- Gender: Male 33%, Female 33%, Other 34%  
- Treatment Type: Physical Therapy 23%, Surgery 27%, Medication 25%, Counseling 26%  
- Treatment: Therapy 35%, Surgery 31%, Medication 35%  
- Counts: Patients 1000, Doctors 369, Rooms 421  
- Financials: Total Income 9,436,535, Avg Income 10,039, Total Daily Cost 998,358  

---

✅ **Conclusions**

- Balanced gender and age distribution  
- Diabetes and Asthma are major diagnoses  
- Recovery ratings indicate good outcomes  
- Hospital shows strong revenue and controlled daily costs  

---

💡 **Recommendations**

- Target awareness campaigns for Diabetes and Asthma  
- Optimize high-treatment departments for efficiency  
- Monitor recovery rating trends to assess doctor performance  
- Implement age-based wellness programs for older patients  
