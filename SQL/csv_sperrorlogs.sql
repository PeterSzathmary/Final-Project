set colsep ,
set headsep off
set pagesize 0
set trimspool on
set markup csv on quote off
SELECT DISTINCT OWNER, OBJECT_NAME 
  FROM DBA_OBJECTS
 WHERE OBJECT_TYPE = 'TABLE'
   AND OBJECT_NAME = 'SPERRORLOG';