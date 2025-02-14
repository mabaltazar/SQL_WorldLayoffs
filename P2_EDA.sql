-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY company
ORDER BY laid_off_total DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY industry
ORDER BY laid_off_total DESC;

SELECT country, SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY country
ORDER BY laid_off_total DESC;

SELECT *
FROM layoffs_staging2;

SELECT YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC
)
SELECT `Month`, total_laid_off,
SUM(total_laid_off) OVER (ORDER BY `Month`) AS running_total
FROM Rolling_total;


SELECT company, SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY company
ORDER BY laid_off_total DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY laid_off_total DESC;

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS laid_off_total
FROM layoffs_staging2
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
WHERE ranking <= 5;