# Practice Test 1 (Easy)
(See anser key at bottom)  
*Questions were AI generated but corrected by me*  

<br/>  

1. Which Snowflake feature is designed to orchestrate multi-step workflows that can reason, invoke tools, and iterate over structured and unstructured data?    
    A. Cortex Analyst  
    B. Cortex Search   
    C. Cortex Agents  
    D. Cortex LLM Playground  

2. Which Snowflake Cortex capability is best suited for RAG over high-cardinality unstructured text?  
    A. AI_SUMMARIZE  
    B. Cortex Analyst  
    C. Cortex Search   
    D. AI_EXTRACT  

3. Where should semantic model YAML files be stored when using Cortex Analyst with stages?  
    A. In Snowflake Model Registry  
    B. In a user stage or named internal stage  
    C. In the SNOWFLAKE.CORTEX schema  
    D. In a Snowpark Container image  

4. Which VECTOR data type declaration is valid in Snowflake?  
    A. VECTOR(256)  
    B. VECTOR(FLOAT, 256)  
    C. VECTOR(INT, -1)  
    D. VECTOR(NUMBER, 1024)  

5. Which interaction methods are supported for Snowflake Cortex features?    
    A. SQL  
    B. REST API  
    C. UI  
    D. All of the above  

6. What is required to enable cross-region inference for Cortex models?  
    A. GRANT CORTEX_CROSS_REGION  
    B. ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION   
    C. Enable database replication   
    D. Enable Snowpark Container Services  

7. Which function should be used when an LLM call must never fail and should return NULL on error?  
    A. COMPLETE   
    B. AI_COMPLETE   
    C. TRY_COMPLETE  
    D. EXTRACT_ANSWER  

8. Which Snowflake Cortex function is task-specific and returns a numeric score between -1 and 1?   
    A. SUMMARIZE   
    B. SENTIMENT  
    C. CLASSIFY_TEXT  
    D. COMPLETE  

9. Which function is best suited for extracting table structure from a PDF?  
    A. PARSE_DOCUMENT with OCR  
    B. PARSE_DOCUMENT with LAYOUT  
    C. EXTRACT_ANSWER  
    D. AI_EXTRACT  
 
10. Which requirement must be met for fine-tuning a Cortex model?
    A. USAGE privilege on warehouse only
    B. CREATE MODEL privilege on schema
    C. ACCOUNTADMIN role
    D. OWNERSHIP on database

11. Which column names are required in the training query for fine-tuning?
    A. input, output
    B. text, label
    C. prompt, completion
    D. question, answer

12. Which statement about fine-tuned models is true?   
    A. They support cross-region inference  
    B. They continue working if the base model is removed  
    C. USAGE on model is required for inference  
    D. They are free to run after training  

13. Which vector function is best when vector magnitude should not affect similarity?    
    A. VECTOR_INNER_PRODUCT  
    B. VECTOR_L1_DISTANCE  
    C. VECTOR_L2_DISTANCE  
    D. VECTOR_COSINE_SIMILARITY  

14. Which embedding model produces 1024-dimension vectors?  
    A. snowflake-arctic-embed-m-v1.5
    B. e5-base-v2
    C. snowflake-arctic-embed-l-v2.0
    D. BERT

15. Which use case is best suited for Cortex Analyst instead of a custom API?  
    A. Image captioning
    B. Free-form creative writing
    C. Natural language questions on structured data
    D. Custom fine-tuned inference

16. Which parameter restricts which LLMs are available across an entire Snowflake account?   
    A. ENABLE_CORTEX_ANALYST  
    B. CORTEX_MODELS_ALLOWLIST  
    C. CORTEX_ENABLED_CROSS_REGION  
    D. AI_SERVICES_QUOTA  

17. What is the correct authorization order when Cortex checks model access?   
    A. Allowlist → Region → RBAC Privileges   
    B. RBAC Privileges → Allowlist → Region   
    C. SNOWFLAKE.MODELS → RBAC Privileges → Allowlist   
    D. Allowlist → RBAC Privileges → SNOWFLAKE.MODELS   

18. Which database role is granted to PUBLIC by default and enables most Cortex AI Functions?  
    A. SNOWFLAKE.CORTEX_AGENT_USER  
    B. SNOWFLAKE.COPILOT_USER  
    C. SNOWFLAKE.CORTEX_USER  
    D. SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR  

19. Which metadata view provides hourly aggregated Cortex function usage without query-level detail?  
    A. CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY  
    B. CORTEX_FUNCTIONS_USAGE_HISTORY  
    C. METERING_DAILY_HISTORY  
    D. QUERY_HISTORY  

20. Which guardrail behavior is correct?  
    A. Guardrails work with fine-tuned models
    B. Guardrails require Cortex Analyst
    C. Guardrails can be enabled via COMPLETE options
    D. Guardrails only apply in REST APIs
*double check if fine-tuned models can have guardrails* 

21. Which AI Observability metric measures whether responses are supported by retrieved context?   
    A. Accuracy  
    B. Latency  
    C. Groundedness  
    D. Coherence  

22. Which privilege is required to create a Document AI model build?  
    A. CREATE MODEL on account  
    B. CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE on schema  
    C. CORTEX_USER database role  
    D. OWNERSHIP on warehouse  

23. Which function is used to extract structured values from documents using a published Document AI model?  
    A. AI_EXTRACT
    B. PARSE_DOCUMENT
    C. <model_build_name>!PREDICT
    D. COMPLETE

24. What is the maximum number of documents that can be processed in a single Document AI query?  
A. 1000
B. 500
C. 1,00
D. 5,000


# Answer Key

<details>
  <summary>Click to expand/collapse answers</summary>

1. A
2. C
3. B
4. B
5. D
6. B
7. C
8. B
9. B
10. B
11. C
12. C
13. D
14. C
15. C
16. B
17. C
18. C
19. B
20. C
21. C
22. B
23. C
24. A


</details>