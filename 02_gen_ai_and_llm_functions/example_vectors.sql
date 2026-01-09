use role public;

-------------- TEXT_EMBED_768 ---------------------
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'Embed me plz');


-------------- TEXT_EMBED_1024 ----------------------
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_1024('nv-embed-qa-4', 'embed me plz');


-------------  VECTOR TYPES  -----------------------
-- creating a vector:
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'Embed me plz')::VECTOR(FLOAT, 768);

-- Create a vector from an array
SELECT [1, 2, 3]::VECTOR(FLOAT, 3);


-------------- VECTORY SIMILARITY ----------------

SELECT VECTOR_INNER_PRODUCT( [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3) ), 'INNER_PRODUCT'
UNION
SELECT VECTOR_COSINE_SIMILARITY( [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3) ), 'COSINE_SIMILARITY'
UNION
SELECT VECTOR_L1_DISTANCE( [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3) ), 'L1_DISTANCE'
UNION
SELECT VECTOR_L2_DISTANCE( [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3) ), 'L2_DISTANCE';

SELECT VECTOR_INNER_PRODUCT( SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'Embed me plz')::VECTOR(FLOAT, 768),  SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'DO NOT EMBED')::VECTOR(FLOAT, 768));