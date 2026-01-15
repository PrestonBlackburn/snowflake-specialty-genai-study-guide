# Section 1: GenAI Overview (26%)

## Define Snowflake GenAI principles, features, and best practices

### Snowflake Cortex

- LLMs  
- Cortex Search  
  - RAG \+ Unstructured Data  
- Cortex File Tuning  
- Cortex Agent  
- Cortex Analyst  
  - Semantic Models  
  - Structured Text-To-SQL  
- Cortex Functions  
  - General Purpose vs Task Specific

### Snowflake Co-pilot

### Security, Privacy, Access & Control Principals

Some Snowflake AI features are opt-in. Access to these features is disabled by default.  
**Opt-in** Features:  
- **Cortex Analyst:** `ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = TRUE;`  
- **Cortex Fine tuning:** `GRANT CREATE MODEL ON SCHEMA my_schema TO ROLE my_role;`  
- **Cortex Embedding Functions:** `GRANT DATABASE ROLE SNOWFLAKE.CORTEX_EMBED_USER TO ROLE my_role;`
  - *Note - technically not an opt-in since `CORTEX_USER` also gives access to these*  
- **Document AI:** `GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`  
- **Provisioned Throughput:** `GRANT CREATE PROVISIONED THROUGHPUT ON SCHEMA my_schema TO ROLE my_role;`   


**Opt-out** Features:   
- **Snowflake Agents:** through SNOWFLAKE.CORTEX_USER database role   
- **Cortex AI Functions:** through SNOWFLAKE.CORTEX_USER database role   
- **Cortex Knowledge Extensions** through SNOWFLAKE.CORTEX_USER database role    
- **Cortex Search** through SNOWFLAKE.CORTEX_USER database role   
- **Snowflake Copilot** Through SNOWFLAKE.**COPILOT_USER** database role  
- **Snowflake Intelligence** through SNOWFLAKE.CORTEX_USER database role  

- ### RBAC

- Gaurdrails   
- Required Privileges   
- Cortex LLM Functions   
  - Control model access (CORTEX_MODELS_ALLOWLIST, etc..)  

*Note - For account level parameters, not even the Accountadmin role can access the disabled features. However, the Accountadmin role can also turn the features back on*  

### Interfaces

- Cortex LLM Playground  
  -   
- AI SQL Functions  
  -   
- REST API  
  - Most services except Cortex functions?

### BYOM

- Snowflake Model Registry  
- Snowpark Container Services

## 

## Outline GenAI Capabilities In Snowflake

### Cortex LLM Functions (task specific vs General)

#### Vector Embeddings

- Structured numerical representations, from unstructured data such as text and images, while preserving semantic notions of similarity and dissimilarity in the geometry of the vectors they produce.

VECTOR( \<type\>, \<dimension\> )  
VECTOR(FLOAT, 256)

For VECTOR columns, you must load and unload data as an ARRAY and then cast it to a VECTOR when you use it

#### Fine Tuning

(see section 2\)

### Cortex Search
Use Cases:  
- **RAG engine for LLM chatbots:** Use Cortex Search as a RAG engine for chat applications with your text data by leveraging semantic search for customized, contextualized responses.  
- **Enterprise search:** Use Cortex Search as a backend for a high-quality search bar embedded in your application.  

Mechanics:  
- Cortex Search indexes textual and unstructured content  
- Uses embeddings to perform semantic retrieval   


![Cortex Diagram](https://docs.snowflake.com/en/_images/cortex-search-rag.png)

#### RAG use cases

#### Unstructured data use cases

#### REST APIs 

### Cortex Analyst

#### Semantic model generation

- Store YAML Files In Stage  
- Store natively in semantic views

#### structured/text-to-sql use cases

#### Rest APIs

### Cortex Agents

Cortex Agents orchestrate across both structured and unstructured data sources to deliver insights  
Workflow Steps/Components:

1. Planning - Explore options, split tasks, route to tools   
2. Tool Use - processing with tools   
3. Reflection - evaluate next step    
4. Monitor \+ Iterate - TrueLens can monitor agent interaction  

Concepts:

- Agent Object - all agent metadata   
- Threads - preserve history of interactions   
- Orchestration (Models, Instructions, Sample Questions)   
- Tools (custom, cortex analyst semantic view, cortex search service)  

Considerations/Access:

- SNOWFLAKE.CORTEX_USER or SNOWFLAKE.CORTEX_AGENT_USER role granted  
- SNOWFLAKE.CORTEX_USER  - All Cortex AI Features   
- SNOWFLAKE.CORTEX_AGENT_USER - Just Agent Features  

Cost Considerations:

- Orchestration based on tokens used   
- Cortex Analyst charged per token   
- Cortex Search depends on size of index \+ time persisted   
- Warehouse charges depend on size of warehouse \+ time  

Interact With:

- REST APIs  
- UI  
- SQL  

### Cortex Region Inferences

To support more models, cross region inference can be enabled, ex:   
`ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';`  
`ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';`  
`ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'DISABLED';` --default region  
`ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US,AWS_EU'`  

**Default Value**: `DISABLED`  

*note - `AWS_US` and other parameters correspond to region groups and not a specific region*  

Considerations:  

- Gov regions are limited (US East, US West)  
- Credits are considered consumed in the requesting region   
- No data egress charges for cross region   
- May have additional latency (needs to be tested)   
- Model availability varies 

Also - User inputs, service-generated prompts, and outputs are not stored or cached during cross-region inference  

**Requesting Region:** This is the home region where your Snowflake account is primarily hosted and from where you initiate a request