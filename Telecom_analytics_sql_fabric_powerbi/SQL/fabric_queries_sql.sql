-- ============================================================================
-- TRAI Telecom Analytics 2025-26 — Microsoft Fabric Warehouse (T-SQL)
-- 12 analytical queries — the same 12 business questions answered in
-- bigquery.sql, converted to T-SQL and run against the views in
-- fabric_tsql.sql. No project/server identifiers in this file.
-- ============================================================================


-- ============================================================================
-- Query 1: Competitor Battle  (saved as a view — drives the Power BI ranking visual)
-- ============================================================================
CREATE VIEW [dbo].[COMPETITION_BATTLE] AS
WITH base AS (
  SELECT 'Jio' AS Operator, ROUND(SUM(Net_Add_Jio_Mn), 2) AS Growth_Millions
  FROM [dbo].[OPERATOR_PERFORMANCE]
  UNION ALL
  SELECT 'Airtel', ROUND(SUM(Net_Add_Airtel_Mn), 2)
  FROM [dbo].[OPERATOR_PERFORMANCE]
  UNION ALL
  SELECT 'VIL', ROUND(SUM(Net_Add_VIL_Mn), 2)
  FROM [dbo].[OPERATOR_PERFORMANCE]
  UNION ALL
  SELECT 'BSNL', ROUND(SUM(Net_Add_BSNL_Mn), 2)
  FROM [dbo].[OPERATOR_PERFORMANCE]
)
SELECT
  DENSE_RANK() OVER (ORDER BY Growth_Millions DESC) AS rnk,
  *
FROM base;

-- Insight:
-- Jio tops the list with over 26.57M new subscribers, followed by Airtel at 24.87M.
-- VIL trails far behind with just 1.7M growth over 12 months, while BSNL (a PSU)
-- recorded a net negative — meaning it lost more subscribers than it added.


-- ============================================================================
-- Query 2: 5G FWA Adoption Velocity
-- ============================================================================
WITH base AS (
  SELECT
    a.Month, b.Period_End,
    a.[5G_FWA_Subs_Mn] AS current_month,
    LAG(a.[5G_FWA_Subs_Mn]) OVER (ORDER BY b.Period_End ASC) AS prev_month,
    SUM(a.[5G_FWA_Subs_Mn]) OVER (ORDER BY b.Period_End ASC) AS sums_month
  FROM [dbo].[FWA_AND_5G_BROADBAND] AS a
  JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
)
SELECT
  Month, current_month,
  ROUND(sums_month, 2) AS total_Sum,
  CONCAT(ROUND(((current_month - prev_month) / prev_month) * 100, 2), '%') AS Growth_Percent,
  CASE
    WHEN current_month > prev_month THEN 'Growth'
    WHEN current_month < prev_month THEN 'Decline'
    ELSE 'No Change'
  END AS MOM_Growth
FROM base
ORDER BY Period_End;

-- Insight:
-- 5G FWA subscriber growth accelerated steadily from Apr-25 to Nov-25, peaking at a
-- 35.19% MoM growth rate — strong customer adoption and market expansion.
-- Momentum then weakened between Dec-25 and Feb-26, dropping to single digits and
-- briefly turning negative in Feb-26 (-0.95%), signaling a temporary slowdown.
-- Mar-26 rebounded to 7.88% MoM growth, though still below the earlier peak —
-- a partial recovery rather than a full return to the original pace.


-- ============================================================================
-- Query 3: Urban vs Rural Digital Divide
-- ============================================================================
WITH tele_density AS (
  SELECT
    a.Month, b.Period_End,
    a.Urban_Tele_Density_Pct, a.Rural_Tele_Density_Pct,
    ROUND(a.Urban_Tele_Density_Pct - a.Rural_Tele_Density_Pct, 2) AS density_gap,
    ROUND(a.Rural_Tele_Density_Pct - LAG(a.Rural_Tele_Density_Pct)
      OVER (ORDER BY b.Period_End), 2) AS rural_growth
  FROM [dbo].[TELE_DENSITY_DIGITAL_INCLUSION] AS a
  JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
)
SELECT
  Month, Urban_Tele_Density_Pct, Rural_Tele_Density_Pct,
  density_gap, rural_growth,
  DENSE_RANK() OVER (ORDER BY rural_growth DESC) AS Rural_rnks
FROM tele_density
ORDER BY Period_End;

-- Insight:
-- The urban–rural tele-density gap widened overall, from 73.52 points in Apr-25 to
-- 91.01 points in Mar-26.
-- The gap expanded fastest between Oct-25 and Jan-26, as urban tele-density grew
-- faster than rural during that stretch.
-- Rural tele-density did see its strongest growth in Dec-25 (+0.69), Feb-26 (+0.53)
-- and Oct-25 (+0.26) — but not enough to offset the faster urban pace, so the
-- divide kept widening over the year.


-- ============================================================================
-- Query 4: MNP Churn Alert — Zone Level
-- ============================================================================
SELECT
  a.Month, a.MNP_Zone1_Mn, a.MNP_Zone2_Mn
FROM [dbo].[MNP_AND_CHURN] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End ASC;

-- Insight:
-- Zone-I consistently drove higher churn than Zone-II, leading MNP requests in
-- 10 of the 12 months.
-- Dec-25 recorded the highest churn level (16.12M total MNP requests), with
-- Zone-I contributing the largest share.
-- Churn spiked in Q4 FY25, declined through Jan–Feb 2026, then rebounded in
-- Mar-26 — suggesting seasonal and competitive market influence.


-- ============================================================================
-- Query 5: Network Health — Active SIM Ratio
-- ============================================================================
SELECT
  a.Month, a.Active_VLR_Subs_Mn, a.VLR_Pct_of_Total
FROM [dbo].[ACTIVE_SUBSCRIBERS] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End ASC;

-- Insight:
-- VLR percentage stayed stable around 90.7%–90.9% for most of the year, signalling
-- consistently strong subscriber engagement.
-- Mar-26 recorded the best network health ratio at 93.67%, just above the previous
-- peak of 93.47% in Dec-25.
-- The overall trend is improving, with active-subscriber participation rising over
-- time and clear gains in Dec-25 and Mar-26.


-- ============================================================================
-- Query 6: Wireline Turnaround
-- ============================================================================
SELECT
  a.Month, a.Total_Wireless_Subs_Mn, a.Total_Wireline_Subs_Mn,
  ROUND(a.Total_Wireline_Subs_Mn - LAG(a.Total_Wireline_Subs_Mn)
    OVER (ORDER BY b.Period_End ASC), 2) AS Diff_wireline_subs,
  ROUND((a.Total_Wireline_Subs_Mn - LAG(a.Total_Wireline_Subs_Mn)
    OVER (ORDER BY b.Period_End ASC)) * 100 /
    LAG(a.Total_Wireline_Subs_Mn) OVER (ORDER BY b.Period_End ASC), 2) AS Diff_wireline_subs_in_percent,
  a.Total_Telephone_Subs_Mn
FROM [dbo].[SUBSCRIBER_BASE_MARKET_SIZE] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End ASC;

-- Insight:
-- Wireline subscribers grew every single month, rising from 37.12M to 48.25M
-- (+30%) — a genuine recovery for the segment.
-- Monthly growth accelerated steadily from May-25 to Oct-25 (0.89% → 3.48%),
-- likely reflecting FTTH/fibre expansion.
-- Growth was mostly steady, with a sharp spike in Nov-25 (+9.04%) followed by
-- moderation — strong momentum with one exceptional month, rather than erratic
-- performance.


-- ============================================================================
-- Query 7: M2M Automation Scaling
-- ============================================================================
WITH base AS (
  SELECT
    a.Month, a.M2M_Connections_Mn,
    ROUND(((a.M2M_Connections_Mn - LAG(a.M2M_Connections_Mn)
      OVER (ORDER BY b.Period_End)) * 100) /
      LAG(a.M2M_Connections_Mn) OVER (ORDER BY b.Period_End), 2) AS avg_monthly_growth
  FROM [dbo].[IOT_ENTERPRISE_CONNECTIVITY] AS a
  JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
)
SELECT ROUND(AVG(avg_monthly_growth), 3) AS avg_month FROM base;  -- 1.86%

-- Projection logic:
-- avg_month * 12 months → annualized growth
-- 1.86% * 12 = 22.32%
-- So from a Mar-26 base of 123.66M, M2M connections are projected to reach
-- roughly 151M within the next 12 months if this pace holds.


-- ============================================================================
-- Query 8: Private vs PSU Market Domination
-- ============================================================================
SELECT
  a.Month, a.Private_Wireless_Share_Pct, a.PSU_Wireless_Share_Pct,
  a.Private_Wireline_Share_Pct, a.PSU_Wireline_Share_Pct,
  ROUND(a.Private_Wireless_Share_Pct + a.Private_Wireline_Share_Pct, 2) AS Private_share,
  ROUND(a.PSU_Wireless_Share_Pct + a.PSU_Wireline_Share_Pct, 2) AS PSU_share
FROM [dbo].[MARKET_SHARE_COMPETITION] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End;

-- Insight:
-- Private operators already dominate wireless and are now rapidly expanding
-- their share in wireline too.
-- PSU share keeps declining steadily across both wireless and wireline segments.
-- Wireless remains heavily private-dominated, with PSU share slipping from
-- 8.15% to 7.50% over the period.
-- The sharper shift is in wireline, where PSU share fell from 28.90% to 23.65%
-- while private share rose significantly.
-- Dec-25 stands out as an outlier with a sharp PSU wireline decline and a
-- matching private-share surge — worth investigating further.


-- ============================================================================
-- Query 9: Broadband Data Driver Analysis
-- ============================================================================
WITH base AS (
  SELECT
    a.Month, a.Mobile_Broadband_Mn, a.Fixed_Wired_Broadband_Mn,
    a.Fixed_Wireless_Broadband_Mn, a.Total_Broadband_Subs_Mn
  FROM [dbo].[BROADBAND_INTERNET_ADOPTION] AS a
  JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
)
SELECT
  Month,
  ROUND(Mobile_Broadband_Mn * 100 / Total_Broadband_Subs_Mn, 2) AS Mobiles,
  ROUND(Fixed_Wired_Broadband_Mn * 100 / Total_Broadband_Subs_Mn, 2) AS Fixed_wired,
  ROUND(Fixed_Wireless_Broadband_Mn * 100 / Total_Broadband_Subs_Mn, 2) AS Fixed_wireless,
  ROUND((Fixed_Wired_Broadband_Mn + Fixed_Wireless_Broadband_Mn) * 100 / Total_Broadband_Subs_Mn, 2) AS Fixed
FROM base;

-- Insight:
-- Mobile broadband continues to dominate, consistently accounting for 94–95%
-- of total broadband subscribers.
-- The fixed broadband segment (Wired + Wireless) grew from 4.91% to 5.96%
-- across the year, showing gradual market expansion.
-- That growth is mainly driven by Fixed Wireless Access (FWA), whose share
-- nearly tripled from 0.54% to 1.60%.
-- Overall, the home-internet/fixed broadband segment is steadily increasing
-- its share of the total broadband base.


-- ============================================================================
-- Query 10: Volatility Check — Net Addition
-- ============================================================================
WITH base AS (
  SELECT
    a.Month, a.Net_Add_Total_Mn,
    ROUND(a.Net_Add_Total_Mn - LAG(a.Net_Add_Total_Mn)
      OVER (ORDER BY b.Period_End), 2) AS difference_Mn
  FROM [dbo].[SUBSCRIBER_GROWTH] AS a
  JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
)
SELECT
  ROUND(MAX(Net_Add_Total_Mn) - MIN(Net_Add_Total_Mn), 2) AS diff,
  ROUND(STDEV(Net_Add_Total_Mn), 2) AS stdd
FROM base;

-- Insight:
-- Monthly net additions carry a standard deviation of ~9.0M against an average
-- monthly growth of ~10.2M — a significant amount of variation.
-- The highest net additions came in Nov-25 (35.30M) and Oct-25 (19.57M), while
-- the lowest were in Apr-25 (2.33M) and May-25 (4.36M).
-- The industry isn't growing at a steady pace — large Oct–Nov spikes followed
-- by a sharp Dec pullback point to real volatility in subscriber additions.


-- ============================================================================
-- Query 11: Jio vs Airtel — Broadband Battle
-- ============================================================================
SELECT
  a.Month, a.Jio_Total_BB_Mn, a.Airtel_Total_BB_Mn,
  ROUND(a.Jio_Total_BB_Mn - a.Airtel_Total_BB_Mn, 2) AS Total_diff,
  a.Jio_Wired_BB_Mn, a.Airtel_Wired_BB_Mn,
  ROUND(a.Jio_Wired_BB_Mn - a.Airtel_Wired_BB_Mn, 2) AS Wired_diff
FROM [dbo].[OPERATOR_PERFORMANCE] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End;

-- Insight:
-- Jio's total broadband lead kept growing from Apr-25 to Dec-25 — Airtel wasn't
-- closing the gap for most of the year.
-- From Jan-26 onwards, Airtel gained real ground, with the gap shrinking from
-- 200.09M to 154.6M.
-- In wired broadband specifically, Jio actually extended its lead, with the gap
-- widening from 2.95M to 3.93M.
-- The sudden drop in the total broadband gap between Dec-25 and Jan-26 stands
-- out as a one-off shift worth investigating further, rather than part of a
-- steady trend.
-- Based on the full-year reduction rate (~18% annually), the Jio–Airtel gap
-- would be expected to fall below 100M in roughly 2.5 years (~30 months).
-- However, that estimate is likely optimistic — most of the actual gap
-- reduction came from the single sharp Jan-26 move rather than a consistent
-- month-over-month decline, so a more realistic timeline is closer to ~90
-- months to reach the 100M mark.


-- ============================================================================
-- Query 12: FWA Urban vs Rural Penetration
-- ============================================================================
SELECT
  a.Month, a.[5G_FWA_Subs_Mn],
  a.Urban_5G_FWA_Subs_Mn, a.Rural_5G_FWA_Subs_Mn,
  ROUND(a.Urban_5G_FWA_Subs_Mn * 100 / a.[5G_FWA_Subs_Mn], 2) AS urban_share,
  ROUND(a.Rural_5G_FWA_Subs_Mn * 100 / a.[5G_FWA_Subs_Mn], 2) AS rural_share
FROM [dbo].[FWA_AND_5G_BROADBAND] AS a
JOIN [dbo].[REPORTING_PERIOD] AS b ON a.Month = b.Month
ORDER BY b.Period_End;

-- Insight:
-- Rural 5G FWA share rose from 41.1% in Apr-25 to nearly 50% by Mar-26 —
-- steady growth in rural adoption across the year.
-- The urban-rural mix became far more balanced, with rural subscribers briefly
-- overtaking urban in Nov-25 (50.24% vs 49.76%).
-- By Mar-26, rural and urban shares were almost equal (49.92% vs 50.08%),
-- showing 5G FWA expansion is no longer concentrated in urban markets alone.
-- This suggests operators may need to ramp up rural network investment, since
-- rural demand is growing faster than urban demand.
