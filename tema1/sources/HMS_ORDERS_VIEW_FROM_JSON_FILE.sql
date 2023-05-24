DROP FUNCTION get_external_data;
CREATE OR REPLACE FUNCTION get_external_data(
    default_directory VARCHAR2, file_path VARCHAR2) 
RETURN CLOB IS
    json_file bfile := bfilename(UPPER(default_directory),file_path);
    json_clob clob;
    l_dest_offset   integer := 1;
    l_src_offset    integer := 1;
    l_bfile_csid    number  := 0;
    l_lang_context  integer := 0;
    l_warning       integer := 0;    
begin
    dbms_lob.createtemporary(json_clob,true);
    
    dbms_lob.fileopen(json_file, dbms_lob.file_readonly);

    dbms_lob.loadclobfromfile (
    dest_lob      => json_clob,
    src_bfile     => json_file,
    amount        => dbms_lob.lobmaxsize,
    dest_offset   => l_dest_offset,
    src_offset    => l_src_offset,
    bfile_csid    => l_bfile_csid ,
    lang_context  => l_lang_context,
    warning       => l_warning);
    
    dbms_lob.fileclose(json_file);
  
    return json_clob;
end;

DROP DIRECTORY extern_dir_file_json;
CREATE OR REPLACE DIRECTORY extern_dir_file_json AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';

CREATE OR REPLACE VI EW HMS_ORDERS_VIEW AS
with json as
(select JSON_QUERY(get_external_data('EXTERN_DIR_FILE_JSON','HMS_ORDERS.json'),
    '$.orders') doc from dual)
SELECT * FROM  JSON_TABLE( (select doc from json) , '$[*]'  
            COLUMNS ( id_order   PATH '$.id_order'
                    , id_customer PATH '$.id_customer'
                    , id_transportation PATH '$.id_transportation'
                    , order_date     PATH '$.order_date'
                    )  
);

SELECT * FROM HMS_ORDERS_VIEW;

CREATE OR REPLACE VIEW HMS_ORDER_ITEMS_VIEW AS
with json as
(select JSON_QUERY(get_external_data('EXTERN_DIR_FILE_JSON','HMS_ORDER_ITEMS.json'),
    '$.items') doc from dual)
SELECT * FROM  JSON_TABLE( (select doc from json) , '$[*]'  
            COLUMNS ( id_order_item  PATH '$.id_order_item'
                    , id_order   PATH '$.id_order'
                    , id_product PATH '$.id_product'
                    , quantity PATH '$.quantity'
                    )  
);

SELECT * FROM HMS_ORDER_ITEMS_VIEW;

commit;
