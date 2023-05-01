-- SELECT s.sid, s.serial#,d.db_link
-- FROM   v$session s, v$dblink d
-- WHERE  s.status = 'ACTIVE' and d.db_link = 'HMSADMINDB';

-- ALTER SYSTEM KILL SESSION '1,51171';
ROLLBACK;

-- hms main db
ALTER SESSION CLOSE DATABASE LINK hmsmaindb;
DROP DATABASE LINK hmsmaindb; 

CREATE DATABASE LINK hmsmaindb
   CONNECT TO hmsAdmin IDENTIFIED BY hmsAdmin
   USING '//localhost:1521/orcl';
   
CREATE OR REPLACE VIEW HMS_USERS_VIEW AS
SELECT * FROM HMS_USERS@hmsmaindb;

SELECT * FROM HMS_USERS_VIEW;
DROP VIEW HMS_USERS_VIEW;

commit;