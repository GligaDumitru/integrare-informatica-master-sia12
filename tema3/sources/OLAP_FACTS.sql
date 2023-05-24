DROP VIEW OLAP_FACTS_SALES_AMOUNT;
CREATE OR REPLACE VIEW OLAP_FACTS_SALES_AMOUNT AS 
SELECT O.ID_CUSTOMER, O.ORDER_DATE, P.ID_PRODUCT, SUM(I.QUANTITY * P.PRICE) AS SALES_AMOUNT
FROM HMS_ORDERS_VIEW O INNER JOIN HMS_ORDER_ITEMS_VIEW I
ON O.ID_ORDER = I.ID_ORDER INNER JOIN HMS_PRODUCTS_VIEW P ON I.ID_PRODUCT = P.ID_PRODUCT group by O.ID_CUSTOMER, O.ORDER_DATE, P.ID_PRODUCT;

--Password1.
SELECT * FROM OLAP_FACTS_SALES_AMOUNT;


DROP VIEW OLAP_FACTS_SALES_AMOUNT;
CREATE VIEW OLAP_FACTS_SALES_AMOUNT AS
SELECT
    O.ORDER_DATE,
    O.ID_CUSTOMER,
    O.ID_TRANSPORTATION,
    SUM(ITEMS.QUANTITY * P.PRICE) AS TOTAL_SALES_AMOUNT
FROM
    HMS_ORDERS_VIEW O
INNER JOIN
    HMS_ORDER_ITEMS_VIEW ITEMS ON O.ID_ORDER = ITEMS.ID_ORDER
INNER JOIN
    HMS_PRODUCTS_VIEW P ON ITEMS.ID_PRODUCT = P.ID_PRODUCT
GROUP BY
    O.ORDER_DATE,
    O.ID_CUSTOMER,
    O.ID_TRANSPORTATION;
       
SELECT * FROM OLAP_FACTS_SALES_AMOUNT;
