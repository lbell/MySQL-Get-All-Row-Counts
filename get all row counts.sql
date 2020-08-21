-- Add your schema names into the list below:
SET @tableSchema = '
  ,schema1,
  ,schema2,
  ,schema3,
  ,';
  
-- Uncomment this line if necssary:
-- SET SESSION group_concat_max_len = 10000000;

----------------------------------
-- DO NOT EDIT BELOW THIS POINT --
----------------------------------

/*
Title: My Sql Dumb Backup Script
Author: LBell
Version: 1.0
Lisence: MIT

This script ouputs exact row counts of all specified schemata.

Why?

Because the summary tables found in most MySQL programs utilize the 'ROW_COUNT' field of the `information_schema`
table which is often a guess, especially for InnoDB tables.
*/

SET @rowCounts = (
  SELECT group_concat(
	CONCAT(
	  -- 'SELECT ''',TABLE_SCHEMA,' - ',TABLE_NAME,''', COUNT(*) FROM ', TABLE_NAME
      -- 'SELECT TABLE_NAME, COUNT(*) FROM ', TABLE_NAME
      'SELECT ''',TABLE_SCHEMA,'''AS ''schema'',''',TABLE_NAME,'''AS ''table'', COUNT(*) FROM ', TABLE_SCHEMA,'.',TABLE_NAME
	) 
    SEPARATOR ' union all '
  )
  FROM information_schema.tables
  -- WHERE TABLE_SCHEMA IN ('gppheno','gppheno_dumb_copy')
  WHERE FIND_IN_SET(TABLE_SCHEMA, @tableSchema)
  AND TABLE_TYPE = 'BASE TABLE'
);
PREPARE statement FROM @rowCounts;
EXECUTE statement;
