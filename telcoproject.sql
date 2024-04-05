CREATE TABLE customerstatus (
    customer_id varchar PRIMARY KEY,
    satisfaction_score integer,
    customer_status varchar,
    churn_label varchar,
    churn_value integer,
    churn_score integer,
    cltv integer,
    churn_category varchar,
    churn_reason varchar
);

CREATE TABLE demographics (
    customer_id varchar PRIMARY KEY,
    gender varchar,
    age integer,
    married varchar,
    number_of_dependents integer
);

CREATE TABLE population (
    id varchar,
    zip_code integer PRIMARY KEY,
    population varchar
);

CREATE TABLE location (
    customer_id varchar PRIMARY KEY,
    country varchar,
    state varchar,
    city varchar,
    zip_code integer,
    latitude numeric,
    longitude numeric
);

CREATE TABLE service (
    customer_id varchar PRIMARY KEY,
    number_of_referrals integer,
    tenure_in_months integer,
    offer varchar,
    phone_service varchar,
    avg_monthly_long_distance_charges varchar,
    multiple_lines varchar,
    internet_service varchar,
    internet_type varchar,
    avg_monthly_gb_download integer,
    online_security varchar,
    online_backup varchar,
    device_protection_plan varchar,
    premium_tech_support varchar,
    streaming_tv varchar,
    streaming_movies varchar,
    streaming_music varchar,
    unlimited_data varchar,
    contract varchar,
    paperless_billing varchar,
    payment_method varchar,
    monthly_charge numeric,
    total_charges numeric,
    total_refunds numeric,
    total_extra_data_charges numeric,
    total_long_distance_charges numeric,
    total_revenue numeric
);

select * from service;
--Usage Analysis:

-- #1 What is the average monthly data consumption for customers subscribed to different internet service types?
select round(avg(avg_monthly_gb_download),2) as monthly_data, internet_type
from service
group by internet_type

-- #2 How does the average number of streaming movies differ between customers with and without premium tech support?
SELECT 
    premium_tech_support,
    ROUND(AVG(CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END),7) AS avg_streaming_movies
FROM service
GROUP BY premium_tech_support;

--proportion of customers who stream movies (Yes) compared to the total number of customers (both Yes and No),
SELECT 
    Yes,
    No,
    Yes::float / (Yes + No) AS Proportion_Yes
FROM (
    SELECT 
        COUNT(CASE WHEN streaming_movies = 'Yes' THEN 1 END) AS Yes,
        COUNT(CASE WHEN streaming_movies = 'No' THEN 1 END) AS No
    FROM 
        service
) AS counts;

-- #3 Are there any correlations between online security usage and customer tenure?
select online_security, round(avg(tenure_in_months),2) as cust_tenure
from service
group by online_security

-- #4 
select * from customerstatus

-- CREATE TABLE statement for Customer Churn table

CREATE TABLE Customer_Churn (
    CustomerID VARCHAR PRIMARY KEY,
    Gender VARCHAR,
    Age INTEGER,
    Married VARCHAR,
    Number_of_Dependents INTEGER,
    City VARCHAR,
    Zip_Code INTEGER,
    Latitude NUMERIC,
    Longitude NUMERIC,
    Number_of_Referrals INTEGER,
    Tenure_in_Months INTEGER,
    Offer VARCHAR,
    Phone_Service VARCHAR,
    Avg_Monthly_Long_Distance_Charges NUMERIC,
    Multiple_Lines VARCHAR,
    Internet_Service VARCHAR,
    Internet_Type VARCHAR,
    Avg_Monthly_GB_Download INTEGER,
    Online_Security VARCHAR,
    Online_Backup VARCHAR,
    Device_Protection_Plan VARCHAR,
    Premium_Tech_Support VARCHAR,
    Streaming_TV VARCHAR,
    Streaming_Movies VARCHAR,
    Streaming_Music VARCHAR,
    Unlimited_Data VARCHAR,
    Contract VARCHAR,
    Paperless_Billing VARCHAR,
    Payment_Method VARCHAR,
    Monthly_Charge NUMERIC,
    Total_Charges NUMERIC,
    Total_Refunds NUMERIC,
    Total_Extra_Data_Charges NUMERIC,
    Total_Long_Distance_Charges NUMERIC,
    Total_Revenue NUMERIC,
    Customer_Status VARCHAR,
    Churn_Category VARCHAR,
    Churn_Reason VARCHAR
);

-- CREATE TABLE statement for Zip Code Population table
CREATE TABLE Zip_Code_Population (
    Zip_Code INTEGER PRIMARY KEY,
    Population VARCHAR
);

select * from Customer_Churn
select * from Zip_Code_Population

--#1 What is the gender distribution of customers in the dataset?
select gender, count(customerid)
from customer_churn
group by gender

--#2 What is the average age of customers?
select round(avg(age),2) as AverageAge
from customer_churn

--#3 What is the marital status breakdown of customers?
select married, count(customerid)
from customer_churn
group by married

--#4 Which are the top 5 cities with the highest number of customers?
select city, count(customerid) as NoOfCustomers
from customer_churn
group by city
order by NoOfCustomers desc
limit 5

--#5 Average Tenure by Offer Type
select offer, round(avg(tenure_in_months),2)
from Customer_Churn
group by offer

--#6 Percentage of Customers with Phone Service
SELECT (COUNT(CASE WHEN Phone_Service = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS Percentage_With_Phone_Service
FROM Customer_Churn;

--#7 Average Monthly Long Distance Charges by Gender
SELECT Gender, AVG(Avg_Monthly_Long_Distance_Charges) AS Avg_Long_Distance_Charges
FROM Customer_Churn
GROUP BY Gender;

--#8 Top 5 Internet Service Types by Customer Count
SELECT Internet_Service, COUNT(*) AS Total_Customers
FROM Customer_Churn
GROUP BY Internet_Service
ORDER BY Total_Customers DESC
LIMIT 5;

--#9 Customer Churn Analysis by Contract Type
SELECT 
    Contract, 
    COUNT(*) AS Total_Customers, 
    COUNT(CASE WHEN Churn_Category = 'Churned' THEN 1 END) AS Churned_Customers,
    (COUNT(CASE WHEN Churn_Category = 'Churned' THEN 1 END) / COUNT(*)) * 100 AS Churn_Rate
FROM Customer_Churn
GROUP BY Contract;

--#10 Customer Distribution by Churn Category
SELECT Churn_Category, COUNT(*) AS Total_Customers
FROM Customer_Churn
GROUP BY Churn_Category;

--#11 Average Monthly Charge by Internet Type
SELECT Internet_Type, AVG(Monthly_Charge) AS Avg_Monthly_Charge
FROM Customer_Churn
GROUP BY Internet_Type;

--#12 Top 5 Zip Codes with Highest Population
SELECT Zip_Code, Population
FROM Zip_Code_Population
ORDER BY Population DESC
LIMIT 5;

--#13 Average Tenure by churn reason
SELECT 
    Churn_Reason, 
    AVG(Tenure_in_Months) AS Avg_Tenure
FROM Customer_Churn
WHERE customer_status = 'Churned'
GROUP BY Churn_Reason;

--#14 Percentage of Customers with Premium Tech Support
SELECT 
    (COUNT(CASE WHEN Premium_Tech_Support = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS Percentage_With_Premium_Tech_Support
FROM Customer_Churn;

--#15 Customer Distribution by Tenure Range
SELECT 
    CASE 
        WHEN Tenure_in_Months < 12 THEN '0-11 Months'
        WHEN Tenure_in_Months >= 12 AND Tenure_in_Months < 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS Tenure_Range,
    COUNT(*) AS Total_Customers
FROM Customer_Churn
GROUP BY Tenure_Range;

--#16 Total Revenue by Offer Type
SELECT Offer, SUM(Total_Revenue) AS Total_Revenue
FROM Customer_Churn
GROUP BY Offer;

--#18 Churn Rate for the Current Quarter
SELECT COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn;

--#19 Churn Rate Variation by Gender:
SELECT Gender, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY Gender;

--#20 Churn Rate for the Current Quarter:
SELECT COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn;

--#21 Correlation Between Age and Churn Likelihood
SELECT AVG(Age) AS Average_Age_Churned, 
       AVG(CASE WHEN Customer_Status = 'Stayed' THEN Age END) AS Average_Age_Retained
FROM Customer_Churn;

--#22 Effect of Marital Status on Churn:
SELECT Married, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY Married;

--#23 Average Tenure of Churned versus Retained Customers
SELECT Customer_Status, AVG(Tenure_in_Months) AS Avg_Tenure
FROM Customer_Churn
GROUP BY Customer_Status;

--#24 Geographical Patterns in Churn Behavior
SELECT City, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY City;

--#25 Churn Rate Variation by Dependents
SELECT Number_of_Dependents, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY Number_of_Dependents

--#26 Difference in Churn Rate Based on Internet Service Type
SELECT Internet_Service, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY Internet_Service;

--#27 Churn Rate Differences Among Contract Types
SELECT Contract, 
       COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 1.0 / COUNT(*) AS Churn_Rate
FROM Customer_Churn
GROUP BY Contract;

--#28 Average Monthly Charge for Churned versus Retained Customers:
SELECT Customer_Status, AVG(Monthly_Charge) AS Avg_Monthly_Charge
FROM Customer_Churn
GROUP BY Customer_Status;

--#29 How much revenue was lost to churned customers?
SELECT SUM(Total_Revenue) AS Lost_Revenue
FROM Customer_Churn
WHERE Customer_Status = 'Churned';

--Percentage
SELECT 
    SUM(Total_Revenue) AS Lost_Revenue,
    (SUM(Total_Revenue) / (SELECT SUM(Total_Revenue) FROM Customer_Churn)) * 100 AS Lost_Revenue_Percentage
FROM 
    Customer_Churn
WHERE 
    Customer_Status = 'Churned';
	
--#30 Typical tenure for churners
SELECT
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END AS Tenure,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID)) OVER(), 1) AS Churn_Percentage
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END
ORDER BY
    Churn_Percentage DESC;

--#31 Which cities had the highest churn rates?
SELECT
    City,
    ROUND(COUNT(CustomerID) * 100.0 / (SELECT COUNT(CustomerID) FROM Customer_Churn WHERE Customer_Status = 'Churned'), 1) AS Churn_Percentage
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    City
ORDER BY
    Churn_Percentage DESC;
	
--#32 What are the general reasons for churn?
SELECT
    Churn_Category,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Churn_Category
ORDER BY
    Churn_Count DESC;
	
--#33 Specific reasons for churn
SELECT
    Churn_Reason,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Churn_Reason
ORDER BY
    Churn_Count DESC;

--#34 What offers did churn customers have?
SELECT
    Offer,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Offer
ORDER BY
    Churn_Count DESC;
	
--#35 What internet type did churners have?
SELECT
    Internet_Type,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Internet_Type
ORDER BY
    Churn_Count DESC;
	
--#36 Did churners have premium tech support?
SELECT
    Premium_Tech_Support,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Premium_Tech_Support;
	
--#37 What contract were churners on?
SELECT
    Contract,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Contract
ORDER BY
    Churn_Count DESC;

--#38Are high-value customers at risk of churning?
SELECT
    CASE 
        WHEN Total_Charges >= 100 THEN 'High Value'
        ELSE 'Low Value'
    END AS Customer_Value,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY

--#39 Which payment methods are preferred by churned customers?
SELECT
    Payment_Method,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Payment_Method
ORDER BY
    Churn_Count DESC;
	
--#40 Do churned customers tend to have paperless billing?
SELECT
    Paperless_Billing,
    COUNT(CustomerID) AS Churn_Count
FROM
    Customer_Churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Paperless_Billing;
