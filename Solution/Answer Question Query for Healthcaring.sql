SELECT *
FROM [AutoCareDB].[dbo].[vw_AdmissionData]


-- Question 1 Total Discharge
SELECT 
	COUNT(*) AS total_discharge 
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
WHERE 
	OUTCOME = 'DISCHARGE';


-- Question 2 Average Daily Charge Rate 
SELECT
(SELECT COUNT(*) AS total_discharge 
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
WHERE OUTCOME ='DISCHARGE')/ (SELECT SUM(DURATION_OF_STAY)
FROM [AutoCareDB].[dbo].[vw_AdmissionData])

-- Cast the total discharge first 
SELECT
   CAST( 
    CAST((SELECT COUNT(*) AS total_discharges 
    FROM [AutoCareDB].[dbo].[vw_AdmissionData]
    WHERE OUTCOME ='DISCHARGE') AS FLOAT)/
    CAST((SELECT SUM(DURATION_OF_STAY) AS total_duration_of_stay
    FROM [AutoCareDB].[dbo].[vw_AdmissionData]) AS FLOAT)
   AS DECIMAL(10,2) ) *100 AS AVG_DailyDischargeRate 

--Query if dont use subquery
SELECT 
    ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
    SUM(DURATION_OF_STAY),2) * 100 AS DailyDischargeRate
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
        
-- Question 3 average length of stay (ALOS)
-- Its total length of stay divide by total discharge
SELECT ROUND(SUM(DURATION_OF_STAY) / SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0)
FROM [AutoCareDB].[dbo].[vw_AdmissionData]

--Question 4 Distribution of discharges by age group
-- <18 Pediatric
-- 18 < 65 Adult
-- >= 65 Senior Citizenship

SELECT 
    CASE 
        WHEN AGE < 18 THEN 'Pediatric'
        WHEN AGE BETWEEN 18 AND 65 THEN 'Adult'
        WHEN AGE >= 65 THEN 'Citizenship'
        ELSE 'Unknown'
    END AS AgeGroup,
    COUNT(*) AS Age_Distribution
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
WHERE OUTCOME = 'DISCHARGE'
GROUP BY
CASE 
        WHEN AGE < 18 THEN 'Pediatric'
        WHEN AGE BETWEEN 18 AND 65 THEN 'Adult'
        WHEN AGE >= 65 THEN 'Citizenship'
        ELSE 'Unknown'
    END
ORDER BY 2 DESC;


-- Question Number 5 Distribution of Discharge By Gender
SELECT 
    GENDER,
    COUNT(*) AS gender_distribution
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER
ORDER BY 2 DESC

-- Question Number 6 Distribution of Discharge by Day of the Week
SELECT 
    DATEPART(WEEKDAY, D_O_D) AS day_of_week,
    COUNT(*) AS day_dsitribution
FROM [AutoCareDB].[dbo].[vw_AdmissionData]
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY DATEPART(WEEKDAY, D_O_D)
ORDER BY 1

-- Convert the Date Name 
SELECT 
    FORMAT(D_O_D, 'dddd') AS day_of_week,
    COUNT(*) AS day_dsitribution
FROM dbo.vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D, 'dddd')
ORDER BY 2 DESC