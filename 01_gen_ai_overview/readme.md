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

(mostly covered by section3)

- ### RBAC

- Gaurdrails  
- Required Privileges  
- Cortex LLM Functions  
  - Control model access (CORTEX\_MODELS\_ALLOWLIST, etc..)

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

**VECTOR**( \<type\>, \<dimension\> )  
**VECTOR(FLOAT,** 256**)**

For VECTOR columns, you must load and unload data as an **ARRAY** and then cast it to a VECTOR when you use it

#### Fine Tuning

(see section 2\)

### Cortex Search

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

1. Planning \- Explore options, split tasks, route to tools  
2. Tool Use \- processing with tools  
3. Reflection \- evaluate next step  
4. Monitor \+ Iterate \- TrueLens can monitor agent interaction

Concepts:

- Agent Object \- all agent metadata  
- Threads \- preserve history of interactions  
- Orchestration (Models, Instructions, Sample Questions)  
- Tools (custom, cortex analyst semantic view, cortex search service)

Considerations/Access:

- SNOWFLAKE.CORTEX\_USER or SNOWFLAKE.CORTEX\_AGENT\_USER role granted  
- SNOWFLAKE.CORTEX\_USER  \- All Cortex AI Features  
- SNOWFLAKE.CORTEX\_AGENT\_USER \- Just Agent Features

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
**ALTER** **ACCOUNT** **SET** **CORTEX\_ENABLED\_CROSS\_REGION** **\=** 'AWS\_US'**;**  
**ALTER** **ACCOUNT** **SET** **CORTEX\_ENABLED\_CROSS\_REGION** **\=** 'ANY\_REGION'**;**  
**ALTER** **ACCOUNT** **SET** **CORTEX\_ENABLED\_CROSS\_REGION** **\=** 'DISABLED'**; \--default region**  
**ALTER ACCOUNT SET CORTEX\_ENABLED\_CROSS\_REGION \= 'AWS\_US,AWS\_EU'**

Considerations:

- Gov regions are limited (US East, US West)  
- Credits are considered consumed in the requesting region  
- No data egress charges for cross region  
- May have additional latency (needs to be tested)  
- Model availability varies
