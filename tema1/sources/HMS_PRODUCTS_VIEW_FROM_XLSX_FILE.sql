DROP DIRECTORY extern_dir_xlsx;
CREATE OR REPLACE DIRECTORY extern_dir_xlsx AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';


CREATE OR REPLACE VIEW HMS_PRODUCTS_VIEW AS
select t."id_product" as ID_PRODUCT, t."product_name" as PRODUCT_NAME, t."description" as DESCRIPTION, t."id_category" as ID_CATEGORY, t."price" as PRICE
from TABLE(
       ExcelTable.getRows(
         ExcelTable.getFile('EXTERN_DIR_XLSX','HMS_PRODUCTS.xlsx')
       , 'PRODUCTS'
       ,   '"id_product"     number,
            "product_name"    VARCHAR2(500),
            "description"     VARCHAR2(2000),
            "id_category"       number,
            "price"            number'
       , 'A2'
       )
     ) t;

CREATE OR REPLACE VIEW HMS_PRODUCTS_VIEW  as
select * from sys.HMS_PRODUCTS_VIEW;

select * from HMS_PRODUCTS_VIEW;

commit;

CREATE OR REPLACE VIEW OLAP_FACTS_SALES_AMOUNT AS 
SELECT 
  O.ID_CUSTOMER,
  O.ORDER_DATE,
  P.ID_PRODUCT,
  SUM(I.QUANTITY * P.PRICE) AS SALES_AMOUNT
FROM HMS_ORDERS_VIEW O INNER JOIN HMS_ORDER_ITEMS_VIEW I
ON O.ID_ORDER = I.ID_ORDER INNER JOIN HMS_PRODUCTS_VIEW P ON I.ID_PRODUCT = P.ID_PRODUCT group by O.ID_CUSTOMER, O.ORDER_DATE, P.ID_PRODUCT;


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