
# Section 3: GenAI Governance (22%)

## Setup Model Access Control

### Limits on which Models Can Be Used

Restricting Access To Specific Models  
(Iookup)  
Steps for Fine Grained Control:

1. To use RBAC exclusively, set CORTEX_MODELS_ALLOWLIST to 'None'.  
2. create model objects in the SNOWFLAKE.MODELS schema that *represent* the Cortex models

3. Refresh available models:  **CALL** **SNOWFLAKE.MODELS.**CORTEX_BASE_MODELS_REFRESH**();**  
   1. **Optional: SHOW MODELS IN SNOWFLAKE.MODELS;**  
   2. **View application roles - SHOW APPLICATION ROLES IN APPLICATION SNOWFLAKE;**  
4. Grant Specific Models to user role: **GRANT** **APPLICATION ROLE** **SNOWFLAKE.**"CORTEX-MODEL-ROLE-LLAMA3.1-70B" **TO** **ROLE** MY_ROLE**;**  
   1. Grant all models to a specific role: `GRANT APPLICATION ROLE SNOWFLAKE."CORTEX-MODEL-ROLE-ALL" TO ROLE MY_ROLE;`

Auth Flow:

1. First cortex looks in SNOWFLAKE.MODELS to see if it is available  
2. Then checks RBAC to see if access is allowed  
3. If no model is found, cortex looks at account-level allow list

Common Pitfalls

- RBAC/Allow list ok, but model not available in region  
- May have access to models, but not AI features (ex: CORTEX_USER database role)  
- Not all features support model access controls  
- Secondary roles obscure permissions  
- Model names are accidently quoted and are case sensitive

Availability - [https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql\#label-cortex-llm-rbac](https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql#label-cortex-llm-rbac)

(database role vs application roles vs account level)  
Builtin Database Roles, (In the SNOWFLAKE database)

- CORTEX_USER (encompasses most of the below)  
- COPILOT_USER  
- CORTEX_EMBED_USER  
- DOCUMENT_INTELLIGENCE_CREATOR  
- CORTEX_AGENT_USER

Document intelligence grants -  
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR FROM ROLE X;

Allocates capacity for 1 month term  
**GRANT** **CREATE** **PROVISIONED THROUGHPUT** **ON** **ACCOUNT** **TO** **ROLE** **\<role\>**  
**GRANT** **USAGE** **ON** **PROVISIONED THROUGHPUT** **\<**pt_id**\>** **TO** **ROLE** **\<role\>**

#### CORTEX_MODELS_ALLOWLIST parameter

Account level  
Models that can be accessed, ex:  
**ALTER** **ACCOUNT** **SET** **CORTEX_MODELS_ALLOWLIST** **\=** 'All'**;**

#### Cortex LLM REST API Auth Methods

- Key pair (with JWT)  
- OAuth  
- PAT token

#### COMPLETE (SNOWFLAKE.CORTEX)

(see section 2\)

#### TRY_COMPLETE(SNOWFLAKE_CORTEX)

(see section 2\)

#### Cortex LLM Playground (PuPr)

### Data Safety \+ Security Considerations

- Is Data leaving/going to LLMs:  
  - Not shared between customers  
  - Data stays in Snowflake Security Boundary  
  - Models that you bring with SPCS are considered “customer data”

### Rest API Authentication Methods

- OAuth  
  - Interna \+ External OAuth supported  
- RSA key/Key Pair  
  - Setup key pairs  
  - Generate JWT -\> Bearer token  
- PAT  
  - Pass as bearer token

## Guardrails \+ Unsafe LLM Responses

### Cortex Guard

- COMPLETE arguments

As part of COMPLETE and TRY_COMPLETE statements - Pass as arg  
Doesn’t work with fine tuned models / purposed built  
**SELECT** SNOWFLAKE.CORTEX.COMPLETE**(**  
    'mistral-large2'**,**  
    **\[**  
        **{**  
            'role'**:** 'user'**,**  
            'content'**:** **\<**'Prompt that generates an unsafe response'**\>**  
        **}**  
    **\],**  
    **{**  
        'guardrails': true  
    **}**  
**);**

### Methods To Reduce Model Hallucinations \+ Bias

- Model size vs hallucinations  
- Temperature (creativity vs “factual” answers)  
- Top-p  
- RAG vs Non-Rag

### Error Conditions

- SNOWFLAKE.MODELS.CORTEX_BASE_MODELS_REFRESH()  
- 

## Monitor \+ Optimize Snowflake Cortex Cost

### Cortex Search

[https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-costs](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-costs)

Costs

- Virtual Warehouse Compute  
  - refreshes, building the search index. If no changes, then no credits used  
- EMBED_TEXT - embeddings for each row inserted or updated  
  - Charges by token  
- Serving Compute - multi-tenant serving  
  - Charges by GB/mo of uncompressed indexed data  
- Storage - materialized source query  
  - Charges by TB  
- Cloud Services Compute - check if changes in base objects to trigger virtual warehouse  
  - Only billed if cloud service cost is \>10% of daily wh cost

Cost Considerations

- Minimize wh size  
- Suspend indexing  
- Use a longer target lag  
- Define primary keys  
- Bundle changes (minimize re-indexing)  
- Minimize changes to source data  
- Keep source query simple  
- Suspend serving when not needed

**CREATE** **OR** **REPLACE** **CORTEX SEARCH SERVICE** mysvc  
  **ON** transcript_text  
  **ATTRIBUTES** region  
  **WAREHOUSE** \= mywh  
  **TARGET_LAG** \= '1 hour'  
  **EMBEDDING_MODEL** \= 'snowflake-arctic-embed-l-v2.0'  
  **INITIALIZE** \= **ON_SCHEDULE**  
**AS** **SELECT** \* **FROM** support_db.public.transcripts_etl;

### Cortex Analyst

Cost Considerations:

- Based on number of **messages processed** (per 1000 messages) and **tokens** (depending)  
- Tokens **only** affect cost when Cortex Analyst is invoked using Cortex Agents, otherwise number of tokens doesn’t matter  
- Warehouse charges only when executing SQL  
- View Usage: **SELECT** **\*** **FROM** **SNOWFLAKE.**ACCOUNT_USAGE**.**CORTEX_ANALYST_USAGE_HISTORY**;**

enable/disable with:  
ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST \= FALSE;

### Cortex LLM Functions

- Minimize Tokens  
- Token Cost Implications

Cost Considerations:

- Input/Output Tokens  
- Auditing  
  - Check costs (lookup)  
    - CORTEX_FUNCTIONS_USAGE_HISTORY view  
    - CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY view

### Tracking Model Usage \+ Consumption

(usage \+ consumption/monitoring tables)

- Usage Quotas

Account Usage Views:

- CORTEX_FUNCTIONS_USAGE_HISTORY  
- CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY  
- METERING_DAILY_HISTORY  
- CORTEX_SEARCH_DAILY_USAGE_HISTORY  
- CORTEX_SEARCH_SERVING_USAGE_HISTORY  
- CORTEX_DOCUMENT_PROCESSING_USAGE_HISTORY  
- CORTEX_ANALYST_USAGE_HISTORY  
- CORTEX_FINE_TUNING_USAGE_HISTORY  
- CORTEX_PROVISIONED_THROUGHPUT_USAGE_HISTORY

#### CORTEX_FUNCTIONS_USAGE_HISTORY view

View cortex functions like COMPLETE, TRANSLATE, etc…  
\# tokens, costs/credits  
By the hour (aggregated)  
Up to 1 year
Does not include input/output token level detail (more granular than query)

#### CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY view

usage history of each Cortex Functions query in a Snowflake account  
Up to 1 year  
Latency - a few hours  
By query granularity (not aggregated)  
Ex- Get queries by user
Does not include input/output token level detail (more granular than query)

#### METERING_DAILY_HISTORY view

Under account_usage, AI_SERVICES service_type for info (cortex functions, analyst, document ai)  
Up to 1 year, up to 3 hr latency

#### CORTEX_SEARCH_DAILY_USAGE_HISTORY view

Cortex Search usage, credits/day  
Up to 1 year  
EMBED_TEXT tokens, serving credits

#### CORTEX_SEARCH_REFRESH_HISTORY view

Details for refresh operations, index duration, preprocessing stats, etc..

#### CORTEX_SEARCH_SERVING_USAGE_HISTORY view

Hourly serving credits per service


#### CORTEX_DOCUMENT_PROCESSING_USAGE_HISTORY view

Document AI processing function activity, including \<model_build_name\>\!PREDICT, PARSE_DOCUMENT (SNOWFLAKE.CORTEX), and AI_EXTRACT calls  
Credits, functions, model names, etc…  
Up to 1 year

#### SNOWFLAKE.LOCAL.CORTEX_ANALYST_REQUESTS table function

Logs for semantic view or model\\  
**SELECT** \* **FROM** **TABLE**(  
  **SNOWFLAKE**.**LOCAL**.CORTEX_ANALYST_REQUESTS(  
    '\<semantic_model_or_view_type\>',  
    '\<semantic_model_or_view_name\>'  
  )  
);

model/view type: “FILE_ON_STAGE” or “SEMANTIC_VIEW”  
Name: fully qualified stage path, or semantic view name

#### CORTEX_ANALYST_USAGE_HISTORY

Aggregated 1 hr, analyst credits used, metadata

#### CORTEX_FINE_TUNING_USAGE_HISTORY

Tokens \+ training credits by base model  
not costs for using the fine-tuned model in inference, costs for storage, or costs associated with data replication

#### CORTEX_PROVISIONED_THROUGHPUT_USAGE_HISTORY

Billing for provisioned throughputs

#### CORTEX_AISQL_USAGE_HISTORY
Include Input/output token granularity for queries

## Use Snowflake AI Observability Tools

### Snowflake AI Observability

Requires TruLens  
Roles \+ Privileges:

- AI_OBSERVABILITY_EVENTS_LOOKUP role  
- CORTEX_USER database role  
- CREATE TASK privilege on schema  
- EXECUTE TASK privilege

#### Eval Metrics

LLM as Judge \+

- Accuracy  
- Latency  
- Usage  
- Cost

**Differentiate between - trace, logging, event table**

#### Comparisons

Side by side of model responses

#### Tracing

Application execution across workflows, connects events/logs  
(why it happened)

#### Logging

Discrete events  
(how it happened)

#### Event Tables

Storage of events/logs  
(what happened)

### Implementation Methods

#### Trulens SDK

[https://www.snowflake.com/en/developers/guides/getting-started-with-ai-observability/](https://www.snowflake.com/en/developers/guides/getting-started-with-ai-observability/)  
Tracing, Evals, Monitoring

Key Components:

- Context Relevance - context retrieved is relevant to query  
- Groundedness - is response “grounded” by retrieved context  
- Answer Relevance - Is it relevant to query  
- Correctness - Is the answer correct  
- Coherence - Answer quality