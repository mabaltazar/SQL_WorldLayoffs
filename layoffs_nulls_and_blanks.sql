-- Step 3: Remove NULL and/or Blank values

-- Let's check which columns has NULL and blank values
SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company IS NULL
OR company = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE location IS NULL
OR location = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- We know from standardizing data that we can populate the blank values in industry column.
-- We can use the information from the same companies to populate the blank industry

-- Let's first update the blank values to null values
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Let's check if it was updated
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Now we can populate the null values using the information from the same companies
-- Let's check if company and location is the same so we can correctly populate the industry
SELECT t1.company, t1.location, t2.company, t2.location, t1.industry, t2.industry
FROM world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- We can now update the industry 
UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Only the Bally's company has NULL value. Since there is no other information from Bally's company we were not able to populate the industry
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Let's now check the next column
SELECT *
FROM world_layoffs.layoffs_staging2;

-- We can remove this since we really can't use the data for our EDA
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
-- WHERE percentage_laid_off IS NULL;
AND percentage_laid_off IS NULL;

DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Remove the row_num column 
ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

-- Let's see the final table
SELECT *
FROM world_layoffs.layoffs_staging2;