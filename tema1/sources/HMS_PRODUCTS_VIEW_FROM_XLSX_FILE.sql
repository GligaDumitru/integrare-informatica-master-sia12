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