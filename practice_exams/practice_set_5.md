# Practice Test 5 (Hard) 
*Questions were AI generated but corrected by me*  

<br/>
<br/>

<br/>

1\. Match the corresponding Document AI features with their Costs:   


A) `<model_build_name>!PREDICT` Usage  
B) Model building  
C) Document Extraction   
D) Document Landing   

1\) AI Services Compute    
2\) Virtual Warehouse Compute   
3\) Storage   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A->1,2, B->1, C->2, D->3**  
**Explanation:**  
- **AI Services Compute**  
  - Extraction with the `<model_build_name>!PREDICT` method (tokens cost)   
  - Based on - number of pages, number of documents, page density, number of data values
  - Model Build (Training/Fine Tuning)      
- **Virtual Warehouse Compute**  
  - Running queries   
  - retrieving data    
  - includes `<model_build_name>!PREDICT`      
- **Storage**  
  - uploaded documents to Document AI UI (stored in account)   
  - Stages for documents    
  - Table for results  

</details>

<br/>

---

2\. Which command will prevent all users from using Cortex Analyst

A) `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_EU'`  
B) `ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = FALSE`
C) `REVOKE DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER FROM PUBLIC`  
D) `REVOKE DATABASE ROLE SNOWFLAKE.CORTEX_USER FROM PUBLIC` 

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explanation:** Cortex analyst access is set at the account level and is not part of the CORTEX_USER Datbase role.

</details>

<br/>

---


<br/>

3\. Which query uses the Document AI model to correctly process all documents stored in an internal stage name `diagrams_stage`?  

A)  
```sql
SELECT diagrams_model!PREDICT(
    GET_PRESIGNED_URL(@diagrams_stage, RELATIVE_PATH), 1)
FROM @diagrams_stage;
```
B)  
```sql
SELECT diagrams_model!PREDICT(@diagrams_stage)
FROM DIRECTORY(@diagrams_stage);
```     
C)  
```sql
SELECT diagrams_model!PREDICT(
    GET_PRESIGNED_URL(@diagrams_stage), 1);
``` 
D)  
```sql
SELECT diagrams_model!PREDICT(
    GET_PRESIGNED_URL(@diagrams_stage, RELATIVE_PATH), 1)
FROM DIRECTORY(@diagrams_stage);
```


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: D**  
**Explanation:**  
- Create a directory on the stage to get the RELATIVE_PATH
- Must use GET_PRESIGNED_URL to get the files

</details>

<br/>

---


<br/>


4\. How can an admin allow only selected users to use Snowflake Cortex functions?

A)  
`GRANT ROLE SNOWFLAKE.CORTEX_USER TO USER user_name;`   
B)   
`GRANT ROLE SNOWFLAKE.CORTEX_FUNCTION_USER to USER user_name;`
C)   
`GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE cortex_user;`  
`GRANT ROLE cortex_user TO USER user_name;`  
D)  
`GRANT USAGE ON SCHEMA SNOWFLAKE.CORTEX TO ROLE cortex_user;`  
`GRANT ROLE cortex_user to USER user_name;`  
 

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explanation:** database roles can't be granted to users, they need to be granted to a role first.  

</details>

<br/>

---

<br/>

5\. Which privileges do you need to create a fully automated Document AI processing pipeline using Snowflake Tasks? (select all that apply)  

A) EXECUTE TASK on ACCOUNT     
B) EXECUTE TASK on SCHEMA      
C) CREATE STAGE on SCHEMA  
D) OPERATE on SCHEMA   
E) CREATE STREAM on SCHEMA  
F) CREATE TASK on SCHEMA  


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A, C, E, F**  
**Explanation:** 
- Execute task is account level  
- Intest documents to STAGE  
- STREAM on the STAGE for document ingestion  
- CREATE TASK in the schema  

</details>

<br/>

---


<br/>


6\. What are some down sides of using cross-region inference? (select all that apply)  

A) Increase in latency    
B) Potential increase in inference token costs  
C) Snowflake warehouse compute charges  
D) Data egress charges    
 

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A, B**  
**Explanation:** 
Considerations:
- Gov regions are limited (US East, US West)  
- Credits are considered consumed in the requesting region   
- No data egress charges for cross region    
- May have additional latency (needs to be tested)     
- Model availability varies   

</details>

<br/>

---

<br/>


7\. What process best way to perform infrence in Snowflake with a model that is not available in Snowflake Cortex?

A) Add the model to the Snowflake Mdoel Registry then perform inference using Snowflake Cortex.    
B) Import the custom model with the `CALL SNOWFLAKE.MODELS.CORTEX_BASE_MODELS_REFRESH('my-custom-model');` procedure then use the model as a Snowflake Cortex model.    
C) Use a Snowpark stored procedure with a model imported from the model registry.     
D) Import the model into the Snowflake Model Registry then execute the model using SPCS.    


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: D**  
**Explanation:** The only only way to execute custom third party models (like from hugging face) is through SPCS. Third party models can still be managed by the Snowflake Model Registry.  
Snowpark procs also work, but the Snowflake ML library will automatically handle the building and creation of stored procs in cases like this.  

</details>

<br/>

---

<br/>


8\. You're auditing a Snowflake environment where a team is implementing Document AI to process corporate PDF invoices.  
The team has verified the following:  

- The required database and schema are already set up  
- Their role has USAGE privileges on the database  
- Their role has USAGE privileges on the warehouse  
- They can execute standard SQL queries successfully  

Despite this setup, they encounter a privilege-related error when trying to create a Document AI model build and upload training documents.  
Given the privilege requirements for preparing a Document AI model build, what additional privilege(s) must be granted to the role on the target schema to successfully create and prepare the Document AI model build?  
Answer Options:    

A) CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE and CREATE MODEL on the schema   
B) OPERATE on the schema and USAGE on the database    
C) Only CREATE MODEL on the schema    
D) Only USAGE on the schema, because model creation is handled by cloud services  
 

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explanation:** To successfully create a Document AI build, upload documents, and test the model, the role requires the following complete set of privileges:  

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

</details>

<br/>

---

<br/>


9\. Your organization receives thousands of unstructured PDF documents daily, including contracts, invoices, and customer correspondence. Your data engineering team wants to leverage Snowflake Cortex to extract valuable insights from these documents and make them searchable and actionable.
After converting these PDFs into a structured format using the PARSE_DOCUMENT function, which TWO capabilities can your team implement to unlock value from this document data?  

A) Automate recurring document processing by scheduling document ingestion pipelines using Snowflake tasks  
B) Enable real-time analytics by creating materialized views directly from data in unstructured documents  
C) Extract specific business entities without training examples by performing zero-shot entity extraction with Snowflake Cortex structured outputs  
D) Extract custom entities using labeled examples by performing multi-shot entity extraction with Snowflake Cortex structured outputs  
E) Power intelligent search capabilities by building RAG (Retrieval-Augmented Generation) pipelines to support Snowflake Cortex Search  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C, E**  
**Explanation:**   
- A and D are a better fit for Document AI  
- B is more Cortex Search  

`PARSE_DOCUMENT` Use Cases:    
- **RAG pipeline optimization:** High-fidelity extraction ensures retrieval systems find relevant content with proper context, dramatically improving answer quality.    
- **Knowledge base construction:** Structured output enables semantic search and AI reasoning across large document collections.   
- **Automated document processing:** Extract entities, generate summaries, and perform analysis on complex documents using other Cortex AI Functions.  
- **Multilingual AI workflows:** Process documents in twelve languages with consistent quality for global enterprise applications. 
</details>

<br/>

---

<br/>


10\. A healthcare organization receives a new type of medical form they've never processed before. Without any prior training or configuration, Document AI is able to successfully extract key information like patient names, dates, and medication details from this unfamiliar document format.
What underlying capability enables Document AI to extract structured data from document types it hasn't encountered previously?   

A) A robust rules engine  
B) Traditional OCR models   
C) Zero-shot extraction powered by a foundation model   
D) Fine-tuning on sample documents  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explanation:** Document AI leverages zero-shot extraction capabilities, which means:

- The model can intelligently extract information from new document types without any prior training examples
- Fine-tuning with your own examples is available as an optional enhancement to improve accuracy, but is not required for basic extraction functionality

This zero-shot capability allows teams to start extracting value from documents immediately, without the overhead of collecting training samples or building custom templates. 

</details>

<br/>

---

<br/>


11\. A financial services company is using Document AI to extract data from mortgage application documents. Their extraction query works perfectly when processing small batches (10-20 documents), but consistently fails when they attempt to process larger batches (100+ documents) or when the query execution extends beyond a certain timeframe.  
The team has confirmed:  

- The Document AI model build is functioning correctly  
- All documents are properly stored in the designated stage  
- The query syntax remains identical across successful and failed runs  
- Small batch processing completes without issues  

What is the most likely cause of these intermittent failures during large-batch processing?  

A) The warehouse is running out of memory during prolonged query execution
B) The model build has exceeded its document processing quota  
C) Concurrent queries are causing resource contention on the stage  
D) The presigned URL used to access staged documents has expired during processing  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: D**  
**Explanation:** Document AI extraction operations rely on presigned URLs to access documents stored in stages. Key considerations:  

- Presigned URLs have time-based expiration - The GET_PRESIGNED_URL function generates URLs with a default 60-minute expiration  
- Long-running queries can outlive the URL - When processing large document batches, if execution time exceeds the URL validity period, access to staged documents fails mid-query  
- This explains the intermittent pattern - Small batches complete quickly (within the 60-minute window), while large batches exceed it  

Solutions:  
- Process documents in smaller batches that complete within the URL expiration window  
- Extend the presigned URL expiration time using the appropriate parameter in GET_PRESIGNED_URL  
- Increase warehouse size to reduce overall query execution time  

</details>

<br/>

---

<br/>


12\. An insurance company wants to build an automated workflow to process incoming claims documents using Document AI. They need to understand the correct order of operations to set up an end-to-end processing pipeline that can handle documents as they arrive and store the extracted information for downstream analytics.  
Which sequence accurately represents the workflow for implementing a Document AI processing pipeline in Snowflake?  

A) Create model build → Store documents in stage → Train with labeled examples → Run extraction queries  
B) Store documents in a stage → Detect new files → Extract information → Store results in tables   
C) Upload documents to stage → Create model build → Schedule tasks → Extract and load to tables  
D) Store documents in stage → Create streams on stage → Build and train model → Automate with tasks  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explanation:** A production-ready Document AI pipeline follows this architecture:  

- Document Storage: Incoming documents (PDFs, images) are uploaded to a Snowflake stage (internal or external)  
- Change Detection: Streams monitor the stage to automatically detect when new documents arrive  
- Automated Extraction: Tasks trigger Document AI extraction queries on new files, pulling structured data from unstructured documents  
- Data Persistence: Extracted information is stored in Snowflake tables for querying, reporting, and integration with other business processes   

Why other options are incorrect:  
- Options A, C, and D place model building in the wrong sequence - the model build should already exist before the pipeline processes documents  
- The correct flow assumes the Document AI model is already trained and ready to extract data as documents arrive    

</details>

<br/>

---

<br/>


13\. A data science team is building a semantic search application in Snowflake and needs to choose the appropriate distance function for comparing text embeddings generated by Cortex. They're evaluating VECTOR_L1_DISTANCE and VECTOR_L2_DISTANCE to determine which best suits their similarity search requirements.  
Which statement correctly explains the fundamental difference between L1 (VECTOR_L1_DISTANCE) and L2 (VECTOR_L2_DISTANCE) distance metrics?A data science team is building a semantic search application in Snowflake and needs to choose the appropriate distance function for comparing text embeddings generated by Cortex. They're evaluating VECTOR_L1_DISTANCE and VECTOR_L2_DISTANCE to determine which best suits their similarity search requirements.  
Which statement correctly explains the fundamental difference between L1 (VECTOR_L1_DISTANCE) and L2 (VECTOR_L2_DISTANCE) distance metrics?   

A) L1 measures cosine similarity between vectors, while L2 measures Euclidean distance  
B) L1 calculates the sum of absolute differences, while L2 uses the square root of squared differences  
C) L1 is optimized for sparse embeddings, while L2 is designed for dense embeddings  
D) L1 computes angular distance between vectors, while L2 computes linear distance  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explanation:** The key mathematical distinction:
Both are magnitude based (don't take into account "angle" between vectors)
- L1 Distance (Manhattan Distance): Computes the sum of absolute differences across all dimensions   
    - Formula: |x₁ - y₁| + |x₂ - y₂| + ... + |xₙ - yₙ|  
    - Represents "city block" distance, like navigating a grid of streets  

- L2 Distance (Euclidean Distance): Computes the square root of the sum of squared differences  
    - Formula: √[(x₁ - y₁)² + (x₂ - y₂)² + ... + (xₙ - yₙ)²]  
    - Represents straight-line distance, like measuring with a ruler  

Practical implications:  
- L1 is less sensitive to outliers and treats all dimensions equally  
- L2 penalizes larger differences more heavily due to squaring  

Arguablly cosine similarity is best in most cases.  
</details>

<br/>

---

<br/>


14\. A customer support team is building an AI-powered chatbot using Snowflake Cortex's COMPLETE function to handle multi-turn conversations with customers. They want the AI to remember earlier parts of the conversation when answering follow-up questions, so responses remain contextually relevant throughout the entire interaction.  
Which approach must be implemented to enable the COMPLETE function to maintain conversational context across multiple turns?  

A) Configure a session variable to automatically persist conversation history in the current Snowflake session  
B) Enable the maintain_context parameter when calling the COMPLETE function  
C) Explicitly pass all previous user prompts and model responses in the prompt_or_history array parameter  
D) Store conversation turns in a temporary table and reference the table name in the function call  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explanation:** Key Concept: The COMPLETE function in Snowflake Cortex is stateless, meaning:   

- It does not automatically remember previous interactions  
- Each function call is independent and has no built-in memory of prior conversations  
- There is no automatic session-level conversation persistence  

Required Implementation:
To create a multi-turn conversational experience, you must:  
- Maintain conversation history in your application layer
- Structure all previous exchanges (both user prompts and model responses) into an array  
- Pass this complete conversation history explicitly via the prompt_or_history parameter with each new function call  

Example:  
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'llama3.1-70b',
  [
    {'role': 'user', 'content': 'What is Snowflake?'},
    {'role': 'assistant', 'content': 'Snowflake is a cloud data platform...'},
    {'role': 'user', 'content': 'What are its key features?'}  -- Current question
  ], {}
) as response;
```
</details>

<br/>

---

<br/>


15\. A retail analytics team is developing an automated sentiment analysis pipeline in Snowflake to process customer product reviews. Their requirements are:
- Process thousands of daily customer reviews automatically  
- Extract structured sentiment data (rating, sentiment category, key themes) and insert directly into a review_analytics table  
- Power real-time BI dashboards that expect consistent column schemas (no nullable or missing fields)  
- Halt processing immediately when AI responses don't match the expected structure to prevent corrupt data from reaching dashboards  

Which implementation approach BEST ensures reliable, schema-compliant AI outputs for this production pipeline?   

A) Use COMPLETE with carefully crafted prompts that instruct the model to return JSON, then parse the response using Snowflake's JSON extraction functions  
B) Use COMPLETE with a defined JSON schema that enforces required fields and data types for every response  
C) Use SENTIMENT function combined with COMPLETE for additional context extraction, validating outputs with SQL CASE statements  
D) Use COMPLETE and implement a stored procedure with TRY-CATCH blocks to validate and retry when responses are malformed  


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explanation:** Why Structured Outputs (Option B) is the Best Solution:
Snowflake Cortex's structured output capability (via JSON schema enforcement in COMPLETE) provides:  
 
- Token-level validation: Each generated token is checked against the schema in real-time during generation  
- Guaranteed schema compliance: The function fails immediately if the model attempts to generate content that violates the schema  
- Zero post-processing ambiguity: No need for regex parsing, string manipulation, or error-prone validation logic  
- Production reliability: Eliminates the risk of malformed data reaching your tables and dashboards  

Why Other Options Fall Short:  
- Option A: Relies on prompt engineering alone—models may still generate inconsistent formats, requiring complex error-prone parsing  
- Option C: SENTIMENT provides limited structured data; additional COMPLETE calls without schema enforcement still risk format inconsistencies  
- Option D: Retry logic adds latency and complexity; doesn't prevent malformed responses, just attempts recovery after failure  

Key Takeaway: For production AI pipelines feeding structured tables and dashboards, structured outputs eliminate the "parse and pray" pattern by enforcing deterministic, schema-compliant JSON at generation time.  
</details>

<br/>

---

<br/>

16\. A financial services company has deployed Snowflake Cortex Search to enable natural language queries over their internal knowledge base. After reviewing their monthly billing, the data team notices consistent Cortex Search credit consumption throughout the month.  
However, usage logs reveal:  

- Only 20-30 search queries were executed during the entire billing period  
- The application had minimal user activity with long idle periods  
- No data refreshes or re-indexing operations occurred  

Which explanation BEST aligns with Snowflake's documented Cortex Search pricing model?  

A) Each search query triggers background index optimization that consumes credits proportional to the dataset size  
B) The search service pre-computes query embeddings for common patterns, consuming credits during idle periods  
C) Serving compute costs are charged based on indexed data volume while the service remains available, independent of query frequency  
D) Cortex Search automatically maintains "hot" indexes in memory, incurring hourly warehouse credits to ensure low-latency responses  


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explanation:** Cortex Search Pricing Model:  
Cortex Search follows a capacity-based pricing model rather than a query-based model:  

- Serving compute cost: Charged per GB per month for the volume of data you've indexed  
- Always active: This cost applies continuously while the search service is available, regardless of whether queries are being executed  
- Separate from warehouse usage: Unlike standard Snowflake queries, this is not warehouse compute—it's infrastructure cost for maintaining the searchable index  

Key Distinction:  
Basically Cortex search needs to be always up to handle any user requests that come in.    

Cost occurs even when:  
- Zero queries are executed   
- The application is idle   
- Users aren't actively searching  

Why Other Options Are Incorrect:   
- Option A: Index optimization doesn't happen per query; indexes are built/maintained separately  
- Option B: Pre-computation isn't the primary cost driver; capacity is  
- Option D: Cortex Search doesn't use traditional warehouse credits for serving  
</details>

<br/>

---