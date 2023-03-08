set term off
set feed off
-- &1 -> which container ?
-- &2 -> output file path
-- &3 -> path to sql file to execute (should be some info script)
-- which container to use
ALTER SESSION SET CONTAINER = &1;
-- where to store output
spool "c:\DB\&2" append
-- which sql script to execute
@c:\DB\&3
spool off
exit