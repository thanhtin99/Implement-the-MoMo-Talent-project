# MoMo Talent Project

![image](https://github.com/user-attachments/assets/b4ca25f6-cf1e-40f2-97d6-376c47589e18)
- Thực hiện EDA dữ liệu
- Xử lý dữ liệu về đúng định dạng để có thể truy vấn và tính toán
- Cột Location(HoChiMinh City về HCMC, 'Other‘ về 'Other Cities‘)
- Cột Gender về female và male

UPDATE Data_Transactions  
SET Amount = CAST(REPLACE(Amount, ',', '') AS INT);  

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

![image](https://github.com/user-attachments/assets/42443248-9e3c-41a8-bf03-ac6fad18a48d)
![image](https://github.com/user-attachments/assets/f97f75b0-7ec6-4320-bc23-4448cfba9664)
![image](https://github.com/user-attachments/assets/bcbbb4f4-facf-4bfc-b411-7983df25feb6)

![image](https://github.com/user-attachments/assets/dbfb126a-367a-4845-afe5-4cf934b1263d)

![image](https://github.com/user-attachments/assets/dc8b4979-cd0e-4419-b3c9-b49b8dc95f4a)

Question: Based on the provided data, what observations and insights can you draw about user demographics and transaction behavior (e.g. trends, classifications)?  
Observations and Insights:  
- User Demographics:  
Age Distribution: Người dùng thuộc nhóm tuổi từ 23-27 chiếm tỷ lệ cao nhất (25.48%), tiếp theo là nhóm 28-32 (20.84%). Nhóm tuổi từ 33-37 và 18-22 cũng chiếm một phần đáng kể nhưng thấp hơn. Điều này cho thấy đa số người dùng MoMo nằm trong độ tuổi lao động trẻ, sinh viên.  
Gender Distribution: Tỷ lệ nam giới sử dụng dịch vụ cao hơn nữ giới trong tất cả các nhóm tuổi, với nhóm nam từ 23-27 chiếm tỷ lệ cao nhất (15.15%).  
- Transaction Behavior:  
Revenue by Merchant: Viettel dẫn đầu về doanh thu trung bình hàng tháng , tiếp theo là Mobifone và Vinaphone. Gmobile có doanh thu thấp nhất.
Location-Based Transaction Amount: Người dùng ở các vùng khác (ngoài HCMC và HN) có xu hướng chi tiêu nhiều hơn, đặc biệt là nhóm tuổi từ 23-27. Trong khi đó, HCMC và HN có mức chi tiêu thấp hơn nhưng vẫn đáng kể.  

