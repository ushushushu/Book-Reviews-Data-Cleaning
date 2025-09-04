-- A DATA CLEANING PROJECT BY:
-- Usha Nicole C. Cobrado

-- ASSUME THAT:
-- We don't know the data types contained in the table
-- We can only discover said data types during data cleaning

CREATE TABLE goodreads_works (
	work_id TEXT PRIMARY KEY,
	isbn TEXT,
	isbn13 TEXT,
	original_title TEXT,
	author TEXT,
	original_publication_year TEXT,
	num_pages TEXT,
	description TEXT,
	genres TEXT,
	image_url TEXT,
	reviews_count TEXT,
	text_reviews_count TEXT,
	"5_star_ratings" TEXT,
	"4_star_ratings" TEXT,
	"3_star_ratings" TEXT,
	"2_star_ratings" TEXT,
	"1_star_ratings" TEXT,
	ratings_count TEXT,
	avg_rating TEXT,
	similar_books TEXT
);

SELECT *
FROM goodreads_works;

SELECT work_id
FROM goodreads_works;

-- No NULL values detected
SELECT DISTINCT work_id
FROM goodreads_works
WHERE work_id IS NULL OR work_id IN ('null','',' ');

SELECT isbn
FROM goodreads_works;

-- '' values detected
SELECT DISTINCT isbn
FROM goodreads_works
WHERE isbn IS NULL OR isbn IN ('null','',' ');

SELECT DISTINCT
	CASE
		WHEN isbn = '' THEN 'Unspecified'
		ELSE TRIM(isbn)
	END AS cleaned,
	isbn
FROM goodreads_works
WHERE isbn = '';

UPDATE goodreads_works
SET isbn = 
	CASE
		WHEN isbn = '' THEN 'Unspecified'
		ELSE TRIM(isbn)
	END;

SELECT isbn13
FROM goodreads_works;

-- NULL values detected
SELECT DISTINCT isbn13
FROM goodreads_works
WHERE isbn13 IS NULL OR isbn13 IN ('null','',' ');

SELECT DISTINCT
	CASE
		WHEN isbn13 IS NULL THEN 'Unspecified'
		ELSE TRIM(isbn13)
	END AS cleaned,
	isbn13
FROM goodreads_works
WHERE isbn13 IS NULL;

UPDATE goodreads_works
SET isbn13 =
	CASE
		WHEN isbn13 IS NULL THEN 'Unspecified'
		ELSE TRIM(isbn13)
	END;

SELECT original_title
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT original_title
FROM goodreads_works
WHERE original_title IS NULL OR original_title IN ('null','',' ');

-- dirty data detected:
-- 1. double spacing
-- 2. lack of spaces in separating certain words
-- 3. improper capitalization
SELECT DISTINCT original_title
FROM goodreads_works
WHERE original_title LIKE '%  %';

-- currently can't deal with books containing Japanese / Chinese titles
-- many of them have improper capitialization, but I don't know which ones should be small or large caps
SELECT DISTINCT
	CASE
		WHEN original_title LIKE '%  %' THEN REPLACE(regexp_replace(TRIM(REPLACE(REPLACE(original_title,'  ',' '),'  ',' ')),'([a-z])([A-Z])','\1 \2','g'),' ,',',')
		ELSE REPLACE(REPLACE(TRIM(original_title),'  ',' '),'  ',' ')
	END AS cleaned,
	original_title
FROM goodreads_works
WHERE original_title LIKE '%  %';

UPDATE goodreads_works
SET original_title =
	CASE
		WHEN original_title LIKE '%  %' THEN REPLACE(regexp_replace(TRIM(REPLACE(REPLACE(original_title,'  ',' '),'  ',' ')),'([a-z])([A-Z])','\1 \2','g'),' ,',',')
		ELSE REPLACE(REPLACE(TRIM(original_title),'  ',' '),'  ',' ')
	END;

SELECT author
FROM goodreads_works;

-- No NULL values detected
SELECT DISTINCT author
FROM goodreads_works
WHERE author IS NULL OR author IN ('null','',' ');

-- there are up to 8 spaces in between names
SELECT DISTINCT author
FROM goodreads_works
WHERE author LIKE '%        %';

SELECT DISTINCT
	CASE
		WHEN author LIKE '%  %' THEN TRIM(REPLACE(REPLACE(REPLACE(REPLACE(author,'  ',' '),'  ',' '),'  ',' '),'  ',' '))
		ELSE TRIM(author)
	END AS cleaned,
	author
FROM goodreads_works;

UPDATE goodreads_works
SET author =
	CASE
		WHEN author LIKE '%  %' THEN TRIM(REPLACE(REPLACE(REPLACE(REPLACE(author,'  ',' '),'  ',' '),'  ',' '),'  ',' '))
		ELSE TRIM(author)
	END;

SELECT *
FROM goodreads_works;

SELECT original_publication_year
FROM goodreads_works;

-- Negative values detected
-- Means that its original publication year is before the common era (BCE)
SELECT DISTINCT original_publication_year
FROM goodreads_works;

-- NULL values detected
SELECT DISTINCT original_publication_year
FROM goodreads_works
WHERE original_publication_year IS NULL OR original_publication_year IN ('null','',' ');

SELECT DISTINCT original_publication_year
FROM goodreads_works
WHERE original_publication_year LIKE '%  %';

SELECT DISTINCT
	CASE
		WHEN original_publication_year IS NULL THEN 'Unspecified'
		WHEN original_publication_year LIKE '-%' THEN TRIM(REPLACE(original_publication_year,'-','') || ' BCE')
		ELSE TRIM(original_publication_year)
	END AS cleaned,
	original_publication_year
FROM goodreads_works;

UPDATE goodreads_works
SET original_publication_year =
	CASE
		WHEN original_publication_year IS NULL THEN 'Unspecified'
		WHEN original_publication_year LIKE '-%' THEN TRIM(REPLACE(original_publication_year,'-','') || ' BCE')
		ELSE TRIM(original_publication_year)
	END;
	
SELECT num_pages
FROM goodreads_works;

SELECT DISTINCT num_pages
FROM goodreads_works;

-- NULL values detected
SELECT DISTINCT num_pages
FROM goodreads_works
WHERE num_pages IS NULL OR num_pages IN ('null','',' ');

SELECT DISTINCT num_pages
FROM goodreads_works
WHERE num_pages LIKE '%  %';

SELECT DISTINCT
	CASE
		WHEN num_pages IS NULL THEN 'Unspecified'
		ELSE TRIM(num_pages)
	END AS cleaned,
	num_pages
FROM goodreads_works;

UPDATE goodreads_works
SET num_pages =
	CASE
		WHEN num_pages IS NULL THEN 'Unspecified'
		ELSE TRIM(num_pages)
	END;

SELECT description
FROM goodreads_works;

SELECT DISTINCT description
FROM goodreads_works;

SELECT DISTINCT description
FROM goodreads_works
WHERE description IS NULL OR description IN ('null','',' ');

SELECT DISTINCT description
FROM goodreads_works
WHERE description LIKE '%  %';

SELECT DISTINCT
	CASE
		WHEN description = '' THEN 'No description given'
		ELSE TRIM(description)
	END AS cleaned,
	description
FROM goodreads_works;

UPDATE goodreads_works
SET description =
	CASE
		WHEN description = '' THEN 'No description given'
		ELSE TRIM(description)
	END;

SELECT genres
FROM goodreads_works;

-- improper capitalization detected
SELECT DISTINCT genres
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT genres
FROM goodreads_works
WHERE genres IS NULL OR genres IN ('null','',' ');

SELECT DISTINCT genres
FROM goodreads_works
WHERE genres LIKE '%  %';

SELECT DISTINCT 
	TRIM(INITCAP(genres)) AS cleaned,
	genres
FROM goodreads_works;

UPDATE goodreads_works
SET genres = TRIM(INITCAP(genres));

SELECT image_url
FROM goodreads_works;

SELECT DISTINCT image_url
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT image_url
FROM goodreads_works
WHERE image_url IS NULL OR image_url IN ('null','',' ');

SELECT DISTINCT image_url
FROM goodreads_works
WHERE image_url LIKE '%  %';

SELECT reviews_count
FROM goodreads_works;

SELECT DISTINCT reviews_count
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT reviews_count
FROM goodreads_works
WHERE reviews_count IS NULL OR reviews_count IN ('null','',' ');

SELECT DISTINCT reviews_count
FROM goodreads_works
WHERE reviews_count LIKE '%  %' OR reviews_count LIKE '-%' OR reviews_count LIKE '%.%' ;

SELECT DISTINCT reviews_count::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN reviews_count TYPE INTEGER USING reviews_count::INTEGER;

SELECT reviews_count
FROM goodreads_works;

SELECT reviews_count
FROM goodreads_works;

SELECT DISTINCT text_reviews_count
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT text_reviews_count
FROM goodreads_works
WHERE text_reviews_count IS NULL OR text_reviews_count IN ('null','',' ');

SELECT DISTINCT text_reviews_count
FROM goodreads_works
WHERE text_reviews_count LIKE '%  %' OR text_reviews_count LIKE '-%' OR text_reviews_count LIKE '%.%';

SELECT DISTINCT text_reviews_count::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN text_reviews_count TYPE INTEGER USING text_reviews_count::INTEGER;

SELECT text_reviews_count
FROM goodreads_works;

SELECT "5_star_ratings"
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT "5_star_ratings"
FROM goodreads_works
WHERE "5_star_ratings" IS NULL OR "5_star_ratings" IN ('null','',' ');

SELECT DISTINCT "5_star_ratings"
FROM goodreads_works
WHERE "5_star_ratings" LIKE '%  %' OR "5_star_ratings" LIKE '-%';

SELECT DISTINCT "5_star_ratings"::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN "5_star_ratings" TYPE INTEGER USING "5_star_ratings"::INTEGER;

SELECT "5_star_ratings"
FROM goodreads_works;

SELECT "4_star_ratings"
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT "4_star_ratings"
FROM goodreads_works
WHERE "4_star_ratings" IS NULL OR "4_star_ratings" IN ('null','',' ');

SELECT DISTINCT "4_star_ratings"
FROM goodreads_works
WHERE "4_star_ratings" LIKE '%  %' OR "4_star_ratings" LIKE '-%';

SELECT DISTINCT "4_star_ratings"::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN "4_star_ratings" TYPE INTEGER USING "4_star_ratings"::INTEGER;

SELECT "4_star_ratings"
FROM goodreads_works;

SELECT "3_star_ratings"
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT "3_star_ratings"
FROM goodreads_works
WHERE "3_star_ratings" IS NULL OR "3_star_ratings" IN ('null','',' ');

SELECT DISTINCT "3_star_ratings"
FROM goodreads_works
WHERE "3_star_ratings" LIKE '%  %' OR "3_star_ratings" LIKE '-%';

SELECT DISTINCT "3_star_ratings"::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN "3_star_ratings" TYPE INTEGER USING "3_star_ratings"::INTEGER;

SELECT "3_star_ratings"
FROM goodreads_works;

SELECT "2_star_ratings"
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT "2_star_ratings"
FROM goodreads_works
WHERE "2_star_ratings" IS NULL OR "2_star_ratings" IN ('null','',' ');

SELECT DISTINCT "2_star_ratings"
FROM goodreads_works
WHERE "2_star_ratings" LIKE '%  %' OR "2_star_ratings" LIKE '-%';

SELECT DISTINCT "2_star_ratings"::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN "2_star_ratings" TYPE INTEGER USING "2_star_ratings"::INTEGER;

SELECT "2_star_ratings"
FROM goodreads_works;

SELECT "1_star_ratings"
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT "1_star_ratings"
FROM goodreads_works
WHERE "1_star_ratings" IS NULL OR "1_star_ratings" IN ('null','',' ');

SELECT DISTINCT "1_star_ratings"
FROM goodreads_works
WHERE "1_star_ratings" LIKE '%  %' OR "1_star_ratings" LIKE '-%';

SELECT DISTINCT "1_star_ratings"::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN "1_star_ratings" TYPE INTEGER USING "1_star_ratings"::INTEGER;

SELECT "1_star_ratings"
FROM goodreads_works;

SELECT ratings_count
FROM goodreads_works;

-- no NULL values detected
SELECT DISTINCT ratings_count
FROM goodreads_works
WHERE ratings_count IS NULL OR ratings_count IN ('null','',' ');

SELECT DISTINCT ratings_count
FROM goodreads_works
WHERE ratings_count LIKE '%  %' OR ratings_count LIKE '-%';

SELECT DISTINCT ratings_count::INTEGER
FROM goodreads_works;

ALTER TABLE goodreads_works
ALTER COLUMN ratings_count TYPE INTEGER USING ratings_count::INTEGER;

SELECT ratings_count
FROM goodreads_works;

SELECT avg_rating
FROM goodreads_works;

-- float values detected
SELECT DISTINCT avg_rating
FROM goodreads_works
ORDER BY avg_rating;

-- no NULL values detected
SELECT DISTINCT avg_rating
FROM goodreads_works
WHERE avg_rating IS NULL OR avg_rating IN ('null','',' ');

SELECT DISTINCT avg_rating
FROM goodreads_works
WHERE avg_rating LIKE '%  %' OR avg_rating LIKE '-%';

SELECT DISTINCT avg_rating::DOUBLE PRECISION
FROM goodreads_works
ORDER BY avg_rating;

ALTER TABLE goodreads_works
ALTER COLUMN avg_rating TYPE DOUBLE PRECISION USING avg_rating::DOUBLE PRECISION;

SELECT avg_rating
FROM goodreads_works;

SELECT similar_books
FROM goodreads_works;

-- '' values detected
SELECT DISTINCT similar_books
FROM goodreads_works
WHERE similar_books IS NULL OR similar_books IN ('null','',' ');

SELECT DISTINCT similar_books
FROM goodreads_works
WHERE similar_books LIKE '%  %' OR similar_books LIKE '%,,%';

SELECT DISTINCT
	CASE
		WHEN similar_books = '' THEN 'None'
		ELSE TRIM(similar_books)
	END AS cleaned,
	similar_books
FROM goodreads_works
WHERE similar_books = '';

UPDATE goodreads_works
SET similar_books =
	CASE
		WHEN similar_books = '' THEN 'None'
		ELSE TRIM(similar_books)
	END;

SELECT *
FROM goodreads_works;