alter session set container = orclpdb;
set term off
set feedback off
spool C:\users_sperrorlogs.csv
@C:\Users\Administrator\Desktop\Final-Project\SQL\csv_sperrorlogs.sql
spool off;
exit