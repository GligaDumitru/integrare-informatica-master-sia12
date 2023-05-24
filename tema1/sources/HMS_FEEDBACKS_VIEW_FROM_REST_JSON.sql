-- "C:\Program Files\MongoDB\Server\6.0\bin\mongod.exe" --dbpath="c:\data\db"
grant execute on utl_http to sys;
grant execute on dbms_lock to sys;

CREATE OR REPLACE FUNCTION get_data(pURL VARCHAR2) 
RETURN clob IS
  l_req   UTL_HTTP.req;
  l_resp  UTL_HTTP.resp;
  l_buffer clob; 
begin
  l_req  := UTL_HTTP.begin_request(pURL);
  l_resp := UTL_HTTP.get_response(l_req);
  UTL_HTTP.READ_TEXT(l_resp, l_buffer);
  UTL_HTTP.end_response(l_resp);
  return l_buffer;
end;

------------------------------------------------------------
DROP VIEW HMS_FEEDBACKS_VIEW;

CREATE OR REPLACE VIEW HMS_FEEDBACKS_VIEW AS
with json as  
(select JSON_QUERY(get_data('http://localhost:3000/feedbacks'), '$.feedbacks') doc from dual) 
SELECT *
FROM  JSON_TABLE( (select doc from json) , '$[*]'  
            COLUMNS ( id_feedback   PATH '$.id_feedback'  
                    , id_order_item PATH '$.id_order_item'  
                    , id_customer PATH '$.id_customer'  
                    , rating    PATH '$.rating' 
                    , message    PATH '$.message'  
                    , created_date     PATH '$.created_date'  
                    )  
);
SELECT * FROM HMS_FEEDBACKS_VIEW;


---------------------- NOT ----------------
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

CREATE OR REPLACE VIEW HMS_FEEDBACKS_VIEW AS
with json as
(select JSON_QUERY(get_external_data('EXTERN_DIR_FILE_JSON','db.json'),
    '$.feedbacks.feedbacks') doc from dual)
SELECT * FROM  JSON_TABLE( (select doc from json) , '$[*]'  
            COLUMNS ( id_feedback   PATH '$.id_feedback'
                    , id_order_item PATH '$.id_order_item'
                    , id_customer PATH '$.id_customer'
                    , rating     PATH '$.rating'
                    , message     PATH '$.message'
                    , created_date     PATH '$.created_date'
                    )  
);

SELECT * FROM HMS_FEEDBACKS_VIEW;


commit;


