use role public;

-------- COMPLETE ---------
-- Basic example
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'openai-gpt-4.1',
    CONCAT('Critique this review in bullet points: <review>', content,'</review>')
) FROM (SELECT 'This film sucked' as content);
-- ex results:
-- - The review is extremely brief and lacks detail.
-- - It does not explain why the reviewer disliked the film.
-- - There are no specific examples or evidence to support the negative opinion.
-- - The language is informal and dismissive, which may not be helpful to other readers.
-- - The review does not mention any aspects of the film (acting, plot, direction, etc.).
-- - It fails to provide constructive feedback or suggestions for improvement.
-- - Overall, the review is uninformative and does not help others decide whether to watch the film.

-- More complex example with options:
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'claude-4-sonnet',
    [
        {
            'role': 'user',
            'content': 'What is the largest known object in the uninvers?'
        }
    ],
    {
        'temperature': 0.7,
        'max_tokens': 100
    }
);

-- ex results:
-- {
--   "choices": [
--     {
--       "messages": "The largest known object in the universe is **IC 1101**, a supergiant elliptical galaxy located about 1 billion light-years away in the constellation Virgo.\n\nIC 1101 has a diameter of approximately **6 million light-years** - that's about 60 times larger than our Milky Way galaxy! It contains an estimated 100 trillion stars (compared to the Milky Way's 200-400 billion stars"
--     }
--   ],
--   "created": 1767903109,
--   "model": "claude-4-sonnet",
--   "usage": {
--     "completion_tokens": 100,
--     "prompt_tokens": 18,
--     "total_tokens": 118
--   }
-- }


-- Complete can also be used with prompt objects, which can be useful for images
SELECT PROMPT('Hello, {0}! Today is {1}.', 'Alice', 'Monday');
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'claude-4-sonnet',
    PROMPT('Hello, {0}! Today is {1}.', 'Alice', 'Monday')
);
-- ex results:
-- Hello! I'm actually Claude, not Alice - I'm an AI assistant made by Anthropic. Nice to meet you though! How are you doing this Monday?

--------- CLASSIFY_TEXT -------------
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT('The movie sucked', ['good', 'neutral', 'bad']);
-- ex results:
-- {
--   "label": "bad"
-- }

-- We can also provide more detail about the labels
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
    'the first Matrix was better',
    [{
        'label': 'bad',
        'description': 'expresses a negative sentiment in the review', 
        'examples': ['this film sucks']
    },{
        'label': 'good',
        'description': 'expresses a possitive sentiment',
        'examples': ['best film ever']
    }
    ],
    {'task_description': 'return the sentiment of the review'}
);
-- ex results:
-- {
--   "label": "bad"
-- }

-- The AI_CLASSIFY replaces the CLASSIFY_TEXT function and supports multi-label
SELECT AI_CLASSIFY('One day I will see the world', ['travel', 'cooking']);
SELECT AI_CLASSIFY(
  'One day I will see the world and learn to cook my favorite dishes',
  ['travel', 'cooking', 'reading', 'driving'],
  {'output_mode': 'multi'}
);


------------- EXTRACT_ANSWER  ----------------
SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER('the dark knight is the best movie', 'what is the best movie?');
-- [
--   {
--     "answer": "dark knight",
--     "score": 2.723971300000000e-10
--   }
-- ]

------------- PARSE_DOCUMENT -----------------

-- skip since we would need to load a document to a stage to parse


--------------  SENTIMENT ---------------------
SELECT SNOWFLAKE.CORTEX.SENTIMENT('A tourists delight, in low urban light,
  Recommended gem, a pizza night sight. Swift arrival, a pleasure so right,
  Yet, pockets felt lighter, a slight pricey bite. 💰🍕🚀');
  -- ex results:
  -- 0.515625

---------------- SUMMARIZE -------------------
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(review_content) from (SELECT 'That book sucked' as review_content);
-- content too short to summarize, ex -
-- That book sucked


--------------- TRANSLATE ---------------------
SELECT SNOWFLAKE.CORTEX.TRANSLATE('hola', 'es', 'en');
-- hi


-------------- TEXT_EMBED_768 ---------------------
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'Embed me plz');


-------------- TEXT_EMBED_1024 ----------------------
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_1024('nv-embed-qa-4', 'embed me plz');



---------------  COUNT_TOKENS -------------------
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('snowflake-arctic-embed-m', 'embed me plz'); -- 7
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('llama3-8b', 'embed me plz'); -- 4

--- Doesn't Support Closed Source Models, ex: --
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('openai-gpt-4.1', 'embed me plz');
-- fails


------------ SPLIT_TEXT_RECURSIVE_CHARACTER ------------------

SELECT SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
    'plz no, dont split me up',
    'none',
    15, -- chunk size (char)
    5   --overlap
);