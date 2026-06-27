-- ============================================================================
-- TRAI Telecom Analytics 2025-26 — Google BigQuery Views
-- 12 domain-specific views built on top of the raw `Telecom` table, organizing
-- the 59-column master dataset by business category.
-- Project ID anonymized — replace `your_project` with your own GCP project ID
-- ============================================================================


-- View 1: REPORTING_PERIOD
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.REPORTING_PERIOD` AS
SELECT
  Period_End,
  Month
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 2: SUBSCRIBER_BASE_MARKET_SIZE
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.SUBSCRIBER_BASE_MARKET_SIZE` AS
SELECT
  Month,
  Total_Wireless_Subs_Mn,
  Total_Wireline_Subs_Mn,
  Total_Telephone_Subs_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 3: BROADBAND_INTERNET_ADOPTION
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.BROADBAND_INTERNET_ADOPTION` AS
SELECT
  Month,
  Mobile_Broadband_Mn,
  Fixed_Wired_Broadband_Mn,
  Fixed_Wireless_Broadband_Mn,
  Total_Broadband_Subs_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 4: GEOGRAPHIC_DISTRIBUTION
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.GEOGRAPHIC_DISTRIBUTION` AS
SELECT
  Month,
  Urban_Wireless_Subs_Mn,
  Urban_Wireline_Subs_Mn,
  Urban_Total_Subs_Mn,
  Rural_Wireless_Subs_Mn,
  Rural_Wireline_Subs_Mn,
  Rural_Total_Subs_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 5: TELE_DENSITY_DIGITAL_INCLUSION
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.TELE_DENSITY_DIGITAL_INCLUSION` AS
SELECT
  Month,
  Overall_Tele_Density_Pct,
  Urban_Tele_Density_Pct,
  Rural_Tele_Density_Pct,
  Wireless_Tele_Density_Pct,
  Urban_Wireless_Tele_Density_Pct,
  Rural_Wireless_Tele_Density_Pct
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 6: ACTIVE_SUBSCRIBERS
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.ACTIVE_SUBSCRIBERS` AS
SELECT
  Month,
  Wireless_Mobile_Subs_Mn,
  Urban_Wireless_Mobile_Subs_Mn,
  Rural_Wireless_Mobile_Subs_Mn,
  Active_VLR_Subs_Mn,
  VLR_Pct_of_Total
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 7: FWA_AND_5G_BROADBAND
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.FWA_AND_5G_BROADBAND` AS
SELECT
  Month,
  `5G_FWA_Subs_Mn`,
  UBR_FWA_Subs_Mn,
  Total_FWA_Subs_Mn,
  Urban_5G_FWA_Subs_Mn,
  Rural_5G_FWA_Subs_Mn,
  Airtel_5G_FWA_Mn,
  Jio_5G_FWA_Mn,
  Jio_UBR_FWA_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 8: IOT_ENTERPRISE_CONNECTIVITY
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.IOT_ENTERPRISE_CONNECTIVITY` AS
SELECT
  Month,
  M2M_Connections_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 9: MNP_AND_CHURN
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.MNP_AND_CHURN` AS
SELECT
  Month,
  MNP_Requests_Month_Mn,
  MNP_Zone1_Mn,
  MNP_Zone2_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 10: SUBSCRIBER_GROWTH
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.SUBSCRIBER_GROWTH` AS
SELECT
  Month,
  Net_Add_Wireless_Mobile_Mn,
  Net_Add_Wireline_Mn,
  Net_Add_Total_Mn,
  Wireless_Monthly_Growth_Pct,
  Wireline_Monthly_Growth_Pct,
  Total_Monthly_Growth_Pct
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 11: OPERATOR_PERFORMANCE
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.OPERATOR_PERFORMANCE` AS
SELECT
  Month,
  Jio_Total_BB_Mn,
  Airtel_Total_BB_Mn,
  VIL_Total_BB_Mn,
  BSNL_Total_BB_Mn,
  Jio_Wired_BB_Mn,
  Airtel_Wired_BB_Mn,
  BSNL_Wired_BB_Mn,
  Net_Add_Jio_Mn,
  Net_Add_Airtel_Mn,
  Net_Add_VIL_Mn,
  Net_Add_BSNL_Mn
FROM `your_project.Telecom_Industry_Dataset.Telecom`;


-- View 12: MARKET_SHARE_COMPETITION
CREATE OR REPLACE VIEW `your_project.Telecom_Industry_Dataset.MARKET_SHARE_COMPETITION` AS
SELECT
  Month,
  Private_Wireless_Share_Pct,
  PSU_Wireless_Share_Pct,
  Private_Wireline_Share_Pct,
  PSU_Wireline_Share_Pct
FROM `your_project.Telecom_Industry_Dataset.Telecom`;
