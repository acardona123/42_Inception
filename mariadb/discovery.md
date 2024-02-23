# Mariadb


## installation

[installation and config](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-debian-11)


## basics commands

[basics](https://mariadb.com/kb/en/mariadb-basics/)
### log in mariadb
- `mariadb -u root -p -h localhost` with `-u` for username, `-p` to prompt for password, `-h` to specify the hostname/IP address of the server
- `
### show all existing databases
`SHOW DATABASES;` 
### creating a structure
- `CREATE DATABASE <database_name>;` to create the empty database
- `USE <database_name>;` to set the database as the one used by default util logging out
- `CREATE TABLE <table_name> (<column1_name> <column1_type> [PRIMARY KEY], <column2_name> <column2_type>, ...)' to create a table with specified fields. *Example: CREATE TABLE books (isbn CHAR(20) AUTO_INCREMENT PRIMARY KEY, title VARCHAR(50),author_id INT,publisher_id INT,year_pub CHAR(4),description TEXT );*
### manipulating a table
- `DESCRIBE <table_name>;` to see all the table structure
- `ALTER TABLE <table_name> ...;` to change the settings of a table, see (this)[https://mariadb.com/kb/en/alter-table/]
- `DROP <table_name>;` to delete a table
### inserting data into a table
`INSERT INTO <table_name> (<column_a__name>, <column_b__name>, <column_c__name>, <column_d__name>)
VALUES (<value1_a_>, <value1_b_>, <value1_c_>, <value1_d_>),
(<value2_a_>, <value2_b_>, <value2_c_>, <value2_d_>);` 
to insert data in the table, the column order does not have to be the one of the table structure.
### retrieving data
Use standard SQL commands with `SELECT ... FROM ...`
### updating data
- changing existing data: `UPDATE <table_name> SET <column_name> = <new_value> WHERE <condition that allow to target only the raws we want to update>;`
- deleting a raw: `DELETE FROM <table_name> WHERE <condition that allow to target only the raws we want to update>`




# Wordpress

