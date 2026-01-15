# Practice Test 3 (Syntax)
(See anser key at bottom)  
*Questions were AI generated but corrected by me*  

### Section 2

1\. Which statement correctly invokes a basic LLM completion using Snowflake Cortex? Assume the user's session is the `DEMO` database and `PRACTICE` schema.    

A. `SELECT COMPLETE('openai-gpt-4.1', 'Hello world');`  
B. `SELECT SNOWFLAKE.CORTEX.COMPLETE('openai-gpt-4.1', 'Hello world');`  
C. `SELECT SNOWFLAKE.COMPLETE('openai-gpt-4.1', 'Hello world');`  
D. `CALL SNOWFLAKE.CORTEX.COMPLETE('openai-gpt-4.1', 'Hello world');`  

---

<br/>

2\. Which option block is valid when calling SNOWFLAKE.CORTEX.COMPLETE?  
A. `{'temperature':0.7,'top_k': 0.6}`  
B. `{'temp':0.7,'max_tokens':10}`  
C. `{'temperature':0.7,'max_tokens':10}`  
D. `('temperature'=0.7,'max_tokens'=10)`  

---

<br/>

3\. Which syntax correctly creates a file object from a stage for image input?  
A. `FILE('@myimages/highest-inflation.png')`  
B. `LOAD_FILE('@myimages','highest-inflation.png')`  
C. `TO_FILE('@myimages','highest-inflation.png')`  
D. `STAGE_FILE('@myimages/highest-inflation.png')`  

---

<br/>

4\. Which example correctly uses a PROMPT object with an embedded image reference?  
A. `PROMPT('Classify image {0}', TO_FILE('@myimages', img_path))`   
B. `PROMPT('Classify image','@myimages/img.png')`
C. `PROMPT('Classify image', FILE('@myimages', img_path))`  
D. `PROMPT_OBJECT('Classify image {img}','@myimages/img.png')`  

---

<br/>

5\. Which function returns a sentiment score between -1 and 1?  
A. `SNOWFLAKE.CORTEX.CLASSIFY_TEXT`  
B. `SNOWFLAKE.CORTEX.EXTRACT_ANSWER`  
C. `SNOWFLAKE.CORTEX.SUMMARIZE`  
D. `SNOWFLAKE.CORTEX.SENTIMENT`     

---

<br/>

6\. Which syntax correctly passes a chat-style prompt history into `SNOWFLAKE.CORTEX.COMPLETE`?  
A. 
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-4-sonnet',
  {'role':'user','content':'Explain snowflakes'}
);
```
B. 
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-4-sonnet',
  [
    {'role':'user','content':'Explain snowflakes'}
  ]
);
```
C. 
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-4-sonnet',
  ARRAY('role', 'user', 'content', 'Explain snowflakes')
);
```
D. 
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-4-sonnet',
  PROMPT('role: user, content: Explain snowflakes')
);
```

---

<br/>

7\. Which is the incorrect usage for CLASSIFY_TEXT?  
A. `SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT('One day I will see the world');`   
B. 
```sql
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
  'One day I will see the world',
  ['travel', 'cooking'],
  {
    'task_description': 'Return a classification of the Hobby identified in the text'
  }
);
```
C. 
```sql
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
  'I love running every morning before the world wakes up',
  [{
    'label': 'travel',
    'description': 'Hobbies related to going from one place to another',
    'examples': ['I like flying to Europe']
  },{
    'label': 'cooking',
    'examples': ['I like learning about new ingredients', 'You must bring your soul to the recipe' , 'Baking is my therapy']
    },{
    'label': 'fitness',
    'description': 'Hobbies related to being active and healthy'
    }],
  {'task_description': 'Return a classification of the Hobby identified in the text'}) 
```
D. `SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT('One day I will see the world', ['travel', 'cooking']);` 

---

<br/>

8\. Which option enables page-level splitting in `PARSE_DOCUMENT`?  
A. `{'split_pages':true}`  
B. `{'page_split':true}`  
C. `{'pages':true}`  
D. `{'mode':'PAGES'}`   

---

<br/>

9\. Which function produces a 768-dimension vector?  
A. `EMBED_TEXT('snowflake-arctic-embed-m-v1.5', text)`  
B. `EMBED_TEXT_768('snowflake-arctic-embed-m-v1.5', text)`  
C. `EMBED_TEXT_768('snowflake-arctic-embed-l-v2', text)`  
D. `ECTOR_EMBED_768('snowflake-arctic-embed-m-v1.5', text)`  

---

<br/>


10\. Which statement correctly describes a fine-tuning job?  
A. `SELECT FINETUNE.DESCRIBE('<job_id>');`  
B. `DESCRIBE MODEL '<job_id>';`  
C. `CALL SNOWFLAKE.CORTEX.DESCRIBE_FINETUNE('<job_id>');`   
D. `SELECT SNOWFLAKE.CORTEX.FINETUNE('DESCRIBE','<job_id>');`  

---

<br/>

11\. Which statement disables the account-level allowlist so that RBAC-only controls are enforced?  
A. `ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'None';`    
B. `ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'ALL';`  
C. `ALTER ACCOUNT UNSET CORTEX_MODELS_ALLOWLIST;`   
D. `ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = FALSE;`  

---

<br/>

12\. Which command refreshes the list of available base models?  
A. `REFRESH MODELS;`    
B. `CALL SNOWFLAKE.CORTEX.BASE_MODELS_REFRESH();`  
C. `CALL SNOWFLAKE.MODELS.CORTEX_BASE_MODELS_REFRESH();`   
D. `ALTER ACCOUNT REFRESH MODELS;`   

---

<br/>

13\. Which statement lists model objects registered in SNOWFLAKE.MODELS?  
A. `SHOW CORTEX MODELS;`    
B. `SHOW MODELS;`  
C. `SHOW MODELS IN DATABASE SNOWFLAKE;`   
D. `SHOW MODELS IN SNOWFLAKE.MODELS;`   

---

<br/>

14\. Which statement correctly grants access to a specific Cortex model?  
A. `GRANT ROLE SNOWFLAKE.CORTEX_MODEL_LLAMA3 TO ROLE my_role;`    
B. `GRANT DATABASE ROLE SNOWFLAKE.CORTEX_MODEL_LLAMA3 TO ROLE my_role;`   
C. `GRANT APPLICATION ROLE SNOWFLAKE."CORTEX-MODEL-ROLE-LLAMA3.1-70B" TO ROLE my_role;`     
D. `ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'LLAMA3.1-70B';`     

---

<br/>

15\. Which statement grants all available Cortex models to a role?  
A. `GRANT APPLICATION ROLE SNOWFLAKE.CORTEX_MODEL_ALL TO ROLE my_role;`    
B. `GRANT APPLICATION ROLE SNOWFLAKE."CORTEX-MODEL-ROLE-ALL" TO ROLE my_role;`   
C. `GRANT ROLE CORTEX_MODEL_ALL TO ROLE my_role;`     
D. `ALTER ROLE my_role ADD ALL MODELS;`    

---

<br/>

16\. Which statement correctly grants Document Intelligence creation privileges?
A. `GRANT DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`    
B. `GRANT DATABASE ROLE DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`   
C. `GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`     
D. `GRANT APPLICATION ROLE DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`    

---

<br/>

17\. How are Cortex Guardrails enabled in a COMPLETE call?
A. `{'enable_guardrails':true}`    
B. `{'guardrails':true}`   
C. `{'safety':true}`     
D. `{'unsafe_filter':true}`    

---

<br/>

18\. How do you disable Cortex Analyst at the account level?  
A. `DROP CORTEX ANALYST;`    
B. `ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = FALSE;`   
C. `REVOKE CORTEX_ANALYST FROM ACCOUNT;`     
D. `ALTER ACCOUNT UNSET CORTEX_ANALYST;`   

---

<br/>


# Answer Key

<details>
  <summary>Click to expand/collapse answers</summary>

1. B
2. C
3. C
4. A
5. D
6. B
7. A
8. B
9. B
10. D
11. A
12. C
13. D
14. C
15. B
16. C
17. B
18. B

</details>