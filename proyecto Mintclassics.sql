
/* */
CREATE OR REPLACE VIEW `profit_per_warehouses` AS
SELECT 
    warehouses.warehouseCode,
    warehouses.warehousePctCap,
    COUNT(products.productCode) AS total_products, 
    SUM(products.quantityInStock) AS total_stock,
    SUM(products.MSRP - products.buyPrice) AS total_profit
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

CREATE OR REPLACE VIEW `less_than_average_performance_by_products` AS
SELECT popular_products_bought.total_times_bought , products.*
FROM popular_products_bought 
right JOIN products ON popular_products_bought.productCode = products.productCode
WHERE total_times_bought < (SELECT (AVG(total_times_bought)-1) FROM popular_products_bought);
	
SELECT * from less_than_average_performance_by_products;
SELECT * from popular_products_bought;
SELECT * from profit_per_warehouses;



