
ALTER SESSION SET CONTAINER = "&2";

spool "&1";

set colsep |
set linesize 100 pages 100 trimspool on numwidth 14 

col name format a25
col owner format a15 
col "Used (GB)" format a15
col "Free (GB)" format a15 
col "(Used) %" format a15 
col "Size (M)" format a15 

SELECT d.status "Status", d.tablespace_name "Name", 
 TO_CHAR(NVL(a.bytes / 1024 / 1024 /1024, 0),'99,999,990.90') "Size (GB)", 
 TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024 /1024,'99999999.99') "Used (GB)", 
 TO_CHAR(NVL(f.bytes / 1024 / 1024 /1024, 0),'99,999,990.90') "Free (GB)", 
 TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), '990.00') "(Used) %"
 FROM sys.dba_tablespaces d, 
 (select tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) a, 
 (select tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name) f WHERE 
 d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = f.tablespace_name(+) AND NOT 
 (d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY') 
UNION ALL 
SELECT d.status 
 "Status", d.tablespace_name "Name", 
 TO_CHAR(NVL(a.bytes / 1024 / 1024 /1024, 0),'99,999,990.90') "Size (GB)", 
 TO_CHAR(NVL(t.bytes,0)/1024/1024 /1024,'99999999.99') "Used (GB)",
 TO_CHAR(NVL((a.bytes -NVL(t.bytes, 0)) / 1024 / 1024 /1024, 0),'99,999,990.90') "Free (GB)", 
 TO_CHAR(NVL(t.bytes / a.bytes * 100, 0), '990.00') "(Used) %" 
 FROM sys.dba_tablespaces d, 
 (select tablespace_name, sum(bytes) bytes from dba_temp_files group by tablespace_name) a, 
 (select tablespace_name, sum(bytes_cached) bytes from v$temp_extent_pool group by tablespace_name) t 
 WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = t.tablespace_name(+) AND 
 d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY';
 spool off;
exit