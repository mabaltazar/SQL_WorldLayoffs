-- Step 2: Standardize the data

-- Let's review the data again
SELECT *
FROM world_layoffs.layoffs_staging2;

-- Let's check on the company column first
SELECT company, LENGTH(company), TRIM(company), LENGTH(TRIM(company))
FROM world_layoffs.layoffs_staging2;
-- WHERE LENGTH(company) > LENGTH(TRIM(company));

-- There are couple of unecessary spaces in some of the company names. We'll update the column to remove the spaces.
UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

-- We've updated the company column, next we check on location column
SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT location, LENGTH(location), TRIM(location), LENGTH(TRIM(location))
FROM world_layoffs.layoffs_staging2
-- WHERE LENGTH(location) > LENGTH(TRIM(location))
ORDER BY location;

-- location column seems good. Let's move on to the next column
SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT industry, LENGTH(industry), TRIM(industry), LENGTH(TRIM(industry))
FROM world_layoffs.layoffs_staging2
-- WHERE LENGTH(industry) > LENGTH(TRIM(industry))
ORDER BY industry;

-- No problem with spaces. But we can see some null and blank values
-- There is also the Crypto industry, there are different variations but we can standardize the name
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Let's use Crypto and standardize the name
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Now let's check on the null and blank value
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- Let's take a look at these blank and null values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Airbnb%'; 

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%'; 

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Carvana%'; 

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Juul%'; 

-- Except for Bally's, I think we can populate the blank values for the others as there are siimilar company's which industry is populated.
-- We'll leave the blank and null values for now and move on to standardizing our data

-- Let's check our next column
SELECT *
FROM world_layoffs.layoffs_staging2;

-- The total_laid_off and percentage_laid_off columns look normal. We can skip this for now and move on to the date column
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;

-- Let's update the dates to proper date
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- We can now convert the data type properly
ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Let's check our next column
SELECT *
FROM world_layoffs.layoffs_staging2;

-- Let's review if there's anything we need to update
SELECT DISTINCT stage
FROM world_layoffs.layoffs_staging2; 

-- It seems good except for NULL values. Let's check
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE stage IS NULL;

-- Let's check individually if we can update
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Zapp';

-- It seems we will not be able to populate the null values in stage column. Let's proceed with the next column
SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

SELECT country, LENGTH(country), TRIM(country), LENGTH(TRIM(country))
FROM world_layoffs.layoffs_staging2
WHERE LENGTH(country) > LENGTH(TRIM(country));

-- Looks good except for the united states. There's 2 record and one has "." at the end.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY country;

-- Let's remove the "." from the other record.
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Let's check our data
SELECT *
FROM world_layoffs.layoffs_staging2;