-- $ duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1 : DW - Create Star Schema Tables 
.read 01_create_tables_dw.sql

-- Step 2: DW - Load Data From CSV Files Into Tables
.read 02_load_schema_dw.sql














