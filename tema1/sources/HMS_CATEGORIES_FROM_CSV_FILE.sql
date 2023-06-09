
DROP DIRECTORY extern_dir_csv;
CREATE OR REPLACE DIRECTORY extern_dir_csv AS 'D:\facultate\integrare-informatie\SIA12\tema1\assets';
GRANT ALL ON DIRECTORY extern_dir_csv TO PUBLIC;
SELECT * FROM all_directories;

DROP TABLE HMS_CATEGORIES;
CREATE TABLE HMS_CATEGORIES (
    id_category NUMBER,
    name VARCHAR2(50),
    description VARCHAR2(150)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY extern_dir_csv
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('HMS_CATEGORIES.csv')
)
REJECT LIMIT UNLIMITED;

SELECT * FROM HMS_CATEGORIES;

commit;




DECLARE
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
 p_schema => 'DEVELOPER',
 p_url_mapping_type => 'BASE_PATH',
 p_url_mapping_pattern => 'developer',
 p_auto_rest_auth => FALSE);
 commit;
END;
/



-- http://localhost:8080/ords/developer/hms_categories2/
-- http://localhost:8080/ords/developer/customers