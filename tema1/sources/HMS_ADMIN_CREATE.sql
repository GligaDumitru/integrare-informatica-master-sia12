alter session set "_ORACLE_SCRIPT"=true;

create user hmsAdmin identified by "hmsAdmin";
GRANT ALL PRIVILEGES
to hmsAdmin;

DROP USER hmsAdmin cascade;
