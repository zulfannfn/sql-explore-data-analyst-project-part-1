SELECT TOP (1000) [customer_key]
      ,[customer_id]
      ,[customer_number]
      ,[first_name]
      ,[last_name]
      ,[country]
      ,[marital_status]
      ,[gender]
      ,[birthdate]
      ,[create_date]
  FROM [DataWarehouseAnalytics].[gold].[dim_customers];

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='gold.dim_customers';


SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable
FROM sys.columns c
JOIN sys.types t 
    ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('gold.dim_customers');

SELECT DISTINCT
category
FROM [DataWarehouseAnalytics].[gold].[dim_products];

SELECT TOP 5
birthdate
FROM DataWarehouseAnalytics.gold.dim_customers;

SELECT TOP 5
DATEDIFF(year,birthdate, getdate()) as age
FROM DataWarehouseAnalytics.gold.dim_customers;

SELECT
AVG(DATEDIFF(year,birthdate, getdate())) as avg_age
FROM DataWarehouseAnalytics.gold.dim_customers;



-- Exploration semua object table di database di sql server
select * from INFORMATION_SCHEMA.TABLES;

-- Exploration semua object kolom table di database di sql server
select * from INFORMATION_SCHEMA.COLUMNS;
select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='dim_customers';


-- Exploration Data UNIQUE dengan DISTINCT
select DISTINCT
country
from gold.dim_customers;

select DISTINCT
category
from gold.dim_products;

select DISTINCT top 10
category, subcategory, product_name, product_id, category_id
from gold.dim_products order by category asc;

select top 10 * from  gold.dim_products;

select top 10 * from  gold.fact_sales;

-- Mengecek data order pertama dan terakhir [data dalam sistem order]
select 
min(order_date),
max(order_date)
from  gold.fact_sales;

-- Mengecek menghitung rentang waktu dari order pertama dan terakhir
select 
min(order_date),
max(order_date),
-- DATEDIFF(YEAR,tanggal awal order,tanggal terakhir order) [data dalam sistem order] 
DATEDIFF(YEAR,min(order_date),max(order_date)), -- Dalam tahun
DATEDIFF(MONTH,min(order_date),max(order_date)), -- Dalam bulan
DATEDIFF(DAY,min(order_date),max(order_date)) -- Dalam hari
from  gold.fact_sales;


select 
min(birthdate) AS 'DATA TERLAMA',
max(birthdate) AS 'DATA TEARBARU',
DATEDIFF(YEAR,min(birthdate),max(birthdate)) AS 'RENTAN DALAM TAHUN', 
DATEDIFF(MONTH,min(birthdate),max(birthdate))  AS 'RENTAN DALAM BULAN',
DATEDIFF(DAY,min(birthdate),max(birthdate)) AS 'RENTAN DALAM HARI',
AVG(DATEDIFF(YEAR,birthdate,GETDATE())) AS 'RATA RATA USIA customers',
DATEDIFF(YEAR,min(birthdate),GETDATE()) AS 'USIA TERTUA customers',
DATEDIFF(YEAR,max(birthdate),GETDATE()) AS 'USIA TERMUDA customers',
GETDATE() AS 'TANGGAL HARI INI'
from  gold.dim_customers ;

--Temukan Total Penjualan
select sum(sales_amount)  from  gold.fact_sales
select *  from  gold.fact_sales where customer_key='2327';
select sum(sales_amount)  from  gold.fact_sales where customer_key='5400';
select *  from  gold.fact_sales where quantity > 1;
select quantity,price  from  gold.fact_sales where order_number='SO58335';
select sum(quantity) as 'TOTAL TERJUAL dengan', sum(price) as 'TOTAL PRICE'  from  gold.fact_sales where order_number='SO58335';

-- customer order terbanyak
select max(quantity) as JumlahQtyOrder from gold.fact_sales group by customer_key order by JumlahQtyOrder desc;
-- customer order terbanyak
select  CONCAT(sal.customer_key,'|',cus.first_name),max(sal.quantity) as JumlahQtyOrder from gold.fact_sales as sal
left join gold.dim_customers as cus
on cus.customer_key = sal.customer_key
group by sal.customer_key, cus.first_name
order by JumlahQtyOrder desc;
-- customer 1 order terbanyak
SELECT TOP 1 CONCAT(customer_key,'|',first_name) AS CustomerInfo
FROM (
    SELECT sal.customer_key, cus.first_name, MAX(sal.quantity) AS JumlahQtyOrder
    FROM gold.fact_sales AS sal
    LEFT JOIN gold.dim_customers AS cus
        ON cus.customer_key = sal.customer_key
    GROUP BY sal.customer_key, cus.first_name
) AS sub
ORDER BY JumlahQtyOrder DESC;


--Temukan berapa banyak barang yang terjual
select sum(quantity) as 'total barang yang terjual'  from  gold.fact_sales 

--Temukan harga jual rata-rata
select avg(price) as 'rata-rata price'  from  gold.fact_sales 

--Temukan Jumlah Total Pesanan
select *  from  gold.fact_sales;
select count(*)  from  gold.fact_sales;
-- menghitung jumlah order tanpa duplikat 
select count(distinct order_number )  from  gold.fact_sales;

--Temukan jumlah total yang ada di produk
select count(*)  from  gold.dim_products;
select count(distinct product_key) from  gold.dim_products;
--jumlah total produk yang ada di sales
select distinct product_key  from  gold.fact_sales order by product_key asc;
select * from gold.fact_sales where product_key='2';
select distinct sal.product_key,pro.product_name  from  gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
order by sal.product_key asc;

-- temukan product yang tidak terjual
-- menampilkan semua order dan product key nya
select distinct sal.product_key,pro.product_name  from  gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
order by sal.product_key asc;
-- test mencar product key yang tidak ada di sales
select distinct sal.product_key,pro.product_name  from  gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
where sal.product_key='16'
order by sal.product_key asc;
-- menampilkan product yang tidak ada di sales (product yang tidak terjual)
select * from gold.dim_products where product_key not in (select product_key from  gold.fact_sales)
select count(*) from gold.dim_products where product_key not in (select product_key from  gold.fact_sales)


--Temukan jumlah total pelanggan
-- coba distinct customer_key yang adad di sales, tapi masih kurang yakin (jumlah total pelanggan yang telah melakukan pemesanan)
select distinct customer_key  from  gold.fact_sales order by customer_key asc;
-- cari tahu ada berapa banyak sih jumpah customer (ternyata sama jumlahnya) (jumlah total pelanggan)
select * from gold.dim_customers;
-- code awal saya untuk pengecekan sekaligus berapa kali order di setiap customer (jumlah total pelanggan yang telah melakukan pemesanan)
select distinct sal.customer_key,cus.first_name,(select count(customer_key) from gold.fact_sales where customer_key='1') from  gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
where cus.customer_key='1'
order by sal.customer_key asc;
-- code optimal setelah perbaikan
SELECT 
    sal.customer_key,
    cus.first_name,
    COUNT(sal.customer_key) AS total_orders
FROM gold.fact_sales AS sal
LEFT JOIN gold.dim_customers AS cus
    ON sal.customer_key = cus.customer_key
GROUP BY sal.customer_key, cus.first_name
ORDER BY sal.customer_key ASC;

--Temukan jumlah total pelanggan yang telah melakukan pemesanan
SELECT 
    sal.customer_key,
    cus.first_name,
    COUNT(sal.customer_key) AS total_orders
FROM gold.fact_sales AS sal
LEFT JOIN gold.dim_customers AS cus
    ON sal.customer_key = cus.customer_key
GROUP BY sal.customer_key, cus.first_name
ORDER BY sal.customer_key ASC;

SELECT 
    COUNT(distinct sal.customer_key) AS total_orders
FROM gold.fact_sales AS sal
LEFT JOIN gold.dim_customers AS cus
    ON sal.customer_key = cus.customer_key

--Temukan jumlah total pelanggan yang telah melakukan pemesanan
SELECT count(*) from gold.dim_customers where customer_key not in (select customer_key from  gold.fact_sales)


Select 'Total Sales / Pendapatan' as measure_name, sum(sales_amount)  from  gold.fact_sales 
union all
Select 'Total Qty Sales', sum(quantity) as 'total barang yang terjual'  from  gold.fact_sales 
union all
Select 'Rata Rata Harga yang terjual', avg(price) as 'rata-rata price'  from  gold.fact_sales 
union all
Select 'Total order', count(distinct order_number )  from  gold.fact_sales
union all
Select 'Total product', count(distinct product_key) from  gold.dim_products 
union all
Select 'Total product yang terjual', count(*) from gold.dim_products where product_key in (select product_key from  gold.fact_sales)
union all
Select 'Total product yang tidak terjual', count(*) from gold.dim_products where product_key not in (select product_key from  gold.fact_sales)
union all
Select 'Total customer', count(*) from gold.dim_customers
union all
Select 'Total customer yang order',
    COUNT(distinct sal.customer_key) AS total_orders
FROM gold.fact_sales AS sal
LEFT JOIN gold.dim_customers AS cus
    ON sal.customer_key = cus.customer_key
union all
Select 'Total customer yang tidak order', count(*) from gold.dim_customers where customer_key not in (select customer_key from  gold.fact_sales)


--Temukan total pelanggan berdasarkan negara
select country,count(customer_key) as total_customer from gold.dim_customers 
group by country
order by total_customer desc;
select * from gold.dim_customers where country='n/a';
--Temukan total pelanggan berdasarkan gender
select gender,count(customer_key) as total_customer from gold.dim_customers
group by gender
order by total_customer desc;
select * from gold.dim_customers where gender='n/a';
--Temukan total produk berdasarkan kategori
select category,count(category) as total_product from gold.dim_products
group by category
order by total_product desc;
select * from gold.dim_products where category is NULL;
select * from gold.dim_products;
SELECT --menggunakan case when untuk handel data category yang null
    CASE 
        WHEN category IS NULL THEN 'NULL'
        ELSE category 
    END AS category_name,
    COUNT(*) AS total_product
FROM gold.dim_products
GROUP BY CASE 
            WHEN category IS NULL THEN 'NULL'
            ELSE category 
         END
order by total_product desc;
SELECT --menggunakan coalesce untuk handel data category yang null
    COALESCE(category, 'NULL') AS category_name,
    COUNT(*) AS total_product
FROM gold.dim_products
GROUP BY COALESCE(category, 'NULL')
order by total_product desc;
--Berapa biaya rata-rata di setiap kategori?
SELECT
    COALESCE(category, 'NULL') AS category_name,
    avg(cost) as 'Rata Rata COST'
FROM gold.dim_products
GROUP BY COALESCE(category, 'NULL')
order by avg(cost) desc;
select * from gold.dim_products where category='Components';
--Berapa total pendapatan yang dihasilkan untuk setiap kategori?
SELECT
    COALESCE(pro.category, 'NULL') AS category_name,
    sum(sal.sales_amount) as 'Total Amount'
FROM gold.dim_products as pro
left join gold.fact_sales as sal
on pro.product_key = sal.product_key
GROUP BY COALESCE(pro.category, 'NULL')
order by sum(sal.sales_amount) desc;
select * from gold.dim_products where category='Components';
select * from gold.dim_products where category is null;
select * from gold.fact_sales where product_key='1';
--Temukan total pendapatan yang dihasilkan oleh setiap pelanggan
select cus.customer_key,cus.first_name,sum(sal.quantity) as 'Quantity',sum(sal.sales_amount) as 'Total Pendapatan' from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
group by cus.customer_key,cus.first_name
order by sum(sales_amount) desc
--Bagaimana distribusi barang yang dijual di berbagai negara?
select cus.country,sum(sal.quantity) as 'Quantity',sum(sal.sales_amount) as 'Total Pendapatan' from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
group by cus.country
order by sum(sales_amount) desc

-- 5 Product mana yang paling banyak penjualan 
SELECT TOP 5
    COALESCE(pro.product_name , 'NULL') AS product_name,
    sum(sal.quantity) as 'Quantity',
    sum(sal.sales_amount) as 'Total Amount'
FROM gold.dim_products as pro
left join gold.fact_sales as sal
on pro.product_key = sal.product_key
GROUP BY COALESCE(pro.product_name, 'NULL')
order by sum(sal.sales_amount) desc;

-- 5 Product mana yang paling sedikit penjualan 
SELECT
    COALESCE(pro.product_name , 'NULL') AS product_name,
    sum(sal.quantity) as 'Quantity',
    sum(sal.sales_amount) as 'Total Amount'
FROM gold.dim_products as pro
left join gold.fact_sales as sal
on pro.product_key = sal.product_key
where sal.sales_amount is not null
GROUP BY COALESCE(pro.product_name, 'NULL')
order by sum(sal.sales_amount) asc;


-- 5 Product Terlaris
SELECT top 5
    COALESCE(pro.product_name , 'NULL') AS product_name,
    sum(sal.quantity) as 'Quantity',
    sum(sal.sales_amount) as 'Total Amount'
FROM gold.dim_products as pro
left join gold.fact_sales as sal
on pro.product_key = sal.product_key
where sal.sales_amount is not null
GROUP BY COALESCE(pro.product_name, 'NULL')
order by sum(sal.sales_amount) desc;

-- Ranking 

SELECT
    COALESCE(pro.product_name , 'NULL') AS product_name,
    sum(sal.quantity) as 'Quantity',
    sum(sal.sales_amount) as 'Total Amount',
    ROW_NUMBER() OVER  (ORDER BY SUM(sal.sales_amount) desc) as rank_product
FROM gold.dim_products as pro
left join gold.fact_sales as sal
on pro.product_key = sal.product_key
where sal.sales_amount is not null
GROUP BY COALESCE(pro.product_name, 'NULL')

-- Window Function 
select * from (
    SELECT
        COALESCE(pro.product_name , 'NULL') AS product_name,
        sum(sal.quantity) as 'Quantity',
        sum(sal.sales_amount) as 'Total Amount',
        ROW_NUMBER() OVER  (ORDER BY SUM(sal.sales_amount) desc) as rank_product
    FROM gold.dim_products as pro
    left join gold.fact_sales as sal
    on pro.product_key = sal.product_key
    where sal.sales_amount is not null
    GROUP BY COALESCE(pro.product_name, 'NULL') 
) a where rank_product <= 5;

select * from (
    SELECT
        COALESCE(pro.product_name , 'NULL') AS product_name,
        sum(sal.quantity) as 'Quantity',
        sum(sal.sales_amount) as 'Total Amount',
        RANK() OVER  (ORDER BY SUM(sal.sales_amount) desc) as rank_product
    FROM gold.dim_products as pro
    left join gold.fact_sales as sal
    on pro.product_key = sal.product_key
    where sal.sales_amount is not null
    GROUP BY COALESCE(pro.product_name, 'NULL') 
) a where rank_product <= 5;


select  
sal.customer_key,
cus.first_name,
sum(sal.quantity) as JumlahQtyOrder ,
count(distinct sal.order_number) as TotalPesanan,
sum(sal.sales_amount) as TotalPendapatan
from gold.fact_sales as sal
left join gold.dim_customers as cus
on cus.customer_key = sal.customer_key
group by sal.customer_key, cus.first_name
order by TotalPendapatan desc;

select top 3
sal.customer_key,
sal.order_number,
cus.first_name,
cus.last_name ,
sum(sal.quantity) as JumlahQtyOrder,
count(distinct sal.order_number) as TotalPesanan,
sum(sal.sales_amount) as TotalPendapatan,
sal.price as 'Harga Product',
pro.product_name as 'Nama Product'
from gold.fact_sales as sal
left join gold.dim_customers as cus
on cus.customer_key = sal.customer_key
left join gold.dim_products as pro
on pro.product_key = sal.product_key
group by 
sal.customer_key,
sal.order_number,
cus.first_name,
cus.last_name,
sal.price,
pro.product_name
order by customer_key, TotalPesanan, JumlahQtyOrder ,TotalPendapatan asc;

select * from gold.dim_products where product_name='Patch Kit/8 Patches'
select * from gold.fact_sales where product_key='259'
select * from gold.fact_sales where customer_key='1'
select * from gold.fact_sales where order_number='SO57418'
select distinct * from gold.fact_sales;
select * from gold.fact_sales order by order_number;




select * from gold.fact_sales;

select 
order_date,
sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by order_date
order by order_date desc;

select 
year(order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customer_sales,
sum(quantity) as total_quantity_sales
from gold.fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date) desc;

select 
year(order_date) as order_year,
month(order_date) as order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customer_sales,
sum(quantity) as total_quantity_sales
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date) desc;

select 
datetrunc(month,order_date) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customer_sales,
sum(quantity) as total_quantity_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date)
order by datetrunc(month,order_date) desc;

select 
datetrunc(year,order_date) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customer_sales,
sum(quantity) as total_quantity_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
order by datetrunc(year,order_date) desc;

select 
format(order_date, 'yyyy-MMM') as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customer_sales,
sum(quantity) as total_quantity_sales
from gold.fact_sales
where order_date is not null
group by format(order_date, 'yyyy-MMM')
order by format(order_date, 'yyyy-MMM') desc;


--================

select 
datetrunc(year, order_date) as order_date,
sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(year, order_date)
order by datetrunc(year, order_date) desc;

select 
order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales
from (
    select 
        datetrunc(year, order_date) as order_date,
        sum(sales_amount) as total_sales
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(year, order_date)
) as t

select 
order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales
from (
    select 
        datetrunc(MONTH, order_date) as order_date,
        sum(sales_amount) as total_sales
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(MONTH, order_date)
) as t
order by 
order_date,
total_sales,
sum(total_sales) over (order by order_date)
desc

select 
format(order_date, 'yyyy-MMM') as order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales
from (
    select 
        datetrunc(MONTH, order_date) as order_date,
        sum(sales_amount) as total_sales
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(MONTH, order_date)
) as t
order by 
order_date,
total_sales,
sum(total_sales) over (order by order_date)
desc


select 
format(order_date, 'yyyy-MMM') as order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales,
sum(total_sales) over (partition by order_date order by order_date) as running_total_sales
from (
    select 
        datetrunc(MONTH, order_date) as order_date,
        sum(sales_amount) as total_sales
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(MONTH, order_date)
) as t
order by 
order_date,
total_sales,
sum(total_sales) over (order by order_date)
desc

select 
format(order_date, 'yyyy-MMM') as order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales,
avg(rata_rata) over (order by order_date) as rata_rata
from (
    select 
        datetrunc(year, order_date) as order_date,
        sum(sales_amount) as total_sales,
        avg(price) as rata_rata
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(year, order_date)
) as t
order by 
order_date,
total_sales,
running_total_sales,
rata_rata
desc

-- Perfomance Analysis
select * from gold.fact_sales  where order_date is null;
select * from gold.fact_sales ;
select * from gold.dim_products  ;

with yearly_product_sales as (
select 
year(sal.order_date) as order_date,
pro.product_name,
sum(sal.sales_amount) as total_amount
from 
gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
where order_date is not null
group by year(sal.order_date),pro.product_name
)

select 
order_date,
product_name,
total_amount,
avg(total_amount) over (partition by product_name ) as avg_sales,
total_amount - avg(total_amount) over (partition by product_name ) as performance_sales,
case
    when total_amount - avg(total_amount) over (partition by product_name ) > 0 then 'Lebih dari rata rata'
    when total_amount - avg(total_amount) over (partition by product_name ) < 0 then 'Kurang dari rata rata'
    else 'Sama dengan rata rata'
end,
lag(total_amount) over (partition by product_name order by order_date) py_sales,
case 
    when lag(total_amount) over (partition by product_name order by order_date) > 0 then 'Meningkat'
    when lag(total_amount) over (partition by product_name order by order_date) < 0 then 'Menururun'
    else 'data previous tidak ada'
end as ket,
(total_amount - lag(total_amount) over (partition by product_name order by order_date)) as growth,
lead(total_amount) over (partition by product_name order by order_date) as ny_sales
from
yearly_product_sales
where product_name='Road-650 Red- 52'
order by order_date,product_name



-- kontribusi per kategory berdasarkan total sales
select sum(sales_amount) from gold.fact_sales
select category from gold.dim_products where category is not null group by category

select pro.category,sum(sal.sales_amount) from gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
group by pro.category;


with total_amount_group_category as (
select 
    pro.category,
    sum(sal.sales_amount) as total_amount
from gold.fact_sales as sal
left join gold.dim_products as pro
on sal.product_key = pro.product_key
group by pro.category
)

select 
    category,
    total_amount,
    sum(total_amount) over () as overall_sales,
    cast (total_amount as float) as hanya_di_float,
    (cast (total_amount as float)/ sum(total_amount) over ()) * 100,
    ROUND((cast (total_amount as float)/ sum(total_amount) over ()) * 100,1),
    CONCAT(ROUND((cast (total_amount as float)/ sum(total_amount) over ()) * 100,1),'%')
from total_amount_group_category
group by category,total_amount;


SELECT ROUND(123.454, 2);
-- 123.450
SELECT ROUND(123.455, 2);
-- 123.460


--- Data Segmentation ---
with segmentation_cost as (
select 
    product_key,
    cost,
    case 
        when cost < 100 then 'Lebih kecil dari 100'
        when cost between 100 and 500 then '100 sampai 500'
        when cost between 500 and 1000 then '500 sampai 1000'
        else 'lebih besar dari 1000'
    end as segment_cost
from gold.dim_products
)

select 
    segment_cost,
    count(product_key) as total_product
from segmentation_cost 
group by segment_cost

-- Chalange --
select * from gold.fact_sales where product_key='3'
select * from gold.dim_products

select 
    sal.customer_key,
    cus.first_name,
    sal.sales_amount
from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key

select 
    sal.customer_key,
    cus.first_name,
    sum(sal.sales_amount)
from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
group by sal.customer_key,cus.first_name;

with segment_by_sales_amount as (
select  
    sal.customer_key,
    cus.first_name,
    MIN(sal.order_date) as 'Transaksi Pertama',
    MAX(sal.order_date) as 'Transaksi Terakhir',
    DATEDIFF(month, MIN(sal.order_date), MAX(sal.order_date)) as range_dalam_bulan,
    sum(sal.sales_amount) 'total_amount',
    case
        when sum(sal.sales_amount) > 5000 and DATEDIFF(month, MIN(sal.order_date), MAX(sal.order_date)) >= 12 then 'VIP'
        when sum(sal.sales_amount) > 0 and DATEDIFF(month, MIN(sal.order_date), MAX(sal.order_date)) >= 12 then 'REGULAR'
        when DATEDIFF(month, MIN(sal.order_date), MAX(sal.order_date)) <= 12 then 'BARU'
        else 'ANEH'
    END as segmentasi
from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
group by sal.customer_key, cus.first_name

)

select 
    segmentasi,
    count(customer_key)
from segment_by_sales_amount
group by segmentasi;



-- =============================== --
-- ======= Customer Report ======= --
-- =============================== --
create view gold.report_customers_rev as 
with base_data as (
-- ======= Base Query Saya : Mengumpulkan bidang penting seperti nama, usia, dan rincian transaksi ======= --
select 
sal.order_number,
sal.order_date,
sal.product_key,
sal.sales_amount,
sal.quantity,
cus.customer_key,
cus.customer_number,
CONCAT(cus.first_name,' ',cus.last_name) as full_name,
DATEDIFF(year,cus.birthdate, GETDATE()) as age
from gold.fact_sales as sal
left join gold.dim_customers as cus
on sal.customer_key = cus.customer_key
where sal.order_date is not null
),

customer_agregasi as (
-- ======= customer_agregasi : Menggabungkan metrik tingkat pelanggan: ======= --
select
customer_key,
customer_number,
full_name,
age,
MIN(order_date) as pertamakali_transaksi,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as range_dalam_bulan,
MAX(order_date) as terakhir_transaksi,
count(distinct product_key) as total_product_yang_dibeli,
sum(quantity) as total_qty_sales,
count(distinct order_number) as total_transaksi,
sum(sales_amount) as total_amount_sales
from base_data
group by 
customer_key,
customer_number,
full_name,
age
),

-- ======= customer_segmentasi : Segmentasikan pelanggan ke dalam kategori (VIP, Reguler, Baru) dan kelompok usia. ======= --
segmentasi as (
select 
customer_key,
customer_number,
full_name,
age,
pertamakali_transaksi,
range_dalam_bulan,
terakhir_transaksi,
total_product_yang_dibeli,
total_qty_sales,
total_transaksi,
total_amount_sales,
case
    when age < 30 then 'Under 30'
    when age < 50 then 'Under 50'
    when age < 80 then 'Under 80'
    else 'Upper 80'
end as segmentasi_age,
case
    when total_amount_sales > 5000 and range_dalam_bulan >= 12 then 'VIP'
    when total_amount_sales > 0 and range_dalam_bulan >= 12 then 'REGULAR'
    when range_dalam_bulan <= 12 then 'BARU'
    else 'ANEH'
END as segmentasi_cus,
-- Compuate Average Order Value. (AVO) | Total Sales Amount / Jumlah Order 
case
    when total_amount_sales = 0 then NULL -- jaga-jaga saja
    else total_amount_sales / NULLIF(total_transaksi, 0)
end as average_order_value,
-- Average Spend per Unique Product. (ASUP) | Rata-rata uang yang dikeluarkan customer untuk setiap produk unik yang pernah dia beli. Total Sales Amount / unik product yang pernah di beli
case
    when total_amount_sales = 0 then total_amount_sales
    else total_amount_sales / NULLIF(total_product_yang_dibeli, 0)
end as average_spend_per_unique_product,
-- average_spend_per_bulan
case
    when total_amount_sales = 0 then total_amount_sales
    else total_amount_sales / NULLIF(range_dalam_bulan, 0)
end as average_spend_per_bulan
from customer_agregasi
group by 
customer_key,
customer_number,
full_name,
age,
pertamakali_transaksi,
terakhir_transaksi,
range_dalam_bulan,
total_product_yang_dibeli,
total_qty_sales,
total_transaksi,
total_amount_sales
)

select
*
from segmentasi;

