
# Section 3: GenAI Governance (22%)

## Setup Model Access Control

### Limits on which Models Can Be Used

Restricting Access To Specific Models  
(Iookup)  
Steps for Fine Grained Control:

1. To use RBAC exclusively, set CORTEX\_MODELS\_ALLOWLIST to 'None'.  
2. create model objects in the SNOWFLAKE.MODELS schema that *represent* the Cortex models

3. Refresh available models:  **CALL** **SNOWFLAKE.MODELS.**CORTEX\_BASE\_MODELS\_REFRESH**();**  
   1. **Optional: SHOW MODELS IN SNOWFLAKE.MODELS;**  
   2. **View application roles \- SHOW APPLICATION ROLES IN APPLICATION SNOWFLAKE;**  
4. Grant Specific Models to user role: **GRANT** **APPLICATION ROLE** **SNOWFLAKE.**"CORTEX-MODEL-ROLE-LLAMA3.1-70B" **TO** **ROLE** MY\_ROLE**;**  
   1. Grant all models to a specific role: **GRANT** **APPLICATION ROLE** **SNOWFLAKE.**"CORTEX-MODEL-ROLE-ALL" **TO** **ROLE** MY\_ROLE**;**

Auth Flow:

1. First cortex looks in SNOWFLAKE.MODELS to see if it is available  
2. Then checks RBAC  
3. If no model is found, cortex looks at account-level allow list

Common Pitfalls

- RBAC/Allow list ok, but model not available in region  
- May have access to models, but not AI features (ex: CORTEX\_USER database role)  
- Not all features support model access controls  
- Secondary roles obscure permissions  
- Model names are accidently quoted and are case sensitive

Availability \- [https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql\#label-cortex-llm-rbac](https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql#label-cortex-llm-rbac)

(database role vs application roles vs account level)  
Builtin Database Roles, (In the SNOWFLAKE database)

- CORTEX\_USER (encompasses most of the below)  
- COPILOT\_USER  
- CORTEX\_EMBED\_USER  
- DOCUMENT\_INTELLIGENCE\_CREATOR  
- CORTEX\_AGENT\_USER

Document intelligence grants \-  
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT\_INTELLIGENCE\_CREATOR FROM ROLE X;

Allocates capacity for 1 month term  
**GRANT** **CREATE** **PROVISIONED THROUGHPUT** **ON** **ACCOUNT** **TO** **ROLE** **\<role\>**  
**GRANT** **USAGE** **ON** **PROVISIONED THROUGHPUT** **\<**pt\_id**\>** **TO** **ROLE** **\<role\>**

#### CORTEX\_MODELS\_ALLOWLIST parameter

Account level  
Models that can be accessed, ex:  
**ALTER** **ACCOUNT** **SET** **CORTEX\_MODELS\_ALLOWLIST** **\=** 'All'**;**

#### Cortex LLM REST API Auth Methods

- Key pair (with JWT)  
- OAuth  
- PAT token

#### COMPLETE (SNOWFLAKE.CORTEX)

(see section 2\)

#### TRY\_COMPLETE(SNOWFLAKE\_CORTEX)

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
  - Generate JWT \-\> Bearer token  
- PAT  
  - Pass as bearer token

## Guardrails \+ Unsafe LLM Responses

### Cortex Guard

- COMPLETE arguments

As part of COMPLETE and TRY\_COMPLETE statements \- Pass as arg  
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

- SNOWFLAKE.MODELS.CORTEX\_BASE\_MODELS\_REFRESH()  
- 

## Monitor \+ Optimize Snowflake Cortex Cost

### Cortex Search

[https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-costs](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-costs)

Costs

- Virtual Warehouse Compute  
  - refreshes, building the search index. If no changes, then no credits used  
- EMBED\_TEXT \- embeddings for each row inserted or updated  
  - Charges by token  
- Serving Compute \- multi-tenant serving  
  - Charges by GB/mo of uncompressed indexed data  
- Storage \- materialized source query  
  - Charges by TB  
- Cloud Services Compute \- check if changes in base objects to trigger virtual warehouse  
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
  **ON** transcript\_text  
  **ATTRIBUTES** region  
  **WAREHOUSE** \= mywh  
  **TARGET\_LAG** \= '1 hour'  
  **EMBEDDING\_MODEL** \= 'snowflake-arctic-embed-l-v2.0'  
  **INITIALIZE** \= **ON\_SCHEDULE**  
**AS** **SELECT** \* **FROM** support\_db.public.transcripts\_etl;

### Cortex Analyst

Cost Considerations:

- Based on number of **messages processed** (per 1000 messages) and **tokens** (depending)  
- Tokens **only** affect cost when Cortex Analyst is invoked using Cortex Agents, otherwise number of tokens doesn’t matter  
- Warehouse charges only when executing SQL  
- View Usage: **SELECT** **\*** **FROM** **SNOWFLAKE.**ACCOUNT\_USAGE**.**CORTEX\_ANALYST\_USAGE\_HISTORY**;**

enable/disable with:  
ALTER ACCOUNT SET ENABLE\_CORTEX\_ANALYST \= FALSE;

### Cortex LLM Functions

- Minimize Tokens  
- Token Cost Implications

Cost Considerations:

- Input/Output Tokens  
- Auditing  
  - Check costs (lookup)  
    - CORTEX\_FUNCTIONS\_USAGE\_HISTORY view  
    - CORTEX\_FUNCTIONS\_QUERY\_USAGE\_HISTORY view

### Tracking Model Usage \+ Consumption

(usage \+ consumption/monitoring tables)

- Usage Quotas

Account Usage Views:

- CORTEX\_FUNCTIONS\_USAGE\_HISTORY  
- CORTEX\_FUNCTIONS\_QUERY\_USAGE\_HISTORY  
- METERING\_DAILY\_HISTORY  
- CORTEX\_SEARCH\_DAILY\_USAGE\_HISTORY  
- CORTEX\_SEARCH\_SERVING\_USAGE\_HISTORY  
- CORTEX\_DOCUMENT\_PROCESSING\_USAGE\_HISTORY  
- CORTEX\_ANALYST\_USAGE\_HISTORY  
- CORTEX\_FINE\_TUNING\_USAGE\_HISTORY  
- CORTEX\_PROVISIONED\_THROUGHPUT\_USAGE\_HISTORY

#### CORTEX\_FUNCTIONS\_USAGE\_HISTORY view

View cortex functions like COMPLETE, TRANSLATE, etc…  
\# tokens, costs/credits  
By the hour (aggregated)  
Up to 1 year

#### CORTEX\_FUNCTIONS\_QUERY\_USAGE\_HISTORY view

usage history of each Cortex Functions query in a Snowflake account  
Up to 1 year  
Latency \- a few hours  
By query granularity (not aggregated)  
Ex- Get queries by user

#### METERING\_DAILY\_HISTORY view

Under account\_usage, AI\_SERVICES service\_type for info (cortex functions, analyst, document ai)  
Up to 1 year, up to 3 hr latency

#### CORTEX\_SEARCH\_DAILY\_USAGE\_HISTORY view

Cortex Search usage, credits/day  
Up to 1 year  
EMBED\_TEXT tokens, serving credits

#### CORTEX\_SEARCH\_REFRESH\_HISTORY view

Details for refresh operations, index duration, preprocessing stats, etc..

#### CORTEX\_SEARCH\_SERVING\_USAGE\_HISTORY view

Hourly serving credits per service

#### CORTEX\_SEARCH\_SERVING\_USAGE\_HISTORY

#### CORTEX\_DOCUMENT\_PROCESSING\_USAGE\_HISTORY view

Document AI processing function activity, including \<model\_build\_name\>\!PREDICT, PARSE\_DOCUMENT (SNOWFLAKE.CORTEX), and AI\_EXTRACT calls  
Credits, functions, model names, etc…  
Up to 1 year

#### SNOWFLAKE.LOCAL.CORTEX\_ANALYST\_REQUESTS table function

Logs for semantic view or model\\  
**SELECT** \* **FROM** **TABLE**(  
  **SNOWFLAKE**.**LOCAL**.CORTEX\_ANALYST\_REQUESTS(  
    '\<semantic\_model\_or\_view\_type\>',  
    '\<semantic\_model\_or\_view\_name\>'  
  )  
);

model/view type: “FILE\_ON\_STAGE” or “SEMANTIC\_VIEW”  
Name: fully qualified stage path, or semantic view name

#### CORTEX\_ANALYST\_USAGE\_HISTORY

Aggregated 1 hr, analyst credits used, metadata

#### CORTEX\_FINE\_TUNING\_USAGE\_HISTORY

Tokens \+ training credits by base model  
not costs for using the fine-tuned model in inference, costs for storage, or costs associated with data replication

#### CORTEX\_PROVISIONED\_THROUGHPUT\_USAGE\_HISTORY

Billing for provisioned throughputs

## Use Snowflake AI Observability Tools

### Snowflake AI Observability

Requires TruLens  
Roles \+ Privileges:

- AI\_OBSERVABILITY\_EVENTS\_LOOKUP role  
- CORTEX\_USER database role  
- CREATE TASK privilege on schema  
- EXECUTE TASK privilege

#### Eval Metrics

LLM as Judge \+

- Accuracy  
- Latency  
- Usage  
- Cost

**Differentiate between \- trace, logging, event table**

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

- Context Relevance \- context retrieved is relevant to query  
- Groundedness \- is response “grounded” by retrieved context  
- Answer Relevance \- Is it relevant to query  
- Correctness \- Is the answer correct  
- Coherence \- Answer quality