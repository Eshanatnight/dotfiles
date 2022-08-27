# Database

## Oracle

### Creating a new User

```terminal
sqlplus / as SYSDBA
```

```terminal
grant create session to kells;
```

```terminal
select DEFAULT_TABLESPACE from DBA_USERS WHERE USERNAME = 'KELLS';
```

```terminal
ALTER USER kells quota unlimited on USERS;
```

```terminal
grant create view, create procedure, create sequence to kells;
```

## SQLite

|command                        |description|
|-                              |-                |
|`.read <file_name>`            |Runs a sql script|
|`.mode column`                 |Displays the data in columns.. column formatting|
|`.headers on`                  |Displays the column names|
|`.shell cls`                   |Clears the screen|
|`.schema table_name`           |Displays the schema of the table|
|`pragma table_info(table_name)`|Displays the schema of the table|
|`SELECT * FROM sqlite_schema`  |Displays the schema of the database|

### to update the schema of a table

Use the following command to allow modifications of the schema of the database

```terminal
pragma writable_schema = 1
```

```sql
UPDATE SQLITE_MASTER SET SQL = 'CREATE TABLE new_tablename (
    Modified SQL Table
    Modified SQL Table
    Modified SQL Table
    .
    .
)' WHERE name = 'old_tablename';
```

```terminal
pragma writable_schema = 0
```
