-- Exploratory Data Analysis
-- Just exploring the data and see what we find

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Let's check highest number of laid off and highest percentage
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Highest and lowest percentage laid off
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of the company laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- If we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Let's check which company has the highest laid off
SELECT company, SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY laid_off_total DESC;

-- Let's check which company has the highest laid off and the percent
SELECT company, SUM(total_laid_off) AS laid_off_total, SUM(percentage_laid_off) AS percent_laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY laid_off_total DESC;

-- Total laid off per industry
SELECT industry, SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY laid_off_total DESC;

-- Total laid off per country
SELECT country, SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY laid_off_total DESC;

-- Total laid off per year
SELECT YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

-- Total laid off per month
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC;

-- Let's see the rolling total of laid offs
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC
)
SELECT `Month`, total_laid_off,
SUM(total_laid_off) OVER (ORDER BY `Month`) AS running_total
FROM Rolling_total;

-- Let's check the total laid off per year
SELECT company, YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY laid_off_total DESC;

-- The 5 highest laid offs per year
WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
),
company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

