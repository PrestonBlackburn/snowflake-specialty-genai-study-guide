use role accountadmin;

-- This is already the default, just for demonstration
-- we'll use the public role for most examples
grant database role snowflake.cortex_user to role public;

-- check the currently allowed models
SHOW PARAMETERS LIKE 'CORTEX_MODELS_ALLOWLIST' IN ACCOUNT;

-- set to all if not done already
alter account set cortex_models_allowlist = 'all';

-- try executing a cortex function
use role public;

CALL SNOWFLAKE.MODELS.CORTEX_BASE_MODELS_REFRESH();
show models in snowflake.models;


select SNOWFLAKE.CORTEX.COMPLETE('llama3.1-70B', 'What is the capital of Colorado?');
-- AI_COMPLETE may or may not show up on exam as it replaces COMPLETE
select SNOWFLAKE.CORTEX.AI_COMPLETE('llama3.1-70B', 'What is the capital of Colorado?');