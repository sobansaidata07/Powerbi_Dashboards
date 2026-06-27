-- ============================================================================
-- TRAI Telecom Analytics 2025-26 — Microsoft Fabric Warehouse (T-SQL)
-- 12 BigQuery views recreated in T-SQL inside Telecom_Warehouse, plus one
-- extra view (WIRELINE_WIRELESS_DIFF) added to support the Power BI visuals
-- that DirectLake/Power BI Service couldn't compute as live DAX measures.
-- Schema: [dbo].[telecom] — no project/server identifiers, safe as-is.
-- ============================================================================


-- View 1: REPORTING_PERIOD
CREATE VIEW [dbo].[REPORTING_PERIOD] AS
SELECT
  Period_End,
  Month
FROM [dbo].[telecom];
GO


-- View 2: SUBSCRIBER_BASE_MARKET_SIZE
CREATE VIEW [dbo].[SUBSCRIBER_BASE_MARKET_SIZE] AS
SELECT
  Month, Period_End,
  Total_Wireless_Subs_Mn,
  Total_Wireline_Subs_Mn,
  Total_Telephone_Subs_Mn
FROM [dbo].[telecom];
GO


-- View 3: BROADBAND_INTERNET_ADOPTION
CREATE VIEW [dbo].[BROADBAND_INTERNET_ADOPTION] AS
SELECT
  Month, Period_End,
  Mobile_Broadband_Mn,
  Fixed_Wired_Broadband_Mn,
  Fixed_Wireless_Broadband_Mn,
  Total_Broadband_Subs_Mn
FROM [dbo].[telecom];
GO


-- View 4: GEOGRAPHIC_DISTRIBUTION
CREATE VIEW [dbo].[GEOGRAPHIC_DISTRIBUTION] AS
SELECT
  Month, Period_End,
  Urban_Wireless_Subs_Mn,
  Urban_Wireline_Subs_Mn,
  Urban_Total_Subs_Mn,
  Rural_Wireless_Subs_Mn,
  Rural_Wireline_Subs_Mn,
  Rural_Total_Subs_Mn
FROM [dbo].[telecom];
GO


-- View 5: TELE_DENSITY_DIGITAL_INCLUSION
CREATE VIEW [dbo].[TELE_DENSITY_DIGITAL_INCLUSION] AS
SELECT
  Month, Period_End,
  Overall_Tele_Density_Pct,
  Urban_Tele_Density_Pct,
  Rural_Tele_Density_Pct,
  Wireless_Tele_Density_Pct,
  Urban_Wireless_Tele_Density_Pct,
  Rural_Wireless_Tele_Density_Pct
FROM [dbo].[telecom];
GO


-- View 6: ACTIVE_SUBSCRIBERS
CREATE VIEW [dbo].[ACTIVE_SUBSCRIBERS] AS
SELECT
  Month, Period_End,
  Wireless_Mobile_Subs_Mn,
  Urban_Wireless_Mobile_Subs_Mn,
  Rural_Wireless_Mobile_Subs_Mn,
  Active_VLR_Subs_Mn,
  VLR_Pct_of_Total
FROM [dbo].[telecom];
GO


-- View 7: FWA_AND_5G_BROADBAND
-- Includes urban/rural share columns computed in-view (Power BI Service
-- couldn't compute these as live DAX measures under DirectLake).
CREATE VIEW [dbo].[FWA_AND_5G_BROADBAND] AS
SELECT
  Month, Period_End,
  [5G_FWA_Subs_Mn],
  UBR_FWA_Subs_Mn,
  Total_FWA_Subs_Mn,
  Urban_5G_FWA_Subs_Mn,
  Rural_5G_FWA_Subs_Mn,
  Airtel_5G_FWA_Mn,
  Jio_5G_FWA_Mn,
  Jio_UBR_FWA_Mn,
  ROUND((Urban_5G_FWA_Subs_Mn * 100 / [5G_FWA_Subs_Mn]), 2) AS urban_share,
  ROUND((Rural_5G_FWA_Subs_Mn * 100 / [5G_FWA_Subs_Mn]), 2) AS rural_share
FROM [dbo].[telecom];
GO


-- View 8: IOT_ENTERPRISE_CONNECTIVITY
CREATE VIEW [dbo].[IOT_ENTERPRISE_CONNECTIVITY] AS
SELECT
  Month, Period_End,
  M2M_Connections_Mn
FROM [dbo].[telecom];
GO


-- View 9: MNP_AND_CHURN
CREATE VIEW [dbo].[MNP_AND_CHURN] AS
SELECT
  Month, Period_End,
  MNP_Requests_Month_Mn,
  MNP_Zone1_Mn,
  MNP_Zone2_Mn
FROM [dbo].[telecom];
GO


-- View 10: SUBSCRIBER_GROWTH
CREATE VIEW [dbo].[SUBSCRIBER_GROWTH] AS
SELECT
  Month, Period_End,
  Net_Add_Wireless_Mobile_Mn,
  Net_Add_Wireline_Mn,
  Net_Add_Total_Mn,
  Wireless_Monthly_Growth_Pct,
  Wireline_Monthly_Growth_Pct,
  Total_Monthly_Growth_Pct
FROM [dbo].[telecom];
GO


-- View 11: OPERATOR_PERFORMANCE
-- Includes Jio-Airtel gap columns computed in-view, used to drive the
-- "Jio vs Airtel Broadband Gap" dashboard visual directly.
CREATE VIEW [dbo].[OPERATOR_PERFORMANCE] AS
SELECT
  Month, Period_End,
  Jio_Total_BB_Mn, Airtel_Total_BB_Mn, VIL_Total_BB_Mn, BSNL_Total_BB_Mn,
  Jio_Wired_BB_Mn, Airtel_Wired_BB_Mn, BSNL_Wired_BB_Mn,
  Net_Add_Jio_Mn, Net_Add_Airtel_Mn, Net_Add_VIL_Mn, Net_Add_BSNL_Mn,
  ROUND(Jio_Total_BB_Mn - Airtel_Total_BB_Mn, 2) AS Jio_airtel_diff_total,
  ROUND(Jio_Wired_BB_Mn - Airtel_Wired_BB_Mn, 2) AS Jio_airtel_diff_wired
FROM [dbo].[telecom];
GO


-- View 12: MARKET_SHARE_COMPETITION
CREATE VIEW [dbo].[MARKET_SHARE_COMPETITION] AS
SELECT
  Month, Period_End,
  Private_Wireless_Share_Pct, PSU_Wireless_Share_Pct,
  Private_Wireline_Share_Pct, PSU_Wireline_Share_Pct,
  ROUND(Private_Wireless_Share_Pct + Private_Wireline_Share_Pct, 2) AS Private_share,
  ROUND(PSU_Wireless_Share_Pct + PSU_Wireline_Share_Pct, 2) AS Psu_share
FROM [dbo].[telecom];
GO


-- View 13: WIRELINE_WIRELESS_DIFF
-- Extra view (not in the original BigQuery set) added to precompute the
-- month-over-month wireline/wireless deltas used in the "MoM Growth —
-- Wireline" dashboard visual.
CREATE VIEW [dbo].[WIRELINE_WIRELESS_DIFF] AS
SELECT
  a.Month, b.Period_End,
  a.Total_Wireless_Subs_Mn,
  a.Total_Wireline_Subs_Mn,
  ROUND(a.Total_Wireline_Subs_Mn - LAG(a.Total_Wireline_Subs_Mn)
    OVER (ORDER BY b.Period_End ASC), 2) AS Diff_wireline_subs,
  ROUND(a.Total_Wireless_Subs_Mn - LAG(a.Total_Wireless_Subs_Mn)
    OVER (ORDER BY b.Period_End ASC), 2) AS Diff_wireless_subs
FROM [dbo].[SUBSCRIBER_BASE_MARKET_SIZE] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month;
GO
