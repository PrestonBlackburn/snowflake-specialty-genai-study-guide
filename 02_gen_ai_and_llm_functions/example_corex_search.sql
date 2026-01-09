--------------- Standard Usage --------------------
-- Generate sample data
CREATE OR REPLACE TABLE business_directory (name TEXT, address TEXT, description TEXT);
INSERT INTO business_directory VALUES
    ('Joe''s Coffee', '123 Bean St, Brewtown','A cozy café known for artisan espresso and baked goods.'),
    ('Sparkle Wash', '456 Clean Ave, Sudsville', 'Eco-friendly car wash with free vacuum service.'),
    ('Tech Haven', '789 Circuit Blvd, Siliconia', 'Computer store offering the latest gadgets and tech repair services.'),
    ('Joe''s Wash n'' Fold', '456 Apple Ct, Sudsville', 'Laundromat offering coin laundry and premium wash and fold services.'),
    ('Circuit Town', '459 Electron Dr, Sudsville', 'Technology store selling used computer parts at discounted prices.')
;

-- Create the Cortex Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE business_search_service
    TEXT INDEXES name, address
    VECTOR INDEXES description (model='snowflake-arctic-embed-m-v1.5')
    WAREHOUSE = mywh
    TARGET_LAG = '1 hour'
    AS ( SELECT * FROM business_directory );


-------------- Using Custom Embeddings ------------------
-- Generate sample data
CREATE OR REPLACE TABLE business_documents (
  document_contents VARCHAR
);

INSERT INTO business_documents VALUES
  ('Quarterly financial report for Q1 2024: Revenue increased by 15%, with expenses stable. Highlights include strategic investments in marketing and technology.'),
  ('IT manual for employees: Instructions for usage of internal technologies, including hardware and software guides and commonly asked tech questions.'),
  ('Employee handbook 2024: Updated policies on remote work, health benefits, and company culture initiatives.'),
  ('Marketing strategy document: Target audience segmentation for upcoming product launch.');

-- Add managed vector embeddings
ALTER TABLE business_documents ADD COLUMN document_embeddings VECTOR(FLOAT, 768);
UPDATE business_documents SET document_embeddings = AI_EMBED('snowflake-arctic-embed-m-v1.5', document_contents);

-- Create the Cortex Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE managed_vector_search_service
  TEXT INDEXES document_contents
  VECTOR INDEXES document_embedding(query_model='snowflake-arctic-embed-m-v1.5')
  WAREHOUSE = mywh
  TARGET_LAG = '1 minute'
  AS SELECT * FROM business_documents;