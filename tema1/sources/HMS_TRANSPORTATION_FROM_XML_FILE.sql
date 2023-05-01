CREATE OR REPLACE DIRECTORY extern_dir_file_xml AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';
SELECT * FROM all_directories WHERE directory_name='EXTERN_DIR_FILE_XML';
GRANT ALL ON DIRECTORY extern_dir_file_xml TO PUBLIC;

DROP VIEW HMS_TRANSPORTATION_VIEW;
CREATE OR REPLACE VIEW HMS_TRANSPORTATION_VIEW AS
select * from XMLTABLE(
        '/transportation/company'
        passing XMLTYPE(
            BFILENAME('EXTERN_DIR_FILE_XML', 'HMS_TRANSPORTATION.xml')
            , nls_charset_id('AL32UTF8')
        )
        columns
              id_company            integer             path 'ID_COMPANY'  
            , name                  varchar2(50)        path 'NAME'
            , address               varchar2(200)       path 'ADDRESS'
            , email                 varchar2(100)       path 'EMAIL'
            , phone                 varchar2(100)       path 'PHONE'
        ) x;
        
SELECT * FROM HMS_TRANSPORTATION_VIEW;
