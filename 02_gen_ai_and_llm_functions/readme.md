# Section 2: GenAI and LLM Functions (40%)

## Apply GenAI \+ LLM Functions

(possibly small syntax differences here)

### Snowflake Cortext

Function Call Requirements (generally):

- Usage on SNOWFLAKE.CORTEX schema  
- Is in \-\> SNOWFLAKE.CORTEX\_USER database role

*NOTE*: SNOWFLAKE.CORTEX\_USER database role is granted to the PUBLIC role by default

#### **COMPLETE**

Standard llm usage  
General usage

**Basic Usage**  
```sql
SNOWFLAKE.CORTEX.COMPLETE(
    <model>, <prompt_or_history> [ , <options> ] )
```

```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'openai-gpt-4.1',
        CONCAT('Critique this review in bullet points: <review>', content, '</review>')
) FROM reviews LIMIT 10;
```

OR  
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'claude-4-sonnet ',
    [
        {
            'role': 'user',
            'content': 'how does a snowflake get its unique pattern?'
        }
    ],
    {
        'temperature': 0.7,
        'max_tokens': 10
    }
);
```


With standard OpenAI type output format  
```sql
{
    "choices": [
        {
            "messages": " The unique pattern on a snowflake is"
        }
    ],
    "created": 1708536426,
    "model": "deepseek-r1",
    "usage": {
        "completion_tokens": 10,
        "prompt_tokens": 22,
        "guardrail_tokens": 0,
        "total_tokens": 32
    }
}
```

**Usage With File (Multi-modal)**  
Beyond completion use cases \- Comparing images, Captioning images, Classifying images, Extracting entities from images

```sql
SNOWFLAKE.CORTEX.COMPLETE(
    '<model>', '<prompt>', <file_object>)
FROM <table>
```
Or 
```sql
SNOWFLAKE.CORTEX.COMPLETE(
    '<model>', <prompt_object> )
FROM <table>
```

```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    'Which country will observe the largest inflation change in 2024 compared to 2023?',
    TO_FILE('@myimages', 'highest-inflation.png'));
```

With Prompt Object instead of Prompt + File  
```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Classify the input image {0} in no more than 2 words. Respond in JSON', img_file)) AS image_classification
FROM image_table;
```

Where “TO\_FILE” creates a file object from the stage path (optional for prompt object)

**Usage With Structured Outputs**

COMPLETE \*With Structured Outputs\*  
\*These are actually in AI\_COMPLETE\*  
Response format is required, can be done in json or pydantic

#### CLASSIFY\_TEXT

Task specific  
```sql
SNOWFLAKE.CORTEX.CLASSIFY_TEXT( <input> , <list_of_categories>, [ <options> ] )
```
Can provide examples in \<options\>, but limit of 20  
Basic Example  
```sql
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT('One day I will see the world', ['travel', 'cooking']);
```
Output:  
```json
{  
  "label": "travel"  
}  
```

With description  
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

```json
{
  "label": "fitness"
}
```
Multi-label Example:  
```sql
SELECT AI_CLASSIFY(
  'One day I will see the world and learn to cook my favorite dishes',
  ['travel', 'cooking', 'reading', 'driving'],
  {'output_mode': 'multi'}
);
```

#### EXTRACT\_ANSWER

Task specific  
Q+A From “document” (just text or json)   
Syntax:  
```sql
SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
    <source_document>, <question>)
```
Usage  
```sql
SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER(review_content,
    'What dishes does this review mention?')
FROM reviews LIMIT 10;
```
#### PARSE\_DOCUMENT

Task specific  
OCR Necessary if text only  
LAYOUT needed if tables data is needed  
```sql
SNOWFLAKE.CORTEX.PARSE_DOCUMENT( '@<stage>', '<path>', [ <options> ] )
```

Modes: OCR (text only) and LAYOUT (text \+ layout, ex: tables)  
```sql
SELECT TO_VARCHAR(
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        '@PARSE_DOCUMENT.DEMO.documents',
        'document_1.pdf',
        {'mode': 'OCR'})
    ) AS OCR;
```
```json
{  
    "content": "content of the document"  
}
```

For processing Tables:  
```sql
SELECT
  TO_VARCHAR (
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT (
        '@PARSE_DOCUMENT.DEMO.documents',
        'document_1.pdf',
        {'mode': 'LAYOUT'} ) ) AS LAYOUT;
```
Examples:
```json
{
  "content": "# This is PARSE DOCUMENT example
     Example table:
     |Header|Second header|Third Header|
     |:---:|:---:|:---:|
     |First row header|Data in first row|Data in first row|
     |Second row header|Data in second row|Data in second row|

     Some more text."
 }
```

Also an output option:  
"errorInformation": Contains error information if document can’t be parsed  
And metadata for page count if splitting on pages  
```sql
**SELECT**  
SELECT TO_VARCHAR(
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        '@PARSE_DOCUMENT.DEMO.documents',
        'document_1.pdf',
        {'mode': 'OCR'})
    ) AS OCR;
```
```json
{  
  "pages": [  
    {  
      "content": "content of the first page",  
      "index": 0  
    },  
    {  
      "content": "content of the second page",  
      "index": 1  
    },  
    {  
      "content": "content of the third page",  
      "index": 2  
    }  
  ],  
  "metadata": {  
    "pageCount": 3  
  }  
}
```

#### SENTIMENT

Task specific  
Overall sentiment score \-1 to 1  
```sql
SNOWFLAKE.CORTEX.SENTIMENT(<text>)
```

```sql
SELECT SNOWFLAKE.CORTEX.SENTIMENT('A tourist\'s delight, in low urban light,
  Recommended gem, a pizza night sight. Swift arrival, a pleasure so right,
  Yet, pockets felt lighter, a slight pricey bite. 💰🍕🚀');
```
```sql
0.5424458
```

#### SUMARIZE

Task specific  
Summarize provided text

```sql
SNOWFLAKE.CORTEX.SUMMARIZE(<text>)
```

```sql
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(review_content) FROM reviews LIMIT 10;
```


#### TRANSLATE

Task specific  
Supported language codes: [https://docs.snowflake.com/en/sql-reference/functions/translate-snowflake-cortex](https://docs.snowflake.com/en/sql-reference/functions/translate-snowflake-cortex)  
```sql
SNOWFLAKE.CORTEX.TRANSLATE(
    <text>, <source_language>, <target_language>)
```
```sql
SELECT SNOWFLAKE.CORTEX.TRANSLATE(review_content, 'en', 'de') FROM reviews LIMIT 10;
```


#### EMBED\_TEXT\_768

Task specific  

```sql
SNOWFLAKE.CORTEX.EMBED_TEXT_768( <model>, <text> )
```
```sql
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'Embed me plz');
```
Models: snowflake-arctic-embed-m-v1.5, snowflake-arctic-embed-m, e5-base-v2

#### EMBED\_TEXT\_1024

Task specific  

```sql
SNOWFLAKE.CORTEX.EMBED_TEXT_1024( <model>, <text> )
```
```sql
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_1024('nv-embed-qa-4', 'embed me plz'); 
```
Models: snowflake-arctic-embed-l-v2.0, snowflake-arctic-embed-l-v2.0-8k, nv-embed-qa-4, multilingual-e5-large, voyage-multilingual-2

### Cortex Search

### Cortex Analyst

### Cortex Fine Tuning

Privileges:

- CREATE MODEL or OWNERSHIP on schema  
- **GRANT** **CREATE** **MODEL** **ON** **SCHEMA** my\_schema **TO** **ROLE** my\_role**;**  
- Usage on database  
- SNOWFLAKE.CORTEX\_USER database role  
- OWNERSHIP privilege on the model is required to access the fine-tuned model’s artifacts

Cost Considerations:

- Fine-tuning trained tokens \= number of input tokens \* number of epochs trained  
- For the COMPLETE function, which generates new text in the response, both input and output tokens are counted.  
- Finetune **’Describe’** also shows token usage  
- Also in **CORTEX\_FINE\_TUNING\_USAGE\_HISTORY**

Considerations:

- Limits on row based on epochs \+ models  
- Effective row count limit \= 1 epoch limit for base model / number of epochs trained  
- So higher epochs mean lower total rows can be used  
- Llama 3.1 \+ Mixtrial models can be finetuned  
- Fine Tuning results data in the Snowflake Model Registry UI  
- If a base model is removed from the Cortex LLM Functions, your fine-tuned model will no longer work  
- [Cross-region inference](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cross-region-inference) does not support fine-tuned models, must use database replication  
- table or view and the query result must contain columns named prompt and completion

4 cases of fine tuning \-   
SNOWFLAKE.CORTEX.FINETUNE **(**  
  { 'CREATE' | 'SHOW' | 'DESCRIBE' | 'CANCEL' }  
  ...  
  )

SNOWFLAKE.CORTEX.FINETUNE**(**  
  'CREATE',  
  '\<new\_model\_name\>',  
  '\<base\_model\>',  
  '\<training\_data\_query\>'  
  \[  
    , '\<validation\_data\_query\>'  
    \[, '\<options\>' \]  
  \]  
)

**SELECT** SNOWFLAKE.CORTEX.FINETUNE**(**  
  'CREATE'**,**  
  'my\_tuned\_model'**,**  
  'mistral-7b'**,**  
  'SELECT prompt, completion FROM train'**,**  
  'SELECT prompt, completion FROM validation'  
**);**

SNOWFLAKE.CORTEX.FINETUNE**(**  
  'DESCRIBE',  
  '\<finetune\_job\_id\>'  
)  
{  
  "base\_model":"mistral-7b",  
  "created\_on":1717004388348,  
  "finished\_on":1717004691577,  
  "id":"ft\_6556e15c-8f12-4d94-8cb0-87e6f2fd2299",  
  "model":"mydb.myschema.my\_tuned\_model",  
  "progress":1.0,  
  "status":"SUCCESS",  
  "training\_data":"SELECT prompt, completion FROM train",  
  "trained\_tokens":2670734,  
  "training\_result":{"validation\_loss":1.0138969421386719,"training\_loss":0.6477728401547047},  
  "validation\_data":"SELECT prompt, completion FROM validation",  
  "options":{"max\_epochs":3}  
}

SNOWFLAKE.CORTEX.FINETUNE**(**'SHOW')

SNOWFLAKE.CORTEX.FINETUNE**(**  
  'CANCEL',  
  '\<finetune\_job\_id\>'  
)

### Cortex Agent

### Vector Functions

With python, we can just use lists  
**values \= \[(\[1.1, 2.2, 3\], \[1, 1, 1\]), (\[1, 2.2, 3\], \[4, 6, 8\])\]**  
**for row in values:**  
        **cur.execute(f"""**  
            **INSERT INTO vectors(a, b)**  
                **SELECT {row\[0\]}::VECTOR(FLOAT,3), {row\[1\]}::VECTOR(FLOAT,3)**  
        **""")**

***\# Compute the pairwise inner product between columns a and b***  
**cur.execute("SELECT VECTOR\_INNER\_PRODUCT(a, b) FROM vectors")**  
**print(cur.fetchall())**

#### VECTOR\_INNER\_PRODUCT

Magnitude sensitive  
VECTOR\_INNER\_PRODUCT**(** \<vector\>, \<vector\> )  
(can over-index on “popular” things)  
**INSERT** **INTO** vectors **SELECT** **\[**1**,**2**.**2**,**3**\]::VECTOR(FLOAT,**3**),** **\[**4**,**6**,**8**\]::VECTOR(FLOAT,**3**);**

\-- Compute the pairwise inner product between columns a and b  
**SELECT** VECTOR\_INNER\_PRODUCT**(**a**,** b**)** **FROM** vectors**;**

#### VECTOR\_COSINE\_SIMILARITY

Best when vector length doesn’t matter, just direction, but very good in high dimensional spaces  
**SELECT** a**,** VECTOR\_COSINE\_SIMILARITY**(**a**,** **\[**1**,**2**,**3**\]::VECTOR(FLOAT,** 3**))** **AS** similarity  
    **FROM** vectors  
**ORDER** **BY** similarity **DESC**  
**LIMIT** 1**;**

#### VECTOR\_L1\_DISTANCE

Manhattan distance of 2 vectors (stair step)  
Not great if data is already normalized  
Magnitude sensitive

#### VECTOR\_L2\_DISTANCE

#### Euclidean distance of 2 vectors (diagonal)

Not great if data is already normalized  
Magnitude sensitive

### Helper Functions

#### COUNT\_TOKENS

Returns number of tokens  
SNOWFLAKE.CORTEX.COUNT\_TOKENS**(** \<model\_name\> , \<input\_text\> )

#### TRY\_COMPLETE

General purpose  
Same a complete, but returns null instead of an error  
SNOWFLAKE.CORTEX.TRY\_COMPLETE**(** \<model\>, \<prompt\_or\_history\> \[ , \<options\> \] )

#### SPLIT\_TEXT\_RECURSIVE\_CHARACTER

Chunk strings for search workflows. Recursive until all chunks are smaller than “chunk\_size”  
SNOWFLAKE.CORTEX.SPLIT\_TEXT\_RECURSIVE\_CHARACTER **(**  
  '\<text\_to\_split\>',  
  '\<format\>',  
  \<chunk\_size\>,  
  \[ \<overlap\> \],  
  \[ \<separators\> \]  
)

### **SELECT** SNOWFLAKE.CORTEX.SPLIT\_TEXT\_RECURSIVE\_CHARACTER **(**'hello world are you here'**,**'none'**,**15**,**10**);**

### \['hello world are', 'world are you', 'are you here'\]

### 

Splits the text into chunks of 15 characters each, with an overlap of 10 characters between chunks.

Formats:

- none: No format-specific separators. Only the separators in the separators field are used for splitting.  
- markdown: Separates on headers, code blocks, and tables, in addition to any separators in the separators field.

Separators default: \[”\\n\\n”, “\\n”, “ “, “”\], meaning a paragraph break, a line break, a space, and between any two characters (the empty string).

### Choosing a model

**Capability** \- Large/”Thinking” Models  
**Latency** \- Small  models faster  
**Cost** \- Small Models (and number total tokens)

## Perform Data Analysis Given Use Case

### Unstructured Data

#### AI\_PARSE\_DOCUMENT / CORTEX PARSE\_DOCUMENT

OCR vs LAYOUT depending on the scenarios  
(layout to get table data \+ preserve formatting)

Considerations:

- Cost based on pages (different for diff file formats, ex: image \= page)  
- Layout typically preferred (complex documents, retrieval systems, etc..)  
- OCR for quick, high quality extraction, scanned documents

### Structured Data

### Cortex Analyst

Need to know yaml format well for the Semantic model  
(capability vs latency vs cost)

Considerations For Semantic Models

- Create separate models for different domains or topics  
- Minimize tables and columns used  
- Wide tables \> long tables  
- 2 MB size limit on the semantic model 

#### Cortex Analyst Verified Query Repository (VQR) 

- Improve accuracy \+ trustworthiness  
- 

#### Integration With Cortex Search \- 

- RAG over data  
- Does incur additional storage \+ compute costs  
- Best for higher cardinality (\>10 distinct values), otherwise can use built in search

**CREATE** **OR** **REPLACE** **CORTEX SEARCH SERVICE** my\_logical\_dimension\_search\_service  
  **ON** my\_dimension  
  **WAREHOUSE** **\=** **xsmall**  
  **TARGET\_LAG** **\=** '1 hour'  
  **AS** **(**  
      **SELECT** **DISTINCT** my\_dimension **FROM** my\_logical\_dimension\_landing\_table  
  **);\`**  
**Usage:**  
**tables:**

  **\-** **name:** my\_table

    **base\_table:**  
      **database:** my\_database  
      **schema:** my\_schema  
      **table:** my\_table

    **dimensions:**  
      **\-** **name:** my\_dimension  
        **expr:** my\_column  
        **cortex\_search\_service:**  
          **service:** my\_logical\_dimension\_search\_service  
          **literal\_column:** my\_column     *\# optional*  
          **database:** my\_search\_database  *\# optional*  
          **schema:** my\_search\_schema      *\# optional*

#### Cortex Analyst Suggested Questions

- Automatically suggests new VQR queries  
- Suggested based on  \- high frequency and novelty

#### Cortex Analyst Custom Instructions

- custom\_instructions field  
- Best Practices  
  - Be Specific  
  - Start Small  
  - Preview Generated SQL Query  
  - Iterate Gradually  
- module\_custom\_instructions key in the top level of your semantic model to define custom instructions for specific components in the SQL generation pipeline. Supports:  
  - question\_categorization: Define how Cortex Analyst should classify user questions (for example, by blocking certain topics or guiding user behavior).  
  - sql\_generation: Specify how SQL should be generated (for example, data formatting and filtering).

![][image1]

*\# Name and description of the semantic model.*  
**name:** \<name\>  
**description:** \<string\>  
**comments:** \<string\>

*\# Logical table-level concepts*

*\# A semantic model can contain one or more logical tables.*  
**tables:**

  *\# A logical table on top of a base table.*  
  **\-** **name:** \<name\>  
    **description:** \<string\>

    *\# The fully qualified name of the base table.*  
    **base\_table:**  
      **database:** \<database\>  
      **schema:** \<schema\>  
      **table:** \<base table name\>

    *\# Dimension columns in the logical table.*  
    **dimensions:**  
      **\-** **name:** \<name\>  
        **synonyms:** \<array of strings\>  
        **description:** \<string\>

        **expr:** \<SQL expression\>  
        **data\_type:** \<data type\>  
        **unique:** \<boolean\>  
        **cortex\_search\_service:**  
          **service:** \<string\>  
          **literal\_column:** \<string\>  
          **database:** \<string\>  
          **schema:** \<string\>  
        **is\_enum:** \<boolean\>

    *\# Time dimension columns in the logical table.*  
    **time\_dimensions:**  
      **\-** **name:** \<name\>  
        **synonyms:**  \<array of strings\>  
        **description:** \<string\>

        **expr:** \<SQL expression\>  
        **data\_type:** \<data type\>  
        **unique:** \<boolean\>

    *\# Fact columns in the logical table.*  
    **facts:**  
      **\-** **name:** \<name\>  
        **synonyms:** \<array of strings\>  
        **description:** \<string\>  
        **access\_modifier:** \< public\_access | private\_access \>  *\# Supported only for semantic views.*  
                                                             *\# Default is public\_access.*

        **expr:** \<SQL expression\>  
        **data\_type:** \<data type\>

    *\# Regular metrics scoped to the logical table.*  
    **metrics:**  
      **\-** **name:** \<name\>  
        **synonyms:** \<array of strings\>  
        **description:** \<string\>  
        **access\_modifier:** \< public\_access | private\_access \>  *\# Supported only for semantic views.*  
                                                             *\# Default is public\_access.*

        **expr:** \<SQL expression\>

    *\# Commonly used filters over the logical table.*  
    **filters:**  
      **\-** **name:** \<name\>  
        **synonyms:** \<array of strings\>  
        **description:** \<string\>

        **expr:** \<SQL expression\>

*\# Model-level concepts*

*\# Relationships between logical tables*  
**relationships:**  
  **\-** **name:** \<string\>

    **left\_table:** \<table\>  
    **right\_table:** \<table\>  
    **relationship\_columns:**  
      **\-** **left\_column:** \<column\>  
        **right\_column:** \<column\>  
      **\-** **left\_column:** \<column\>  
        **right\_column:** \<column\>  
    *\# For semantic views, do not specify*  
    *\# join\_type or relationship\_type.*  
    **join\_type:** \<left\_outer | inner\>  
    **relationship\_type:** \< one\_to\_one | many\_to\_one \>

*\# Derived metrics scoped to the semantic view.*  
*\# Derived metrics are supported only for semantic views.*  
**metrics:**  
  **\-** **name:** \<name\>  
    **synonyms:** \<array of strings\>  
    **description:** \<string\>  
    **access\_modifier:** \< public\_access | private\_access \>  *\# Default is public\_access*

    **expr:** \<SQL expression\>

*\# Additional context concepts*

*\#  Verified queries with example questions and queries that answer them*  
**verified\_queries:**  
  **\-** **name:**        *\# A descriptive name of the query.*

    **question:**    *\# The natural language question that this query answers.*  
    **verified\_at:** *\# Optional: Time (in seconds since the UNIX epoch, January 1, 1970\) when the query was verified.*  
    **verified\_by:** *\# Optional: Name of the person who verified the query.*  
    **use\_as\_onboarding\_question:**  *\# Optional: Marks this question as an onboarding question for the end user.*  
    **sql:**                         *\# The SQL query for answering the question*

Example semantic view yaml:  
[https://docs.snowflake.com/en/\_downloads/6a9e323e0ad534fa8b561fcb0665bcbd/snow\_tpch.yaml](https://docs.snowflake.com/en/_downloads/6a9e323e0ad534fa8b561fcb0665bcbd/snow_tpch.yaml)

### Performance Considerations

- Latency (fine-tuning, model size, etc…)

Recommended using a warehouse size no larger than MEDIUM when calling Snowflake Cortex AI Functions

## Build Chat Interface to Interact With Data

Cortex analyst use case vs Custom API 

- Structured data, natural language questions, multiple turns \-\> cortex analyst  
- Custom app \-\> cortex accessed through rest api

### Setup The Snowflake Environment

### Invoke Cortex Functions Within Application Code

### Chat Conversations

- Multi-Turn Architecture  
- Update Parameters

## Use Snowflake Cortex In Data Pipeline

### Snowflake Cortex

Pipeline \- Arrange state in the correct order

- Load to stage, parse document, chunk text, embedings, vector search

## Run 3rd Party Models In Snowflake

### Using Snowpark Container Services

If model is **not available** in Snowflake Cortex, must use docker container \+ compute pool (SPCS)

- Environment Setup  
- Docker Images  
- Specification Files  
- Create Compute Pool  
- Create Image Repository

### Snowflake Model Registry

UI Docs (images): [https://docs.snowflake.com/en/developer-guide/snowflake-ml/model-registry/snowsight-ui](https://docs.snowflake.com/en/developer-guide/snowflake-ml/model-registry/snowsight-ui)

ML models \-\> Model Registry  
Custom LLMs run on SPCS

- Logging The Model  
  - **from** **snowflake.ml.model** **import** task**,** type\_hints  
  - mv \= reg.log\_model**(**clf**,**  
  -                    model\_name\="my\_model"**,**  
  -                    version\_name\="v1"**,**  
  -                    conda\_dependencies\=**\[**"scikit-learn"**\],**  
  -                    comment\="My awesome ML model"**,**  
  -                    metrics\=**{**"score"**:** 96**},**  
  -                    sample\_input\_data\=train\_features**,**  
  -                    task\=task.Task.TABULAR\_BINARY\_CLASSIFICATION**)**  
- Calling The Model  
  - remote\_prediction \= mv.run**(**test\_features**,** function\_name\="predict"**)**  
  - remote\_prediction.show**()**   *\# assuming test\_features is Snowpark DataFrame*  
  - 
