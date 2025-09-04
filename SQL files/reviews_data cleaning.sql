-- A DATA CLEANING PROJECT BY:
-- Usha Nicole C. Cobrado

-- ASSUME THAT:
-- We don't know the data types contained in the table
-- We can only discover said data types during data cleaning

CREATE TABLE goodreads_reviews (
	review_id TEXT PRIMARY KEY,
	user_id TEXT,
	work_id TEXT,
	CONSTRAINT fk_work_id FOREIGN KEY (work_id) REFERENCES goodreads_works(work_id),
	started_at TEXT,
	read_at TEXT,
	date_added TEXT,
	rating TEXT,
	review_text TEXT,
	n_votes TEXT,
	n_comments TEXT
);

SELECT *
FROM goodreads_reviews;

SELECT review_id
FROM goodreads_reviews;

SELECT DISTINCT review_id
FROM goodreads_reviews
WHERE review_id IS NULL OR review_id IN ('null','',' ');

SELECT DISTINCT review_id
FROM goodreads_reviews
WHERE review_id LIKE '%  %';

SELECT user_id
FROM goodreads_reviews;

SELECT DISTINCT user_id
FROM goodreads_reviews
WHERE user_id IS NULL OR user_id IN ('null','',' ');

SELECT DISTINCT user_id
FROM goodreads_reviews
WHERE user_id LIKE '%  %';

SELECT work_id
FROM goodreads_reviews;

SELECT DISTINCT work_id
FROM goodreads_reviews
WHERE work_id IS NULL OR work_id IN ('null','',' ');

SELECT DISTINCT work_id
FROM goodreads_reviews
WHERE work_id LIKE '%  %';

SELECT started_at
FROM goodreads_reviews;

-- date without proper time detected
-- should just be a date value
SELECT DISTINCT started_at
FROM goodreads_reviews;

-- '' values detected
SELECT DISTINCT started_at
FROM goodreads_reviews
WHERE started_at IS NULL OR started_at IN ('null','',' ');

SELECT DISTINCT started_at
FROM goodreads_reviews
WHERE started_at LIKE '%  %';

SELECT DISTINCT
	CASE
		WHEN started_at = '' THEN NULL
		ELSE started_at::DATE
	END AS cleaned,
	started_at
FROM goodreads_reviews;

UPDATE goodreads_reviews
SET started_at = 
	CASE
		WHEN started_at = '' THEN NULL
		ELSE TRIM(started_at)
	END;

ALTER TABLE goodreads_reviews
ALTER COLUMN started_at TYPE DATE USING started_at::DATE;

SELECT started_at
FROM goodreads_reviews;

SELECT *
FROM goodreads_reviews;

SELECT read_at
FROM goodreads_reviews;

-- date without proper time detected
-- should just be a date value
SELECT DISTINCT read_at
FROM goodreads_reviews;

-- '' values detected
SELECT DISTINCT read_at
FROM goodreads_reviews
WHERE read_at IS NULL OR read_at IN ('null','',' ');

SELECT DISTINCT
	CASE
		WHEN read_at = '' THEN NULL
		ELSE read_at::DATE
	END AS cleaned,
	read_at
FROM goodreads_reviews;

UPDATE goodreads_reviews
SET read_at =
	CASE
		WHEN read_at = '' THEN NULL
		ELSE TRIM(read_at)
	END;

ALTER TABLE goodreads_reviews
ALTER COLUMN read_at TYPE DATE USING read_at::DATE;

SELECT read_at
FROM goodreads_reviews;

SELECT *
FROM goodreads_reviews;

SELECT date_added
FROM goodreads_reviews;

-- no NULL values detected
SELECT DISTINCT date_added
FROM goodreads_reviews
WHERE date_added IS NULL OR date_added IN ('null','',' ','NA','N/A');

SELECT DISTINCT 
	date_added::DATE AS cleaned,
	date_added
FROM goodreads_reviews;

ALTER TABLE goodreads_reviews
ALTER COLUMN date_added TYPE DATE USING date_added::DATE;

SELECT date_added
FROM goodreads_reviews;

SELECT *
FROM goodreads_reviews;

SELECT rating
FROM goodreads_reviews;

SELECT DISTINCT rating
FROM goodreads_reviews;

-- NULL value detected
-- will leave it NULL since rating is as 0 will affect the result of aggregate calculations
-- these are text values and must be converted to integers for calculation purposes
SELECT DISTINCT rating
FROM goodreads_reviews
WHERE rating IS NULL OR rating IN ('null','',' ');

SELECT DISTINCT rating::INTEGER AS cleaned, rating
FROM goodreads_reviews;

ALTER TABLE goodreads_reviews
ALTER COLUMN rating TYPE INTEGER USING rating::INTEGER;

SELECT DISTINCT rating
FROM goodreads_reviews;

SELECT review_text
FROM goodreads_reviews;

-- these are text values, must convert to integer
SELECT DISTINCT review_text
FROM goodreads_reviews;

-- NULL values detected
-- will leave it NULL since if I put something, others will think what I wrote is the user's review of the book
SELECT DISTINCT review_text
FROM goodreads_reviews
WHERE review_text IS NULL OR review_text IN ('null','',' ');

SELECT DISTINCT review_text
FROM goodreads_Reviews
WHERE review_text LIKE '%  %';

SELECT n_votes
FROM goodreads_reviews;

-- contains negative values, which are considered downvotes
-- downvotes indicate the number of users who disagree with a review
-- these are text values, must convert to integer
SELECT DISTINCT n_votes
FROM goodreads_reviews

SELECT DISTINCT n_votes
FROM goodreads_reviews
WHERE n_votes IS NULL OR n_votes IN ('null','',' ');

SELECT DISTINCT n_votes
FROM goodreads_reviews
WHERE n_votes LIKE '%  %';

SELECT DISTINCT n_votes::INTEGER AS cleaned, n_votes
FROM goodreads_reviews;

ALTER TABLE goodreads_reviews
ALTER COLUMN n_votes TYPE INTEGER USING n_votes::INTEGER;

SELECT DISTINCT n_votes
FROM goodreads_reviews;

SELECT n_comments
FROM goodreads_reviews;

-- the number of comments left by other users on the review
-- contains negative values, which doesn't make sense
-- will convert this to NULL values
-- also, these are text values which must be converted to integers
SELECT DISTINCT n_comments
FROM goodreads_reviews;

SELECT n_comments
FROM goodreads_reviews
WHERE n_comments = '-1';

SELECT DISTINCT
	CASE
		WHEN n_comments = '-1' THEN NULL
		ELSE TRIM(n_comments)
	END AS cleaned,
	n_comments
FROM goodreads_reviews;

UPDATE goodreads_reviews
SET n_comments = 
	CASE
		WHEN n_comments = '-1' THEN NULL
		ELSE TRIM(n_comments)
	END;

ALTER TABLE goodreads_reviews
ALTER COLUMN n_comments TYPE INTEGER USING n_comments::INTEGER;

SELECT DISTINCT n_comments
FROM goodreads_reviews;

SELECT *
FROM goodreads_reviews;