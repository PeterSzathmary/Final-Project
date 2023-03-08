alter session set container = orclpdb;
set pagesize 0;
set term off;
set feedback off;
spool "&1" append;
-- select distinct dbms_lob.substr(MESSAGE,32767) from &2;
-- select distinct dbms_lob.substr(STATEMENT,32767) from &2;
select distinct dbms_lob.substr(MESSAGE,32767), dbms_lob.substr(STATEMENT,32767) from pjako.sperrorlog;
spool off;
exit;