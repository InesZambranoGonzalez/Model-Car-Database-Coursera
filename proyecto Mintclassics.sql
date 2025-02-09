

SELECT  
	warehouses.warehouseCode,
	products.quantityInStock,
    products.productCode,
    products.MSRP-products.buyPrice as profit
FROM warehouses
INNER JOIN products ON warehouses.warehouseCode = products.warehouseCode;

SELECT 
    warehouses.warehouseCode,
    warehouses.warehousePctCap,
    COUNT(products.productCode) AS total_products, 
    SUM(products.quantityInStock) AS total_stock,
    SUM(products.MSRP - products.buyPrice) AS total_profit
FROM warehouses
INNER JOIN products ON warehouses.warehouseCode = products.warehouseCode
GROUP BY warehouses.warehouseCode;





