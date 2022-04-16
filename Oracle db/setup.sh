sqlplus / as SYSDBA
grant create session to kells;
select DEFAULT_TABLESPACE from DBA_USERS WHERE USERNAME = 'KELLS';
ALTER USER kells quota unlimited on USERS;
grant create view, create procedure, create sequence to kells;