-- Listing employee's name and their manager's full name
SELECT 
  e1.firstName AS emp_first_name, 
  e1.lastName AS emp_last_name,
  e1.title,
  e2.firstName AS mgr_first_name,
  e2.lastName AS mgr_last_name
FROM employee AS e1
LEFT JOIN employee AS e2
ON e1.managerId = e2.employeeId;

SELECT *
FROM employee
LIMIT 5;

PRAGMA table_info(employee);

-- Counting transactions per customer
SELECT 
  DISTINCT customerId,
  COUNT (salesId) OVER (PARTITION BY customerId) AS NumSalesOrders
FROM sales 
ORDER BY 2 DESC;

-- Counting transactions per sales person
SELECT
  DISTINCT employeeId,
  COUNT(salesId) OVER (PARTITION BY employeeId) AS NumSalesPerson
FROM sales
ORDER BY 2 DESC;

-- Sales people with zero sales - OPTION 1
WITH sales_team AS (
  SELECT 
    employeeId,
    firstName,
    lastName,
    title
  FROM
    employee
  WHERE 
    title LIKE '%Sales%'
), 
sales_cash AS (
SELECT 
  DISTINCT sales.employeeId
FROM sales
)
SELECT 
  DISTINCT sales_team.employeeId,
  sales_team.firstName,
  sales_team.lastName,
  sales_team.title
FROM sales_team
LEFT JOIN sales_cash
ON sales_team.employeeId = sales_cash.employeeId
WHERE sales_cash.employeeId IS NULL

-- Sales people with zero sales - OPTION 2
WITH sales_cash AS (
  SELECT
    DISTINCT employeeId
  FROM sales
)
SELECT 
  e.employeeId,
  e.firstName,
  e.lastName,
  e.title
FROM employee AS e
WHERE
  e.title LIKE '%Sales%'
  AND NOT EXISTS (
    SELECT 1 
    FROM sales_cash
    WHERE 
      sales_cash.employeeId = e.employeeId
  )

  -- List all sales and customers




