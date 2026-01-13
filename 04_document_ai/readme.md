# Section 4: Document AI (12%)

## Setup Document AI

(Deprecated for AI_EXTRACT)  
```sql
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE doc_ai_role;
```
```sql
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
```
```sql
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
```
```sql
GRANT CREATE STREAM, CREATE TABLE, CREATE TASK, CREATE VIEW ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
```
```sql 
GRANT EXECUTE TASK ON ACCOUNT TO ROLE doc_ai_role;
```

Privileges:  

- **DOCUMENT_INTELLIGENCE_CREATOR** database role  
- Create [SNOWFLAKE.ML](http://SNOWFLAKE.ML).DOCUMENT_INTELLIGENCE on schema  
- CREATE MODEL on schema  
- CREATE STREAM, TABLE, TASK, VIEW  
- EXECUTE TASK  

Document AI Usage:

- You want to turn unstructured data from documents into structured data in tables.  
- You want to create pipelines for continuous processing of new documents of a specific type.  
- Business users with domain knowledge prepare the model, and the data engineers working with SQL prepare pipelines to automate the processing of new documents.

Workflow:

1. Create a model build.  
   You create model builds in a dedicated Document AI UI, where you also upload documents, define values for extraction, and verify the answers that the model provides.  
2. Optional: Fine-tune the model.  
   You can fine-tune the model in the Document AI UI if the results provided by the Snowflake Arctic-TILT model are not satisfactory.  
3. Run inference.  
   You use the [<model_build_name>!PREDICT](https://docs.snowflake.com/en/sql-reference/classes/document-intelligence/methods/predict) method and the model build created in the Document AI UI to extract information from documents.


### Virtual WH, DB, Schema Considerations

### Roles + Privileges

Privileges To **Prepare** Document AI Model build

- USAGE: Database, Warehouse  
- OPERATE: Warehouse  
- CREATE [SNOWFLAKE.ML](http://SNOWFLAKE.ML).DOCUMENT_INTELLIGENCE on schema  
- CREATE MODEL on schema  
- USAGE on schema  
- DOCUMENT_INTELLIGENCE_CREATOR database role

Privileges To Create **Processing Pipelines**

- `CREATE`   
  - STAGE  
  - STREAM  
  - TABLE  
  - TASK   
  - VIEW  
- `EXECUTE` TASK on account

## Prepare Documents For Document AI

### Upload Documents

### Train The Model

- 1 model per document type/task

### Requirements (Format Size + Limits)

- <125 pages  
- Pdf, png, docx, eml, jpeg, jpg, htm, html, text, txt, tif, tiff  
- <50MB  
- 1200 X 1200 mm or less  
- Between 50 x 50 and 10,000 x 10,000 pixels

### Question Optimization Best Practices

Guidelines:

- Plain English  
- Know answers you’d expect  
- Be specific  
- Ask single value in each question  
- Assume no knowledge of domain

Ex: What is the date of this agreement?

## Extract Values From Documents Using Document AI

### Conditions

### <model_build_name>!PREDICT query

```sql
<model_build_name>!PREDICT(<presigned_url>,  
                           [<model_build_version>]  
                          )  
```

Get presigned url from GET_PRESIGNED_URL function: 
```sql 
SELECT inspections!PREDICT(  
  GET_PRESIGNED_URL(@pdf_inspections_stage,RELATIVE_PATH), 1)  
FROM DIRECTORY(@pdf_inspections_stage);
```
### Automation of Data Pipeline

To create a processing pipeline:

- Set up the pipeline using **streams** and **tasks**.   
  - Where the **task** triggers the analysis
  - And the **stream on the table** triggers the task (stream is optional)
- Upload new documents to an internal stage.   
- View the extracted information  

```sql
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
```

## Troubleshoot Document AI Given A Use Case

### Extracting Query Troubleshooting

Documents must be in internal/external stage + **Snowflake_SSE** **encryption**  
Error Examples:  
"File extension does not match actual mime type. Mime-Type: application/octet-stream"  
"cannot identify image file <_io.BytesIO object at 0x7f8a800ba020>"  
Fix, make sure SNOWFLAKE_SSE is specified on stage: 
```sql 
CREATE STAGE doc_ai_stage  
  DIRECTORY = (ENABLE = TRUE)  
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
```

### GET_PRESIGNED_URL function

May need to extend presigned url timeout for larger workloads (60 min default expiration)
```sql  
GET_PRESIGNED_URL(@<stage_name> , '<relative_file_path>' , [ <expiration_time> ] )  
```
Default timeout of 60 minutes

### Other Troubleshooting

Too Many documents in one query - maximum of **1000** documents in one query  
Specific Requirements:

- Outlined in error messages, ex: file exceeds maximum size

Document AI Model Not Published - Request failed for external function DOCUMENT_EXTRACT_FEATURES$V1 with remote service error: 422

- Publish the model through the Snowsight UI

Required Privileges, Create A Document AI Model Build:

- Grant the CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE privilege to your role.  
- Grant the CREATE MODEL privilege on the schema that uses the model.  
- Use a unique model build name within the database and schema.  



### Requirements + Privileges

### Cost and Best Practice Considerations

Cost Sources:

- **AI Services Compute** - Extract info with the `<model_build_name>!PREDICT` method (tokens cost)  
  - Based on - number of pages, number of documents, page density, number of data values  
- **Virtual Warehouse Compute** - Running queries, retrieving data, includes `<model_build_name>!PREDICT`   
- **Storage** - uploaded documents to Document AI UI (stored in account). Stages for documents  

Warehouse Sizing: Snowflake recommends using an X-Small, Small, or Medium warehouse. Scaling up the warehouse does not increase the speed of query processing, but might result in unnecessary costs.

Monitor Costs: 
```sql
SELECT * FROM SNOWFLAKE.ORGANIZATION_USAGE.METERING_DAILY_HISTORY  
  WHERE service_type ILIKE '%ai_services%';
```
