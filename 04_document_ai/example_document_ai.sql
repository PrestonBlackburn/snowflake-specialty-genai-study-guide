----------   Setup (Deprecated for AI_EXTRACT)   -----------
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE doc_ai_role;
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE STREAM, CREATE TABLE, CREATE TASK, CREATE VIEW ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE doc_ai_role;




------------------ Running a created model ------------------
SELECT inspections!PREDICT(  
  GET_PRESIGNED_URL(@pdf_inspections_stage,RELATIVE_PATH), 1)  
FROM DIRECTORY(@pdf_inspections_stage);




--------------- Running in a Pipeline --------------------
CREATE OR REPLACE TASK load_new_file_data
  WAREHOUSE = <your_warehouse>
  SCHEDULE = '1 minutes'
  COMMENT = 'Process new files in the stage and insert data into the pdf_reviews table.'
WHEN SYSTEM$STREAM_HAS_DATA('my_pdf_stream')
AS
INSERT INTO pdf_reviews (
  SELECT
    RELATIVE_PATH AS file_name,
    size AS file_size,
    last_modified,
    file_url AS snowflake_file_url,
    inspection_reviews!PREDICT(GET_PRESIGNED_URL('@my_pdf_stage', RELATIVE_PATH), 1) AS json_content
  FROM my_pdf_stream
  WHERE METADATA$ACTION = 'INSERT'
);