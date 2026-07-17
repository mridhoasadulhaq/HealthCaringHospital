-- Create a view table from CleanData
CREATE OR ALTER VIEW vw_AdmissionData AS 
-- Creating a CTE(temp table) called 'CleanData', to extract non duplicate data 

WITH CleanData AS(
-- Selecting all data to identify duplicate using Dup_No column made by window function
SELECT *,
ROW_NUMBER() OVER(PARTITION BY MRD_No, D_O_A, D_O_D ORDER BY MRD_No) Dup_No
FROM dbo.[HDHI Admission data]
-- ORDER BY MRD_No
)

-- Select non duplicate data 
SELECT * 
FROM CleanData
WHERE Dup_No = 1 AND MRD_No IS NOT NULL
--ORDER BY MRD_No