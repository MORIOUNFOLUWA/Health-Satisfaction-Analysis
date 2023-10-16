--Patient's Health Satisfaction in USA Hospitals
--To view the data in the national_results table 
SELECT *
FROM national_results;

--To view the data in the states table 
SELECT *
FROM states;

--To view the data in the responses table 
SELECT *
FROM responses;

--To view the data in the state_results table 
SELECT *
FROM state_results;

--Create a column in national_results table showing the name of the measures
ALTER TABLE national_results
ADD Measure_Name NVARCHAR(255); 

UPDATE national_results
SET Measure_Name = 
    CASE
        WHEN Measure_ID = 'H_CLEAN_HSP' THEN 'Hospital Cleanliness'
		WHEN Measure_ID = 'H_QUIET_HSP' THEN 'Hospital Quietness'
		WHEN Measure_ID = 'H_HSP_RATING' THEN 'Overall Hospital Rating'
	    WHEN Measure_ID = 'H_RECMND' THEN 'Willingness to Recommend Health Facility'
        WHEN Measure_ID = 'H_COMP_1' THEN 'Communication with Nurses'
		WHEN Measure_ID = 'H_COMP_2' THEN 'Communication with Doctors'
		WHEN Measure_ID = 'H_COMP_3' THEN 'Responsiveness of Hospital Staff'
		WHEN Measure_ID = 'H_COMP_5' THEN 'Communication about Medicines'
		WHEN Measure_ID = 'H_COMP_6' THEN 'Discharge Information'
		WHEN Measure_ID = 'H_COMP_7' THEN 'Care Transition'
        ELSE 'Not Applicable'
    END;

	--Create a column in national_results table showing the name of the measures
ALTER TABLE state_results
ADD Measure_Name NVARCHAR(255); 

UPDATE state_results
SET Measure_Name = 
    CASE
        WHEN Measure_ID = 'H_CLEAN_HSP' THEN 'Hospital Cleanliness'
		WHEN Measure_ID = 'H_QUIET_HSP' THEN 'Hospital Quietness'
		WHEN Measure_ID = 'H_HSP_RATING' THEN 'Overall Hospital Rating'
	    WHEN Measure_ID = 'H_RECMND' THEN 'Willingness to Recommend Health Facility'
        WHEN Measure_ID = 'H_COMP_1' THEN 'Communication with Nurses'
		WHEN Measure_ID = 'H_COMP_2' THEN 'Communication with Doctors'
		WHEN Measure_ID = 'H_COMP_3' THEN 'Responsiveness of Hospital Staff'
		WHEN Measure_ID = 'H_COMP_5' THEN 'Communication about Medicines'
		WHEN Measure_ID = 'H_COMP_6' THEN 'Discharge Information'
		WHEN Measure_ID = 'H_COMP_7' THEN 'Care Transition'
        ELSE 'Not Applicable'
    END;

--General KPIs

--**No of health facilities**
SELECT Count (Distinct Facility_ID)
FROM responses

--**Average Response rates**
SELECT avg(Response_Rate)
FROM responses

--**No of states who participated in surveys**
SELECT count (Distinct State)
FROM responses

--**No of regions**
SELECT count (Distinct Region)
FROM states

--Average Response rate trend by Release Period  
SELECT Release_Period, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
GROUP BY  Release_Period
ORDER BY Release_Period DESC;

--National Specific KPIs

--*Average Most positive Satisfaction score by Measure** 
SELECT Measure_ID, Measure_Name, avg(Top_box_Percentage) as Most_Positive_Sat_Score 
FROM national_results
GROUP BY Measure_ID, Measure_Name
ORDER BY avg(Top_box_Percentage) DESC;

--*Average Least positive Satisfaction score by Measure** 
SELECT Measure_ID, Measure_Name, avg(Bottom_box_Percentage) as Least_Positive_Sat_Score 
FROM national_results
GROUP BY Measure_ID, Measure_Name
ORDER BY avg(Bottom_box_Percentage) DESC;

--*Average Survey Response Rates by Region** 
SELECT s.Region, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE Region is NOT NULL
GROUP BY Region
ORDER BY avg(r.Response_rate) DESC;

--State Specific KPIs

--*Average Most positive Satisfaction score by Measure** 
SELECT Measure_ID, avg(Top_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results
GROUP BY Measure_ID;

--*Average Least positive Satisfaction score by Measure** 
SELECT Measure_ID, avg(Bottom_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results
GROUP BY Measure_ID;

--*Average Survey Response Rates by States** 
SELECT s.State_Name, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE Region is NOT NULL
GROUP BY s.State_Name
ORDER BY avg(r.Response_rate) DESC;

--Top 5 States by Average Response Rate
SELECT Top 5 s.State_Name, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE Region is NOT NULL
GROUP BY s.State_Name
ORDER BY avg(r.Response_rate)  DESC;

--Bottom 5 States by Average Response Rate
SELECT Top 5 s.State_Name, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE Region is NOT NULL
GROUP BY s.State_Name
ORDER BY avg(r.Response_rate) ASC;

--Analysis of Satisfaction by Global Items
--*Top 5 States with the highest Average Most positive Satisfaction score for Overall Hospital Rating** 
SELECT TOP 5 s.State_name, avg(sr.Top_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN states as s
ON sr.State = s.State
WHERE sr.Measure_ID = 'H_HSP_RATING'
GROUP BY s.State_name
ORDER BY avg(sr.Top_box_Percentage) DESC;

--*Top 5 States with the highest Average Least positive Satisfaction score for Overall Hospital Rating** 
SELECT TOP 5 s.State_name, avg(sr.Bottom_box_Percentage) as Least_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN states as s
ON sr.State = s.State
WHERE sr.Measure_ID = 'H_HSP_RATING'
GROUP BY s.State_name
ORDER BY avg(sr.Bottom_box_Percentage) DESC;

--*Top 5 States with the highest Average Most positive Satisfaction score for Hospital Referral** 
SELECT TOP 5 s.State_name, avg(sr.Top_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN states as s
ON sr.State = s.State
WHERE sr.Measure_ID = 'H_RECMND'
GROUP BY s.State_name
ORDER BY avg(sr.Top_box_Percentage) DESC;

--*Top 5 States with the Highest Average Least positive Satisfaction score for Hospital Referral** 
SELECT TOP 5 s.State_name, avg(sr.Bottom_box_Percentage) as Least_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN states as s
ON sr.State = s.State
WHERE sr.Measure_ID = 'H_RECMND'
GROUP BY s.State_name
ORDER BY avg(sr.Bottom_box_Percentage) DESC;

--Health Facilities KPIs

--Top 5 Health Facilities by Average Response Rate
SELECT Top 5 r.Facility_ID, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE r.Response_rate is NOT NULL
GROUP BY r.Facility_ID
ORDER BY avg(r.Response_rate) DESC;

--Bottom 5 Health Facilities by Average Response Rate
SELECT Top 5 r.Facility_ID, avg(r.Response_rate) as Avg_Response_rate 
FROM responses as r
LEFT JOIN  states as s
ON s.State = r.State
WHERE r.Response_rate is NOT NULL
GROUP BY r.Facility_ID
ORDER BY avg(r.Response_rate) ASC;

--*Top 5 Health facilities with the highest Average Least positive Satisfaction score for Overall Hospital Rating** 
SELECT TOP 5 r.Facility_ID, avg(sr.Bottom_box_Percentage) as Least_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN responses as r
ON sr.State = r.State
WHERE sr.Measure_ID = 'H_HSP_RATING'
GROUP BY r.Facility_ID
ORDER BY avg(sr.Bottom_box_Percentage) DESC;

--*Top 5 Health facilities with the higest Average Most positive Satisfaction score for Overall Hospital Rating** 
SELECT TOP 5 r.Facility_ID, avg(sr.Top_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN responses as r
ON sr.State = r.State
WHERE sr.Measure_ID = 'H_HSP_RATING'
GROUP BY r.Facility_ID
ORDER BY avg(sr.Top_box_Percentage) DESC;

--*Top 5 Health facilities with the highest Average Least positive Satisfaction score for Hospital Referral** 
SELECT Top 5 r.Facility_ID, avg(sr.Bottom_box_Percentage) as Least_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN responses as r
ON sr.State = r.State
WHERE sr.Measure_ID = 'H_RECMND'
GROUP BY r.Facility_ID
ORDER BY avg(sr.Bottom_box_Percentage) DESC ;

--*Top 5 Health facilities with the higest Average Most positive Satisfaction score for Hospital Referral** 
SELECT TOP 5 r.Facility_ID, avg(sr.Top_box_Percentage) as Most_Positive_Sat_Score 
FROM state_results as sr
LEFT JOIN responses as r
ON sr.State = r.State
WHERE sr.Measure_ID = 'H_RECMND'
GROUP BY r.Facility_ID
ORDER BY avg(sr.Top_box_Percentage) DESC;

-- Creating indexes on state_results table
CREATE INDEX idx_state_results_state ON state_results (State);
CREATE INDEX idx_state_results_measure ON state_results (Measure_ID);
