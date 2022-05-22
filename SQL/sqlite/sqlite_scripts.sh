.read <file_name>             ->> Runs a sql script

.mode column                  ->> Displays the data in columns.. column formatting

.headers on                   ->> Displays the column names

.shell cls                    ->> Clears the screen

.schema table_name            ->> Displays the schema of the table

pragma table_info(table_name) ->> Displays the schema of the table

SELECT * FROM sqlite_schema   ->> Displays the schema of the database

# to update the schema of a table

pragma writable_schema = 1    ->> Allows you to modify the schema of the database

UPDATE SQLITE_MASTER SET SQL = 'CREATE TABLE new_tablename (
    Modified SQL Table
    Modified SQL Table
    Modified SQL Table
    .
    .
)' WHERE name = 'old_tablename';

pragma writable_schema = 0;

# end schema update