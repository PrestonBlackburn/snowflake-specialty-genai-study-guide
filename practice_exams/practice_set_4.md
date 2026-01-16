# Practice Test 4 (Questions With Explinations) 
*Questions were AI generated but corrected by me*  

<br/>
<br/>


1\. Your company operates in both AWS US-EAST-1 and AWS EU-WEST-1 regions. Your primary Snowflake account is in US-EAST-1, but you need to use the `llama-3.1-405b` model which is only available in EU-WEST-1. Your data governance team is concerned about data egress charges.

A) `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_EU'`  
B) Replicate your database to EU-WEST-1 and run queries there  
C) Use database replication with fine-tuned models  
D) This use case is not supported due to data sovereignty requirements  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explanation:** Cross-region inference can be enabled for specific regions. There are no data egress charges for cross-region Cortex inference, though there may be additional latency. Option B is unnecessary overhead, C is for fine-tuned models only, and D is incorrect as cross-region is specifically designed for this scenario.

</details>

<br/>

---

<br/>

2\. You're building a conversational AI application that needs to handle both customer service chat logs (unstructured) and sales data from your CRM (structured). The application should autonomously decide which data source to query and orchestrate complex multi-step workflows.   

Which Snowflake Cortex feature is most appropriate?  

A) Cortex Analyst with semantic models  
B) Cortex Search with RAG  
C) Cortex Agents with custom tools  
D) Cortex LLM Functions with COMPLETE  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** Cortex Agents orchestrate across both structured and unstructured data sources, can use multiple tools (including Cortex Search for unstructured and Cortex Analyst for structured data), and handle complex workflows with planning, tool use, and reflection capabilities.

</details>

<br/>

---

<br/>

3\. Your data engineering team is designing a vector search solution for 10 million customer support tickets. The CATEGORY field has only 5 distinct values: "Billing", "Technical", "Account", "Product", "Other". The PRODUCT_NAME field has 50,000+ distinct values.  

For which field(s) should you create a Cortex Search service?    

A) Both CATEGORY and PRODUCT_NAME  
B) Only CATEGORY  
C) Only PRODUCT_NAME  
D) Neither - use standard WHERE clauses  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** Cortex Search is best for high cardinality fields (>10 distinct values). For CATEGORY with only 5 values, built-in search or standard WHERE clauses are more efficient. PRODUCT_NAME with 50,000+ values is ideal for Cortex Search integration.

</details>

<br/>

---

<br/>

4\. You're processing insurance claim forms that contain both typed text and handwritten notes, along with complex tables showing claim amounts by category. You need to extract all information while preserving the table structure for downstream analysis.  

Which approach should you use?  

A) PARSE_DOCUMENT with mode='OCR'  
B) PARSE_DOCUMENT with mode='LAYOUT'  
C) EXTRACT_ANSWER on the document text  
D) COMPLETE with multimodal input  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** LAYOUT mode is designed for complex documents with tables and preserves formatting. OCR only extracts text without structure. EXTRACT_ANSWER works on already-extracted text, and COMPLETE is for generation, not parsing.

</details>

<br/>

---

<br/>


5\. Your ML team fine-tuned a `mistral-7b` model for your customer service use case using 50,000 training examples with 5 epochs. You now need to deploy this model to your European subsidiary's Snowflake account in AWS EU-CENTRAL-1.  
What is the correct approach?  

A) Use CORTEX_ENABLED_CROSS_REGION to access the fine-tuned model  
B) Use database replication to share the fine-tuned model  
C) Re-run the fine-tuning job in the EU account  
D) Export the model and import it using Snowflake Model Registry  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Cross-region inference does not support fine-tuned models - you must use database replication. Option C would waste credits, and D is not the standard approach for fine-tuned Cortex models.

</details>

<br/>

---

<br/>

6\. You're building a classification pipeline for 100,000 customer feedback records. Each record should be classified into multiple categories simultaneously (e.g., a review might be both "Product Quality" and "Customer Service"). Your pipeline must not fail if the LLM produces unexpected output.  

Which function should you use?  

A) CLASSIFY_TEXT with default options   
B) AI_CLASSIFY with output_mode='multi'  
C) TRY_COMPLETE with structured output  
D) COMPLETE with custom prompt engineering  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** AI_CLASSIFY with output_mode='multi' is specifically designed for multi-label classification. CLASSIFY_TEXT doesn't support multi-label. TRY_COMPLETE could work but is less purpose-built. The question asks for classification specifically, making AI_CLASSIFY the best choice. Failure cases would be handled downstream. 

</details>

<br/>

---

<br/>

7\. You need to split 500-page technical manuals into chunks for a RAG system. The documents contain markdown formatting with headers, code blocks, and tables that should be preserved as logical boundaries.
Which function configuration is most appropriate?  
```sql
SELECT SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
    document_text,
    ?, -- format parameter
    ?, -- chunk_size
    ?  -- overlap
) FROM technical_docs;
```
A) 'none' with custom separators   
B) 'markdown' with no separators   
C) 'none' with no overlap    
D) 'markdown' with default separators    

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** The 'markdown' format specifically handles headers, code blocks, and tables as logical boundaries, which is perfect for technical documentation. Using 'none' would ignore these structural elements.

</details>

<br/>

---

<br/>

8\. Your semantic model for Cortex Analyst has grown to 2.5 MB and queries are returning errors. The model includes 15 tables with an average of 40 columns each, covering your entire data warehouse.    

What is the best optimization approach?  

A) Create separate semantic models by business domain     
B) Compress the YAML file before uploading      
C) Remove all descriptions to reduce file size    
D) Convert to semantic views instead of YAML files    

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** The 2 MB size limit requires breaking large models into domain-specific models. This is a best practice that also improves performance and accuracy. Compression won't work, removing descriptions hurts accuracy, and semantic views still have size considerations.

</details>

<br/>

---

<br/>

9\. You're implementing a customer support bot that needs to answer questions about your 10,000-page product documentation. Users ask questions like "What's the warranty policy for Product X?" The bot must cite specific page numbers and sections.   

Which architecture should you implement?   

A) Cortex Analyst with structured warranty data    
B) COMPLETE with the entire documentation as context    
C) Cortex Search with PARSE_DOCUMENT   
D) EXTRACT_ANSWER on concatenated documentation    

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** This is a RAG use case requiring Cortex Search for semantic search over unstructured documents. PARSE_DOCUMENT can extract content with page metadata. Analyst is for structured data, COMPLETE can't handle 10,000 pages in context, and EXTRACT_ANSWER doesn't provide semantic search.

</details>

<br/>

---

<br/>

10\. Your data science team is comparing vector similarity approaches for a recommendation engine. Your product embeddings are already normalized (unit length) and you're working in 768-dimensional space. Performance is critical.  

Which distance metric should you choose?  

A) VECTOR_INNER_PRODUCT    
B) VECTOR_COSINE_SIMILARITY    
C) VECTOR_L2_DISTANCE    
D) VECTOR_L1_DISTANCE    

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** For normalized vectors in high-dimensional space, cosine similarity is most appropriate as it measures angular distance. Inner product can over-index on magnitude (though less relevant when normalized). L1/L2 distances don't account for angular relationships and are magnitude-sensitive.

</details>

<br/>

---

<br/>

11\. You're building a production pipeline that processes 1 million rows daily, extracting sentiment scores. The pipeline must complete within a 2-hour SLA. Occasionally, some text contains malformed characters that cause parsing errors.  

Which function ensures your pipeline won't fail while maintaining performance?   

A) COMPLETE with error handling in application code  
B) TRY_COMPLETE  
C) SENTIMENT wrapped in TRY_CAST  
D) CLASSIFY_TEXT with sentiment categories    

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** TRY_COMPLETE returns NULL instead of erroring, allowing the pipeline to continue. SENTIMENT doesn't have a TRY_ variant. TRY_CAST won't help with LLM errors.

</details>

<br/>

---

<br/>

12\. Your Cortex Analyst semantic model needs to support queries like "Show me high-value customers in California who bought Product X last quarter." You have a 50 million row CUSTOMERS table and a 500 million row ORDERS table. Query performance is becoming an issue.  

How should you optimize the semantic model?  

A) Use COPY command to pre-aggregate data before defining tables  
B) Define filters for common criteria (high-value, California, last quarter)  
C) Create separate semantic models for customers and orders  
D) Use dynamic tables as base tables with incremental refresh  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Cortex Analyst semantic models support pre-defined filters that can significantly improve performance for common query patterns. Pre-aggregation (A) loses flexibility, separate models (C) prevent join queries, and dynamic tables (D) help with data freshness but don't optimize the semantic model itself.

</details>

<br/>

---

<br/>

13\. Your organization has strict compliance requirements: Data Science can use all models, Marketing can only use mistral-large2 and llama-3.1-70b, and Finance cannot use any LLMs. You've set CORTEX_MODELS_ALLOWLIST='None' at the account level.  

What's the correct RBAC configuration sequence?  

A) Grant CORTEX-MODEL-ROLE-ALL to Data Science, individual model roles to Marketing, nothing to Finance  
B) Grant CORTEX_USER to Data Science, CORTEX_EMBED_USER to Marketing, nothing to Finance  
C) Create custom roles with model-specific grants for each department  
D) Use network policies to restrict model access by department  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** With allowlist set to 'None', RBAC takes full control. CORTEX-MODEL-ROLE-ALL grants access to all models, individual model application roles grant specific access, and not granting any model roles blocks access. Database roles like CORTEX_USER control feature access, not model selection.  
Note that is an application role: `GRANT APPLICATION ROLE SNOWFLAKE."CORTEX-MODEL-ROLE-ALL" TO ROLE MY_ROLE;`

</details>

<br/>

---

<br/>

14\. After configuring model RBAC, users in the ANALYST role report they cannot use claude-4-sonnet despite being granted the correct application role. You verify:  
- CORTEX_MODELS_ALLOWLIST is set to 'None'  
- CORTEX-MODEL-ROLE-CLAUDE4-SONNET is granted to ANALYST  
- Users have CORTEX_USER database role  
- The model is available in your region  

What is the most likely issue?

A) Secondary roles are obscuring permissions   
B) Model names in grants are case-sensitive and may be quoted  
C) CORTEX_BASE_MODELS_REFRESH was not called  
D) Cross-region inference is not enabled  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** After setting RBAC mode, you must call CORTEX_BASE_MODELS_REFRESH() to populate the SNOWFLAKE.MODELS schema with available models. This is a critical step often missed during setup.  

</details>

<br/>

---

<br/>

15\. Your security team requires all LLM responses to be scanned for potential safety issues. You're using COMPLETE in a production application processing user-generated content. Occasionally, the system needs to refuse unsafe requests.  

How should you implement guardrails?  

A) Add pre-processing logic to filter prompts before calling COMPLETE  
B) Use TRY_COMPLETE and check for NULL responses  
C) Pass 'guardrails': true in the COMPLETE options parameter  
D) Implement custom content filtering in application code  


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** Cortex Guard is built-in when you pass 'guardrails': true to COMPLETE or TRY_COMPLETE. This provides native safety checking. Note it doesn't work with fine-tuned or purpose-built models.

</details>

<br/>

---

<br/>


16\. Your CFO wants to understand daily AI service costs broken down by service type (Cortex Functions vs Cortex Analyst vs Document AI) for the last 3 months. The query must show costs per service per day.   

Which view should you query?  

A) CORTEX_FUNCTIONS_USAGE_HISTORY  
B) METERING_DAILY_HISTORY with SERVICE_TYPE filter  
C) CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY  
D) QUERY_HISTORY with cost analysis  


<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** METERING_DAILY_HISTORY provides daily aggregated costs by service type (`WHERE SERVICE_TYPE = 'AI_SERVICES'`), with up to 1 year retention. CORTEX_FUNCTIONS_USAGE_HISTORY is hourly (not daily) and only covers functions. QUERY_USAGE_HISTORY has query-level detail (too granular), and QUERY_HISTORY doesn't break out AI costs specifically.

</details>

<br/>

---

<br/>

17\. You need to audit which specific queries used which models and how many tokens each consumed, including input/output token breakdown, for the last 6 months. Compliance requires query-level detail.  

Which view provides this information?  

A) CORTEX_FUNCTIONS_USAGE_HISTORY   
B) CORTEX_AISQL_USAGE_HISTORY   
C) CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY  
D) METERING_DAILY_HISTORY  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** CORTEX_AISQL_USAGE_HISTORY provides input/output token-level details. CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY provides query-level detail but doesn't break down input/output tokens. The other views are too aggregated.

</details>

<br/>

---

<br/>

18\. Your Cortex Search service indexes 100 GB of customer support transcripts and is configured with TARGET_LAG='15 minutes' on a LARGE warehouse. Monthly costs are higher than expected.  

Which optimization would most reduce serving compute costs?  

A) Change TARGET_LAG to '1 day'  
B) Reduce warehouse size to SMALL  
C) Bundle changes to minimize re-indexing  
D) Suspend serving when not needed (off-hours) 

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** **Serving compute** (multi-tenant serving) is charged by GB/month of indexed data. Suspending serving when not needed directly reduces these charges. TARGET_LAG affects indexing costs, warehouse size affects indexing costs, and bundling changes affects indexing frequency - but the question specifically asks about serving compute costs.

</details>

<br/>

---

<br/>

19\. Your finance team needs to process 10,000 invoice PDFs monthly, extracting vendor names, amounts, dates, and line items. The invoices come from 50+ vendors with different formats. Business users (not developers) will define what to extract, and the system must handle new invoice formats without code changes.  

What's the correct approach?  

A) Use PARSE_DOCUMENT with LAYOUT mode and custom SQL parsing  
B) Create a Document AI model build in the UI, then use <model_build_name>!PREDICT  
C) Use AI_EXTRACT with few-shot examples  
D) Use EXTRACT_ANSWER with template questions  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:**  Document AI is specifically designed for this scenario: business users create and fine-tune models in a UI, then data engineers use the model in SQL pipelines. It handles multiple formats and is continuously trainable without code. PARSE_DOCUMENT requires custom logic, AI_EXTRACT isn't purpose-built for documents, and EXTRACT_ANSWER lacks the template/training features.

</details>

<br/>

---

<br/>

20\. You've created a Document AI model build called **invoices** in schema `finance_db.doc_ai`. You need to process all PDFs in stage `@invoice_stage` and extract data. The role **invoice_processor** will run this in production.  

Which privileges must be granted?   

A) Only USAGE on the database and schema   
B) USAGE on database and schema, and the model   
C) DOCUMENT_INTELLIGENCE_CREATOR role only   
D) USAGE on database, schema, and warehouse; model access automatically inherited   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:**  To run inference using !PREDICT, you need USAGE on the database and schema, plus USAGE privilege on the model build. DOCUMENT_INTELLIGENCE_CREATOR is for creating models, not running inference. Warehouse privileges are also needed but B is more complete than D.

</details>

<br/>

---

<br/>


21\. Your Document AI model build is returning low-accuracy results for extracting "Total Amount" from invoices (60% accuracy). The field is clearly visible in all documents and has consistent formatting.   

What should you do first?   

A) Increase the number of training documents  
B) Fine-tune the model in the Document AI UI  
C) Switch to a different LLM model in Cortex  
D) Use PARSE_DOCUMENT instead  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:**  Document AI provides a fine-tuning interface in the UI specifically for improving accuracy when the base Arctic-TILT model is insufficient. This is the designed workflow. Adding more training docs helps but fine-tuning is more direct. You can't change the base model in Document AI, and switching to PARSE_DOCUMENT loses the trained extraction capability.

</details>

<br/>

---

<br/>

22\. You're building a production pipeline that processes 1,000 multi-page legal contracts daily using Document AI. Each contract is 20-50 pages. You need to track which specific pages contain key clauses for audit purposes.  

How should you structure your Document AI queries?  

A) Process entire documents and parse results for page references  
B) Use PARSE_DOCUMENT with page_split=TRUE then process with a Document AI pipeline  
C) Create a Document AI model and use in a processing pipeline  
D) Use Document AI's built-in page tracking features  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:**  PARSE_DOCUMENT with page_split=TRUE creates separate content blocks per page with index metadata and can preserve formatting with "LAYOUT" mode, however Document AI itself processes files holistically, so splitting with PARSE_DOCUMENT is not needed. 

</details>

<br/>

---

<br/>

23\. You're building an executive dashboard that answers questions like "Which product category had the highest growth last quarter?" (structured) and "What are customers saying about Product X?" (unstructured from support tickets). The system should handle multi-turn conversations and automatically choose the right data source.  

What architecture components do you need?  

A) Cortex Analyst + Cortex Search  
B) Cortex Agents + Cortex Analyst tool + Cortex Search tool  
C) COMPLETE with RAG + semantic model queries  
D) Cortex Analyst  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: D**  
**Explination:**  Cortex Agents orchestrate across multiple tools and handle multi-turn conversations. You configure it with a Cortex Analyst tool (semantic view) for structured queries and a Cortex Search tool for unstructured search. This provides unified orchestration. Option A lacks orchestration, C lacks the tooling framework, D only would work for structured data.

</details>

<br/>

---

<br/>

24\. Your semantic model includes a PRODUCTS dimension with 500,000 product names. Users frequently ask questions like "Show sales for iPhone 14 Pro Max" but might type "iphone 14 pro" or "iPhone14ProMax". Standard equality matching fails frequently.  

How should you enhance the semantic model?   

A) Add all possible variations as synonyms   
B) Integrate a Cortex Search service on the product_name field   
C) Use CLASSIFY_TEXT to normalize product names  
D) Add custom_instructions to handle variations  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:**  This is exactly the use case for Cortex Search integration in semantic models. It provides fuzzy matching and semantic understanding of product names. Synonyms don't scale to 500K products with variations, CLASSIFY_TEXT isn't designed for this, and custom_instructions won't solve the matching problem.

</details>

<br/>

---

<br/>


25\. You're implementing AI observability for a RAG application using TrueLens. Your evaluation shows: Context Relevance: 95%, Groundedness: 65%, Answer Relevance: 90%. Users report the system sometimes provides confident answers that aren't supported by your documents.  

Which metric identifies this issue and what should you improve?  

A) Context Relevance - improve your embedding model  
B) Groundedness - improve retrieved context or system prompt  
C) Answer Relevance - improve question understanding  
D) Add Coherence metric - improve response formatting  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Groundedness measures whether responses are supported by retrieved context. A 65% score indicates the LLM is hallucinating or adding information not in the retrieved documents. You need to either retrieve better context or adjust prompts to stick closer to source material. Context Relevance (95%) shows retrieval is working, and Answer Relevance (90%) shows the system understands questions.

</details>

<br/>

---

<br/>

26\. Your compliance team requires logging every Cortex Analyst query, the generated SQL, and user information for 7 years. You need query-level detail including the semantic model used.  

What's the correct logging strategy?  

A) Query CORTEX_ANALYST_USAGE_HISTORY and archive to long-term storage  
B) Use SNOWFLAKE.LOCAL.CORTEX_ANALYST_REQUESTS table function and persist results  
C) Enable QUERY_HISTORY and filter for Cortex Analyst calls  
D) Create custom logging with event tables  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** `CORTEX_ANALYST_REQUESTS` provides detailed logs per semantic view/model including query-level details. `CORTEX_ANALYST_USAGE_HISTORY` is aggregated hourly (not query-level), and has user, # requests, and credits info.

</details>

<br/>

---

<br/>

27\. You're deploying a custom LLM not available in Cortex using Snowpark Container Services. The model requires GPU acceleration and needs to serve predictions via REST API. Your Python application uses the `transformers` library.

What must you include in your Docker configuration?
```dockerfile
FROM nvidia/cuda:11.8.0-base-ubuntu22.04
# What's missing?
COPY app.py /app/
CMD ["python", "/app/app.py"]
```
A) Install Python only  
B) Install Python and transformers (via pip install)  
C) Install Python, transformers, and configure GPU drivers  
D) Nothing - Snowflake handles dependency installation  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** You must install all dependencies (Python runtime and libraries like transformers) in your Dockerfile. The base CUDA image provides GPU support, so you don't need additional GPU driver configuration. Snowflake doesn't automatically install dependencies - that's the container's responsibility.

</details>

<br/>

---

<br/>

28\. Your fine-tuned `mistral-7b` model took 45 minutes to train on 10,000 examples with 3 epochs. You now need to train on 100,000 examples with 5 epochs while staying under the row limit.   

What do you need to verify?    
 
A) 100,000 × 5 < epoch limit for mistral-7b  
B) 10,000 < (epoch limit for mistral-7b / 5)  
C) Total trained tokens < account quota   
D) Warehouse size is sufficient for larger dataset   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** The effective row limit formula is: "1 epoch limit for base model / number of epochs trained". So if the 1-epoch limit is 200,000 rows, training 5 epochs allows only 40,000 rows (200,000/5). You need to verify 100,000 < the calculated limit.

</details>

<br/>

---

<br/>

29\. You're building a real-time customer service bot that needs to: (1) Search knowledge base (Cortex Search), (2) Query customer data (Cortex Analyst), (3) Generate personalized response (COMPLETE). The workflow must adapt based on intermediate results.  

Which service orchestrates this workflow?  

A) Cortex Agents with multiple tools    
B) Cortex Analyst with custom instructions  
C) Snowflake Tasks with sequential dependencies  
D) Custom application using REST APIs  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** Cortex Agents handle planning, tool use, and reflection - perfect for adaptive multi-step workflows. They can orchestrate Cortex Search and Cortex Analyst as tools, then use COMPLETE for generation. Analyst can't orchestrate other services, Tasks aren't for real-time interaction, and custom apps work but lack the built-in orchestration intelligence.

</details>

<br/>

---

<br/>


30\. Your Cortex Search service processes 50,000 new documents daily. Indexing runs on a LARGE warehouse, costs are high, and you have a 1-hour TARGET_LAG. Documents arrive continuously throughout the day.  

Which changes would reduce costs without impacting freshness?  

A) Reduce warehouse to MEDIUM  
B) Increase TARGET_LAG to 4 hours  
C) Bundle document inserts into hourly batches  
D) All of the above   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** increasing lag will impact freshnes, and bundling documents hourly still may affect freshness after indexing. Warehouse size has minimal impact on index building speed.  

</details>

<br/>

---

<br/>

31\. You're analyzing token usage for 1 million COMPLETE calls. You find that 70% of tokens are in prompts and only 30% in completions. Each prompt includes a 5,000-token system message that rarely changes.  

How can you optimize costs?  

A) Reduce max_tokens parameter   
B) Use a smaller model   
C) Use the Cortex REST API and OpenAI or Anthropic models
D) Use TRY_COMPLETE instead   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** The Cortex REST API supports prompt caching when used with OpenAI models and Anthropic models. Shortening the system prompt could also be an option or using RAG for a more dynamic context.

</details>

<br/>

---

<br/>


32\. Your Cortex Analyst queries execute in 30 seconds on average using a SMALL warehouse. You're charged for both token usage and warehouse compute time. Most queries scan the entire 100 million row fact table.  

What optimization reduces costs most?  

A) Use a larger warehouse to reduce execution time  
B) Add filters to the semantic model for common query patterns  
C) Reduce the number of metrics in the semantic model  
D) Switch to a XSMALL warehouse  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Pre-defined filters in the semantic model help Cortex Analyst generate more efficient SQL with WHERE clauses, reducing data scanned and warehouse execution time. This addresses both token costs (more efficient queries) and warehouse costs (faster execution). A larger warehouse increases costs, removing metrics loses functionality, and a smaller warehouse might increase execution time.

</details>

<br/>

---

<br/>

33\. You need to build a system where users upload images of damaged products, the system extracts product details and damage description, checks warranty status in your database, and generates a response. All processing must stay in Snowflake.  

What's the complete architecture?  

A) COMPLETE with multimodal input → Cortex Analyst → COMPLETE  
B) AI_EXTRACT from image → Cortex Search → COMPLETE  
C) PARSE_DOCUMENT → SQL query → COMPLETE  
D) COMPLETE with image input → SQL query → COMPLETE  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: C**  
**Explination:** COMPLETE supports multimodal input (images), so you can extract product/damage info from the image. Then use standard SQL to check warranty (structured data doesn't need Cortex Analyst for simple lookups). Finally, COMPLETE generates the response. This is simpler than involving Cortex Search or multiple AI services for what's essentially image analysis → lookup → generation.

</details>

<br/>

---

<br/>

34\. Your data science team wants to experiment with different embedding models for your RAG system without rebuilding the entire search index each time. You currently use `snowflake-arctic-embed-m-v1.5` (768 dimensions).  
  
What consideration is critical?    

A) All models must use the same dimension size (768)  
B) You must recreate the Cortex Search service for each model  
C) Vector similarity metrics must match the model  
D) Both A and B   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** VECTOR columns have fixed dimensions (e.g., VECTOR(FLOAT, 768)). Switching to a model with different dimensions (e.g., embed-1024) requires schema changes and reindexing. Additionally, Cortex Search services are configured with a specific EMBEDDING_MODEL, so changing models requires recreating the service.

</details>

<br/>

---

<br/>


35\. A user reports: "I granted myself the `CORTEX-MODEL-ROLE-LLAMA3.1-70B` application role but COMPLETE still says 'model not available'." You verify:  
- Model is available in the region  
- CORTEX_MODELS_ALLOWLIST = 'None'  
- User has CORTEX_USER role  
- The models have been refreshed with `CALL CORTEX_BASE_MODELS_REFRESH();`
- User's query: `SELECT SNOWFLAKE.CORTEX.COMPLETE("llama-3.1-70b", 'test')`  

What's wrong?  

A) The model does not exist 
B) Model name is quoted and case-sensitive, should be 'llama-3.1-70b'  
C) RBAC issues  
D) Cross-region inference must be enabled  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** This is a common pitfall: model names are case-sensitive when quoted. The application role uses uppercase in its name, but the actual model identifier is lowercase. Should use 'llama-3.1-70b' (lowercase, single quotes for string).

</details>

<br/>

---

<br/>

36\. Your Document AI model build fails during inference with error: "Unable to access file." Your query:  
```sql
SELECT invoices!PREDICT(
    '@invoice_stage/jan/invoice.pdf'
) FROM documents;
```

The file exists and you can SELECT from the stage. What's wrong?   

A) Document AI requires PRESIGNED_URL from GET_PRESIGNED_URL   
B) Need to use TO_FILE function   
C) Path should be relative, not absolute   
D) Missing schema qualification on the model name   

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** Document AI's !PREDICT method requires GET_PRESIGNED_URL to create a presigned URL for the file, not just the stage path. Correct syntax: `GET_PRESIGNED_URL(@invoice_stage, 'jan/invoice.pdf')`.

</details>

<br/>

---

<br/>

37\. Your Cortex Search service shows 0 credits used for serving compute despite active queries returning results. Indexing charges are normal.  

What's the likely explanation?  

A) Serving compute is billed monthly, not visible yet  
B) Queries are using cached results  
C) Service is in SUSPENDED state  
D) This is a bug - contact Snowflake support  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: A**  
**Explination:** Serving compute is charged per GB/month of indexed data, not per query. It appears as a monthly charge based on the size of your indexed data and how long the service is active, not based on query volume. The service is clearly active since queries work.

</details>

<br/>

---

<br/>

38\. You're using Cortex COMPLETE in production. Users report conversations lose context. You're using the REST API.  

What's missing?  

A) Enable conversation history configuration  
B) Pass history through the messages array  
C) Increase the context window size in the settings  
D) Store conversation history in a separate table  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Complete uses messages to pass history of interactions.

</details>

<br/>

---

<br/>


39\. Your organization processes medical records containing PHI (Protected Health Information). You need to extract patient data using COMPLETE, but security requires that no data leaves your Snowflake environment.  

What assurance does Snowflake provide?  

A) Data is encrypted in transit to external LLM providers  
B) Data stays within Snowflake's security boundary and is not shared between customers  
C) You must use BYOM with SPCS to ensure data doesn't leave  
D) Enable guardrails to prevent PHI from being processed  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** Snowflake Cortex LLMs run within Snowflake's security boundary. Data is not shared between customers and does not leave Snowflake for external processing. BYOM with SPCS is also considered "customer data" within Snowflake but isn't necessary for data isolation. Guardrails are for content safety, not data residency.

</details>

<br/>

---

<br/>


40\. You have a SALES table with a DATE_TIME column (timestamp). Users ask questions like "sales last month", "this quarter", "last year". You need to optimize for these temporal queries.  

What's the correct semantic model configuration?  

A) Add DATE_TIME as a dimension  
B) Add DATE_TIME as a time_dimension  
C) Create multiple dimensions for month, quarter, year  
D) Use filters for common date ranges  

<details>
  <summary>Click to expand/collapse answers</summary>

**Answer: B**  
**Explination:** The semantic model has a specific time_dimensions section for temporal columns. This tells Cortex Analyst that the column has special temporal semantics and should handle natural language date expressions. While filters could help (D), time_dimensions is the purpose-built feature for this.

</details>

<br/>

---

<br/>

