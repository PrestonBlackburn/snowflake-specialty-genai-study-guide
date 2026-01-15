# Section 1: GenAI Overview (26%)

## Define Snowflake GenAI principles, features, and best practices

### Snowflake Cortex

Snowflake cortex is Snowflake's Gen AI suite of tools. These include:

- **LLMs** - Snowflake Cortex provides access to multiple large language models (like Claude, Mistral, Llama) that run securely within Snowflake's infrastructure for text generation, analysis, and completion tasks.  
- **Cortex Search** -  Cortex Search is a fully managed service that enables semantic search over unstructured data using vector embeddings and keyword search capabilities. 
  - **RAG \+ Unstructured Data** - RAG (Retrieval-Augmented Generation) combines Cortex Search to retrieve relevant document chunks with LLMs to generate accurate, contextually-grounded responses from your unstructured data  
- **Cortex File Tuning** - Cortex Fine Tuning allows you to customize base LLMs (like Mistral or Llama models) on your specific data to improve accuracy and consistency for domain-specific use cases.   
- **Cortex Agent** - Cortex Agents autonomously orchestrate multi-step workflows across both structured and unstructured data sources by planning tasks, using tools, and iterating to deliver comprehensive insights.  
- **Cortex Analyst** - Cortex Analyst enables business users to ask natural language questions about structured data and automatically generates and executes SQL queries to provide answers.      
  - **Semantic Models** - Semantic models are YAML or view-based definitions that describe your data's structure (tables, metrics, relationships) to help Cortex Analyst understand your business context and generate accurate SQL.    
  - **Structured Text-To-SQL** - Structured Text-To-SQL is Cortex Analyst's capability to translate natural language business questions into executable SQL queries using semantic model definitions.   
- **Cortex Functions** -  Cortex Functions are pre-built SQL functions that provide AI capabilities like text generation (COMPLETE), sentiment analysis, translation, summarization, and embeddings directly within SQL queries.  
  - **General Purpose vs Task Specific** - 
General purpose functions (like COMPLETE) handle flexible text generation tasks, while task-specific functions (like SENTIMENT, TRANSLATE, CLASSIFY_TEXT) are optimized for particular operations with better performance and lower cost.   

### Snowflake Co-pilot

Snowflake Copilot is an AI-powered assistant integrated into the Snowflake interface that helps users write SQL queries, understand data, and perform analytics tasks through natural language interactions, making it easier for both technical and non-technical users to work with their Snowflake data.  

**Supported Cases:**
- Explore your data by asking open-ended questions to learn about the structure and nuances of a new dataset.  
- Generate SQL queries with questions in plain English.  
- Try out the SQL query suggested by Snowflake Copilot with the click of a button. You can also edit the query before running it.  
- Build complex queries through a conversation with Snowflake Copilot by asking follow-up questions to refine the suggested SQL query and dig deeper into the analysis.  
- Learn about Snowflake by asking questions about Snowflake concepts, capabilities, and features.  
- Improve your queries by asking Snowflake Copilot to help you assess query efficiency, find optimizations, or explain what the query does.  
- Provide feedback (thumbs up or thumbs down) on each response from Snowflake Copilot, which will be used to improve the product.  
- Add custom instructions such as a set of preferences or specific business knowledge for Snowflake Copilot to consider when generating responses.  


### Security, Privacy, Access & Control Principals

#### RBAC
Some Snowflake AI features are opt-in. Access to these features is disabled by default. These can be managed through snowflake RBAC  
**Opt-in** Features:  
- **Cortex Analyst:** `ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = TRUE;`  
- **Cortex Fine tuning:** `GRANT CREATE MODEL ON SCHEMA my_schema TO ROLE my_role;`  
- **Cortex Embedding Functions:** `GRANT DATABASE ROLE SNOWFLAKE.CORTEX_EMBED_USER TO ROLE my_role;`
  - *Note - technically not an opt-in since `CORTEX_USER` also gives access to these*  
- **Document AI:** `GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE my_role;`  
- **Provisioned Throughput:** `GRANT CREATE PROVISIONED THROUGHPUT ON SCHEMA my_schema TO ROLE my_role;`   


**Opt-out** Features (on by default):   
- **Snowflake Agents:** through SNOWFLAKE.CORTEX_USER database role   
- **Cortex AI Functions:** through SNOWFLAKE.CORTEX_USER database role   
- **Cortex Knowledge Extensions** through SNOWFLAKE.CORTEX_USER database role    
- **Cortex Search** through SNOWFLAKE.CORTEX_USER database role   
- **Snowflake Copilot** Through SNOWFLAKE.**COPILOT_USER** database role  
- **Snowflake Intelligence** through SNOWFLAKE.CORTEX_USER database role  
*opt out since `COPILOT_USER` and `CORTEX_USER` are by default granted to `PUBLIC` role*

#### Guardrails   
Snowflake uses Cortex Gaurd to add guardrail features to functions like Cortex `COMPLETE`.  

Filters potentially unsafe and harmful responses from a language model.  

#### Control model access
Allowed models can be managed at the Account level with **CORTEX_MODELS_ALLOWLIST**  
`ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'None';`  
`ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'mistral-large2,llama3.1-70b';`  
`ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'All';`  


*Note - For account level parameters, not even the Accountadmin role can access the disabled features. However, the Accountadmin role can also turn the features back on*  

### Interfaces

#### Cortex LLM Playground  
The Cortex Playground lets you compare text completions across the multiple large language models available in Cortex AI    
Features Include:   
- Compare model outputs side by side  
- Connect to Snowflake Tables  
- Control settings  
- Export settings to a SQL query  

**Playground UI:**   
![Cortex LLM Playground](https://www.snowflake.com/adobe/dynamicmedia/deliver/dm-aid--ea48f40d-d0f4-4e37-9158-c62daa775f3b/build2024-ai-ml-cortex-playground.jpg?preferwebp=true&quality=85&width=1440)


#### AI SQL Functions  
Cortex AI Functions reimagines SQL into an AI query language for multimodal data, bringing powerful AI capabilities directly into Snowflake's SQL engine    
- `AI_COMPLETE:` Generate AI-powered text completions or descriptions for various inputs including text and images  
- `AI_TRANSCRIBE:` Transcribe audio files  
- `AI_FILTER:` Semantic filtering  
- `AI_AGG:` Aggregate insights across multiple rows  
- `AI_CLASSIFY:` Text and image classification  

#### REST API  
You can use the Snowflake Cortex REST API to invoke inference with the LLM of your choice    
Features:  
- Allows you to bring state-of-the-art AI functionality to your applications.   
- **Using this API doesn’t require a warehouse.**   
- Supports **complete** and **embed** functions  

### BYOM
Two methods:  
- Snowflake Model Registry  
- Snowpark Container Services

## Outline GenAI Capabilities In Snowflake

### Cortex LLM Functions (task specific vs General)

New Cortex function and replacement function pairs:  
- AI_CLASSIFY, CLASSIFY_TEXT  
- EXTRACT_ANSWER  
- AI_EXTRACT, EXTRACT_ANSWER  
- AI_PARSE_DOCUMENT, PARSE_DOCUMENT  
- AI_SENTIMENT, SENTIMENT, ENTITY_SENTIMENT
- SUMARIZE  
- AI_TRANSLATE, TRANSLATE
- AI_EMBED, EMBED_TEXT_768, EMBED_TEXT_1024  
- AI_COMPLETE, COMPLETE
- AI_FILTER
- AI_AGG

Helper Functions:
- COUNT_TOKENS, AI_COUNT_TOKENS - Given an input text, returns the token count based on the model or Cortex function specified.  
- TO_FILE - Creates a reference to a file in an internal or external stage for use with AI_COMPLETE and other functions that accept files.  
- PROMPT - Helps you build prompt objects for use with AI_COMPLETE and other functions.  
- TRY_COMPLETE - Works like the COMPLETE function, but returns NULL when the function could not execute instead of an error code.  

*Note: Cortex AI Functions are optimized for throughput. We recommend using these functions to process numerous inputs such as text from large SQL tables. Batch processing is typically better suited for AI Functions. For more interactive use cases where latency is important, use the REST API. These are available for simple inference (Complete API), embedding (Embed API) and agentic applications (Agents API)*  

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
Use RAG when you need LLMs to answer questions accurately based on your specific documents (like customer support using company knowledge bases, policy compliance checking, or research assistance) by retrieving relevant context before generating responses.  

#### Unstructured data use cases
Examples:  
- Information Discovery  
- Knowledge Worker Chat  
- Product Search  

#### REST APIs 
When you create a Cortex Search Service, the system provisions an API endpoint to serve queries at low latency. You can use three APIs for querying a Cortex Search Service:
```bash
curl --location https://<ACCOUNT_URL>/api/v2/databases/<DB_NAME>/schemas/<SCHEMA_NAME>/cortex-search-services/<SERVICE_NAME>:query \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $PAT" \
--data '{
  "query": "<search_query>",
  "columns": ["col1", "col2"],
  "filter": <filter>,
  "limit": <limit>
}'
```

### Cortex Analyst
Use Cortex Analyst when business users need to ask natural language questions about structured data in tables (like "What were sales by region last quarter?") without writing SQL, enabling self-service analytics for non-technical users.  

#### Semantic model generation
Semantic models map business terminology to database schemas and add contextual meaning.   
- Store YAML Files In Stage  
- Store natively in semantic views

#### structured/text-to-sql use cases
Use Cases:  
- Democratized Data Access  
- Enhanced Data Exploration  
- Efficient Report Generation  

#### Rest APIs
Generates a SQL query for the given question using a semantic model or semantic view provided in the request. One or more models can be specified; when multiple models are specified, Cortex Analyst chooses the most appropriate one. You can have multi-turn conversations where you can ask follow-up questions that build upon previous queries. For more information, see Multi-turn conversation in Cortex Analyst.  
`POST /api/v2/cortex/analyst/message`

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

REST API EXAMPLE:
`POST /api/v2/databases/{database}/schemas/{schema}/agents`

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