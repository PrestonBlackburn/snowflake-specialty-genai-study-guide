# Practice Test 2
(See anser key at bottom)  
*Questions were AI generated but corrected by me*  

<br/>

1\. Your team is building a multi-turn analytics assistant for finance users. The assistant must:   
- Answer questions over structured Snowflake tables  
- Support conversation history  
- Allow domain-specific terminology  
- Generate explainable SQL  
- Minimize latency and operational complexity   

Which approach best satisfies these requirements?  

A. Use SNOWFLAKE.CORTEX.COMPLETE directly on tables  
B. Use Cortex Analyst with a semantic model and verified queries  
C. Build a custom RAG pipeline with Cortex Search and embeddings  
D. Deploy a custom LLM using Snowpark Container Services  


---
2\. A product team wants to build a RAG system over customer support transcripts. Key requirements:  
- Over millions of documents  
- Queries frequently reference rare terms  
- Index refresh can tolerate some delay  
- Cost control is critical  

Which architecture is most appropriate?

A. Cortex Analyst semantic model with dimensions  
B. Built-in SQL LIKE search  
C. Cortex Search with a long TARGET_LAG and suspended serving when idle  
D. COMPLETE with chunked prompts  

---

3\. A team wants to use both structured data and unstructured PDFs in a single conversational workflow where the model can decide when to:  
- Query tables  
- Retrieve documents  
- Ask follow-up questions  

Which Snowflake capability is specifically designed for this orchestration?  

A. Cortex Analyst  
B. Cortex Agents  
C. Cortex Search  
D. AI_EXTRACT  

---

4. A scheduled production task:  
- Uses an LLM to generate structured JSON output  
- Writes results into a downstream table  
- Must never fail, even if the model produces invalid output   
- Should allow downstream rows to be NULL when generation fails    

Which function should be used for the task?  

A. COMPLETE  
B. AI_COMPLETE  
C. TRY_COMPLETE  
D. EXTRACT_ANSWER  

---

5. A developer uses VECTOR_INNER_PRODUCT for similarity search and notices that:  
- Results seem biased toward “popular” content  

Which change would most directly address this issue?  
 
A. Switch to VECTOR_L2_DISTANCE  
B. Normalize text before embedding  
C. Use VECTOR_COSINE_SIMILARITY  
D. Increase embedding dimension  

---

6. You are parsing invoices that include:  
- Tables with line items  
- Mixed scanned and digital text  
- Important spatial alignment  

Which configuration yields the most accurate extraction?  

A. PARSE_DOCUMENT with OCR  
B. PARSE_DOCUMENT with LAYOUT  
C. EXTRACT_ANSWER over raw text  
D. COMPLETE with a prompt  

---
7. A team fine-tunes a Mistral model and later enables cross-region inference for additional base models. The fine-tuned model stops working in the new region.  

Why?  

A. Fine-tuned models do not support cross-region inference  
B. Fine-tuned models require ACCOUNTADMIN  
C. The model registry does not replicate automatically  
D. The training dataset exceeded token limits  

---

8. A fine-tuning job fails because too many rows were supplied. The team trained for 4 epochs.  

Which adjustment would allow more rows to be used?  

A. Switch to a larger warehouse  
B. Reduce number of epochs  
C. Enable cross-region inference  
D. Use TRY_COMPLETE  

---

9. A security team wants:  
- Cortex disabled by default  
- Only explicitly approved roles to use LLMs  
- No reliance on account-level allowlists  

Which approach satisfies this?  

A. Set CORTEX_MODELS_ALLOWLIST = 'All'  
B. Use session-level allowlists   
C. Set CORTEX_MODELS_ALLOWLIST = 'None' and grant application roles  
D. Revoke USAGE on SNOWFLAKE.CORTEX schema  

---

10. A user has:  
- Access to a Cortex model via RBAC  
- The SNOWFLAKE.CORTEX_USER database role  
- Correct SQL syntax  

But still receives “model not available” errors.  

What is the most likely cause?  

A. Secondary roles are disabled  
B. Model is not available in the account’s region   
C. Warehouse is too small  
D. Guardrails are enabled  

---

11. An admin grants access to a Cortex model but uses quoted identifiers:  
```sql
GRANT APPLICATION ROLE SNOWFLAKE."cortex-model-role-llama3.1-70b" TO ROLE analyst;
```
Access fails. Why?  

A. Application roles cannot be granted to user roles  
B. Model roles require ACCOUNTADMIN  
C. Model role names are case-sensitive when quoted  
D. The model is deprecated  

12. A team wants to monitor daily Cortex Search costs, broken down by:  
- Serving  
- Embedding usage  

Which view(s) should be queried?  

A. METERING_DAILY_HISTORY   
B. CORTEX_SEARCH_DAILY_USAGE_HISTORY  
C. CORTEX_SEARCH_SERVING_USAGE_HISTORY  
D. QUERY_HISTORY  

---

13. Which action reduces Cortex Search cost without affecting result quality?  

A. Increasing warehouse size  
B. Reducing embedding dimensions  
C. Increasing TARGET_LAG   
D. Disabling primary keys  

---

14. A team wants to evaluate whether RAG responses are:  
- Based on retrieved context  
- Not hallucinated   

Which observability components are required?  

A. Logging  
B. Groundedness metrics  
C. Event tables  
D. Accuracy metrics  

---

15. A Document AI pipeline fails with:

"File extension does not match actual mime type. Mime-Type: application/octet-stream"
"cannot identify image file <_io.BytesIO object at 0x7f8a800ba020>"  

Which fix is most appropriate?  

A. Convert files to PDF  
B. Enable OCR mode  
C. Ensure the stage uses SNOWFLAKE_SSE encryption  
D. Increase warehouse size  


16. What is the maximum number of examples that can be provided to CLASSIFY_TEXT?  
A. 5   
B. 10  
C. 20   
D. Unlimited   

---


# Answer Key

<details>
  <summary>Click to expand/collapse answers</summary>

1. B
2. C
3. B
4. C
5. C
6. B
7. A
8. B
9. C
10. B
11. C
12. B
13. C
14. B
15. C
16. C

</details>