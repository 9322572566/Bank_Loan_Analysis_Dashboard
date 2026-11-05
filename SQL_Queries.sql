drop database BankLoanDB;
create database  BankLoanDB;

use BankLoanDB;

select * from Bank_Loan_Data;

SELECT COUNT(*) AS Total_Rows
from Bank_Loan_Data;


DESCRIBE Bank_Loan_Data;



ALTER TABLE Bank_Loan_Data
MODIFY COLUMN issue_date DATE;






--------------------------    KPI Cards---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- 1. Total loan Applications?
SELECT COUNT(id) AS Total_Applications
 FROM Bank_Loan_Data;
 -- ---------------------------------------------------
 -- 1. MTD
 
-- SELECT COUNT(id) AS MTD_Total_Applications
-- FROM Bank_Loan_Data
-- WHERE MONTH(issue_date) = 12
--   AND YEAR(issue_date) = 2021;
  
-- 2. Total Funded Amount?
SELECT SUM(Loan_amount) AS Total_Funded_Amount From bank_Loan_Data;

-- SELECT SUM(Loan_amount) AS PMTD_Total_Funded_Amount From bank_Loan_Data
-- where month(issue_date) = 12 AND YEAR(issue_date) = 2021;
  
  -- 3. Total Recived Amount?
  SELECT SUM(total_payment) AS Total_Amount_received FROM Bank_Loan_Data;
  
  -- SELECT SUM(total_payment) AS PMTD_Total_Amount_received FROM bank_loan_data
  -- WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)=2021
  
  
  -- 4. Average Interest Rate?
  SELECT ROUND(AVG(int_rate), 6) *100 AS Avg_Interest_Rate FROM Bank_Loan_Data;
  
-- SELECT ROUND(AVG(int_rate), 6) *100 AS Avg_Interest_Rate FROM Bank_Loan_Data
--   WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021;


-- 5. Average Debt-to-income Ratio(DTI):
select * from Bank_Loan_Data;

select ROUND(AVG(dti),4) *100 AS Avg_DTI FROM bank_Loan_Data;
-- WHERE MONTH(issue_date) = 12 AND YEAR(issu_date)=2021;



-- PROBLEM STATEMENT

-- Dashboard 1.------ Summary-----------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Good Loan vs Bad Loan KPI'S
-----------------------------------------------------
-- 1. Good Loan Application Percentage?
SELECT 
      (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN  id END)* 100)
      /
      COUNT(id) AS Good_loan_percentage
FROM Bank_Loan_Data;
---------------------------------------------------

-- 2. Good Loan Applications?
SELECT COUNT(id) AS Good_Loan_Applications
FROM Bank_Loan_Data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


-- 3.Good Loan Funded Amount?
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
From bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- 4. Good Loan Total Received Amount?
SELECT SUM(total_payment) AS Good_Loan_Recieved_Amount
From bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- ----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- Bad Loan
-----------------------------------
-- 1. bad loan Applications Percentage?
SELECT
      (COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) * 100.0)/
      COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;
      
---------------------------------------------------------------------------------
-- 2. Bad loan Applications?
SELECT COUNT(id) AS  Bad_Loan_Applications 
from bank_loan_data
WHERE loan_status= 'charged off';
---------------------------------------------------------------------------------------------

-- 3.Bad Loan Funded Amount?
SELECT SUM(loan_amount) AS  Bad_Loan_Funded_Amount 
from bank_loan_data
WHERE loan_status= 'charged off';
-----------------------------------------------------------------------------------------------

-- 4.Bad Loan Total Received Amount 
SELECT SUM(total_payment) AS  Bad_Loan_Amount_Recieved
from bank_loan_data
WHERE loan_status= 'charged off';

----------------------------------------------------------------------------------------------
-- LOAN STATUS
-----------------------
SELECT 
      loan_status,
      COUNT(id) AS Total_Loan_applications,
      SUM(total_payment) AS Total_Amount_Received,
      SUM(loan_amount) AS Total_Funded_Amount,
      AVG(int_rate * 100) AS Interest_rate, 
      AVG(dti * 100) AS DTI
FROM
    bank_loan_data
    GROUP BY
	   loan_status;

 ------------------------------------------------------------------------------------------------------------
 -- SELECT
--        loan_status,
--        SUM(total_payment) AS MTD_Total_Amount_Received,
--        SUM(loan_amount) AS MTD_Total_Funded_Amount
-- FROM bank_loan_data
-- WHERE MONTH(issue_date) = 12
-- GROUP BY loan_status ;

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------

-- DASHBOARD 2:OVERVIEW:
----------------------------------------------
-----------------------------------------------
-- CHARTS:

--------------------------------------------------------------------------
-- Q1. Monthly Trends by Issue Date (Line Chart)?
SELECT
    MONTHNAME(STR_TO_DATE(issue_date, '%d-%m-%Y')) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY MONTH(STR_TO_DATE(issue_date, '%d-%m-%Y')),
         MONTHNAME(STR_TO_DATE(issue_date, '%d-%m-%Y'))
ORDER BY MONTH(STR_TO_DATE(issue_date, '%d-%m-%Y'));
      
-- Q2. Regional Analysis by State (Filled MAp):?
SELECT
      address_state,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Recived_Amount
      FROM bank_loan_data
      GROUP BY address_state
      ORDER BY SUM(loan_amount) DESC;
      

-- Q3. Loan Term Analysis(Donut Chart):?
SELECT
      term,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Recived_Amount
      FROM bank_loan_data
      GROUP BY term
      ORDER BY term;
      
-------------------------------------------------------------------------------

-- Q4. Employee Length Analysis (Bar Chart):?
SELECT
      emp_length,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Recived_Amount
      FROM bank_loan_data
      GROUP BY emp_length
      ORDER BY emp_length;
-------------------------------------------------------------------------------------

-- Q5. Loan Purpose Breakdown (bar chart):?
SELECT
      purpose,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Recived_Amount
      FROM bank_loan_data
      GROUP BY  purpose
      ORDER BY COUNT(id) DESC;

-- Q6. Home Ownership Analysis(Tree Map):?
SELECT
      home_ownership,
      COUNT(id) AS Total_Loan_Applications,
      SUM(loan_amount) AS Total_Funded_Amount,
      SUM(total_payment) AS Total_Recived_Amount
      FROM bank_loan_data
      GROUP BY  home_ownership
      ORDER BY COUNT(id) DESC;














