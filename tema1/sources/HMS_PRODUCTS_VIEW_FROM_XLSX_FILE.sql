DROP DIRECTORY extern_dir_xlsx;
CREATE OR REPLACE DIRECTORY extern_dir_xlsx AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';

DROP VIEW HMS_PRODUCTS_VIEW;
CREATE OR REPLACE VIEW HMS_PRODUCTS_VIEW AS
select t.*
from TABLE(
       ExcelTable.getRows(
         ExcelTable.getFile('EXTERN_DIR_XLSX','HMS_PRODUCTS.xlsx')
       , 'PRODUCTS'
       ,   '"id_product"      number,
            "description"     VARCHAR2(2000),
            "id_category"       number,
            "price"    number,
            "total_items"            number'
       , 'A2'
       )
     ) t;

SELECT * FROM HMS_PRODUCTS_VIEW;

commit;

CREATE OR REPLACE VIEW OLAP_FACTS_SALES_AMOUNT AS
SELECT OrderView.id_customer, OrderView.order_date, ProductView."id_product", SUM(itemsView.quantity * ProductView."price") as SALES_AMOUNT
FROM HMS_ORDERS_VIEW OrderView 
  INNER JOIN HMS_ORDER_ITEMS_VIEW itemsView
    ON OrderView.id_order = itemsView.id_order 
  INNER JOIN HMS_PRODUCTS_VIEW ProductView 
    ON itemsView.id_product = ProductView."id_product" 
  GROUP BY OrderView.id_customer, ProductView."id_product", OrderView.order_date;
