
--------- To track credits used for AI Services including LLM Functions ----------------
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
  WHERE SERVICE_TYPE='AI_SERVICES';

----------- To view the credit and token consumption for each AI Function call ------------
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;


--------- View by Individual Query --------------
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY;
