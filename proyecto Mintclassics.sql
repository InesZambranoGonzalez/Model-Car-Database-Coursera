
/* */
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
SELECT
	products.MSRP,
	orderdetails.productCode,
    COUNT(orderdetails.orderNumber) AS total_times_bought
FROM orderdetails
INNER JOIN products ON orderdetails.productCode = products.productCode
GROUP BY orderdetails.productCode 
ORDER BY total_times_bought DESC; 
	
	





