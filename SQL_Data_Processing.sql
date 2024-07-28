use Momo

SELECT Amount
FROM Data_Transactions
WHERE ISNUMERIC(Amount) = 0;

SELECT Rate_pct
FROM Data_Commission
WHERE ISNUMERIC(Rate_pct) = 0;

UPDATE Data_Transactions
SET Amount = CAST(REPLACE(Amount, ',', '') AS INT);

-- Xóa bỏ những dòng không đúng định dạng Date
SELECT Date
FROM Data_Transactions
WHERE ISDATE(Date) = 0;
Delete from Data_Transactions
where ISDATE(Date) = 0


-- 1. Using data from the 'Commission' table, add a column 'Revenue' in the 'Transactions' 
--table that displays MoMo's earned revenue for each order, and then calculate MoMo's total revenue in January 2020.

Alter table Data_Transactions add  Revenue float;


Update Data_Transactions
set Revenue = (t.Amount * c.Rate_pct) / 100
from Data_Transactions t 
join Data_Commission c on t.Merchant_id = c.Merchant_id;


select   SUM(Revenue)  AS Total_Revenue
from Data_Transactions
where Date between '2020-01-01' and '2020-01-31' 

-- 2. What is MoMo's most profitable month?
Select YEAR(Date) as Year, MONTH(Date) as Month, SUM(Revenue) as Total_Revenue
from Data_Transactions
group by YEAR(Date), MONTH(Date)
order by Total_Revenue DESC;


--  3. What day of the week does MoMo make the most money, on average? The least money?

Select   DATENAME (WEEKDAY,Date), DATEPART(WEEKDAY,Date), AVG(Revenue) AS Average_Revenue
from Data_Transactions
group by  DATENAME (WEEKDAY,Date), DATEPART(WEEKDAY,Date)
ORDER BY 
    DATEPART(WEEKDAY, Date);

-- 4. Combined with the 'User_Info' table, add columns: Age, Gender, Location, Type_user
--(New/Current) in 'Transactions' table and calculate the total number of new users in December 2020.			


-- Bước 1: Thêm các cột vào bảng Data_Transactions
ALTER TABLE Data_Transactions
ADD Age VARCHAR(20),
    Gender VARCHAR(10),
    Location VARCHAR(50),
    Type_user VARCHAR(10);

-- Bước 2: Cập nhật các cột mới bằng cách kết hợp với bảng Data_User_Info
UPDATE t
SET t.Age = u.Age,
    t.Gender = u.Gender,
    t.Location = u.Location,
    t.Type_user = CASE 
                    WHEN u.First_tran_date >= '2020-12-01' AND u.First_tran_date <= '2020-12-31' THEN 'New'
                    ELSE 'Current'
                  END
FROM Data_Transactions t
JOIN Data_User_Info u ON t.user_id = u.user_id;

-- Bước 3: Xác định người dùng mới trong tháng 12 năm 2020
SELECT COUNT(DISTINCT t.user_id) AS New_Users_Count
FROM Data_Transactions t
WHERE Type_user ='New'



