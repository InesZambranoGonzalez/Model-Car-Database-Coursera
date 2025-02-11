
/* */
CREATE OR REPLACE VIEW `profit_per_warehouses` AS
SELECT 
    warehouses.warehouseCode,
    warehouses.warehousePctCap,
    COUNT(products.productCode) AS total_products, 
    SUM(products.quantityInStock) AS total_stock,
    SUM(products.MSRP - products.buyPrice) AS total_profit,
    ( SUM(products.quantityInStock)*100/warehouses.warehousePctCap)AS max_cap
FROM warehouses
INNER JOIN products ON warehouses.warehouseCode = products.warehouseCode
GROUP BY warehouses.warehouseCode;

/* */
CREATE OR REPLACE VIEW `popular_products_bought` AS
SELECT
	products.MSRP,
	orderdetails.productCode,
    COUNT(orderdetails.orderNumber) AS total_times_bought
FROM orderdetails
INNER JOIN products ON orderdetails.productCode = products.productCode
GROUP BY orderdetails.productCode 
ORDER BY total_times_bought DESC; 

/* */
CREATE OR REPLACE VIEW `less_than_average_performance_by_products` AS
SELECT popular_products_bought.total_times_bought , products.*
FROM popular_products_bought 
right JOIN products ON popular_products_bought.productCode = products.productCode
WHERE total_times_bought < (SELECT (AVG(total_times_bought)-1) FROM popular_products_bought);

CREATE OR REPLACE VIEW `profit_per_warehouses_updated` AS
SELECT 
    profit_per_warehouses.warehouseCode,
	((profit_per_warehouses.total_stock- SUM(less_than_average_performance_by_products.quantityInStock))/profit_per_warehouses.max_cap)*100 AS newWarehousePctCap,
    profit_per_warehouses.max_cap,
    profit_per_warehouses.total_products - COUNT(less_than_average_performance_by_products.productCode)AS newTotalProducts, 
    profit_per_warehouses.total_stock- SUM(less_than_average_performance_by_products.quantityInStock) AS newTotalStock,
    profit_per_warehouses.total_profit - SUM(less_than_average_performance_by_products.MSRP - less_than_average_performance_by_products.buyPrice) AS newTotalProfit
    
FROM profit_per_warehouses
INNER JOIN less_than_average_performance_by_products ON profit_per_warehouses.warehouseCode = less_than_average_performance_by_products.warehouseCode
GROUP BY profit_per_warehouses.warehouseCode;

SELECT * from less_than_average_performance_by_products;
SELECT * from popular_products_bought;
SELECT * from profit_per_warehouses;
SELECT * from profit_per_warehouses_updated;
SELECT * from warehouses;


