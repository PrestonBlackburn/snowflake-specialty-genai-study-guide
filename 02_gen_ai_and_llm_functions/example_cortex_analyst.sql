------ Setup For Cortex Analyst -------

CREATE DATABASE semantic_model;
CREATE SCHEMA semantic_model.definitions;
GRANT USAGE ON DATABASE semantic_model TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA semantic_model.definitions TO ROLE PUBLIC;

USE SCHEMA semantic_model.definitions;


---------- Stage to Store Models -------------
CREATE STAGE public DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE public TO ROLE PUBLIC;

CREATE STAGE sales DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE sales TO ROLE sales_analyst;

------------- Usage Monitoring --------------
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;