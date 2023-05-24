CREATE OR REPLACE DIRECTORY extern_dir_file_xml AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';
SELECT * FROM all_directories WHERE directory_name='EXTERN_DIR_FILE_XML';
GRANT ALL ON DIRECTORY extern_dir_file_xml TO PUBLIC;

DROP VIEW HMS_CITIES_VIEW;
CREATE OR REPLACE VIEW HMS_CITIES_VIEW AS
select * from XMLTABLE(
        '/cities/city'
        passing XMLTYPE(
            BFILENAME('EXTERN_DIR_FILE_XML', 'HMS_CITIES.xml')
            , nls_charset_id('AL32UTF8')
        )
        columns
              id_city            integer             path 'ID_CITY'  
            , name                  varchar2(50)        path 'NAME'
        ) x;
        
SELECT * FROM HMS_CITIES_VIEW;