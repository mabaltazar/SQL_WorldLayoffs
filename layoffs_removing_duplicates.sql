-- DATA CLEANING

/*
Steps to clean the data!
1. Remove duplicate records
2. Standardize the data
3. Remove NULL and/or blank values
*/

-- STEP 1: Remove duplicates

-- First, let's check the data!
SELECT *
FROM world_layoffs.layoffs;

-- Let's create a staging table. We'll use this one to clean the data. Let's leave the raw data alone in case something happens.
CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;

INSERT layoffs_staging
SELECT *
FROM world_layoffs.layoffs;

-- Let's check if the staging table was created sucessfully.
SELECT *
FROM world_layoffs.layoffs_staging;

-- Let's check for duplicate records. We'll use all the columns to check for any duplicate records.
-- We'll create a new column and name it row_num to easily identify the duplicate records.

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

-- Let's filter the row_num column to see the duplicate records.
WITH DUP_CTE AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging
)
SELECT *
FROM DUP_CTE
WHERE row_num > 1;

-- Check individual records to see if it is indeed a duplicate record
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Casper';


-- Did not work, error code 1288. The target table DELETE_CTE of the DELETE is not updatable.
WITH DELETE_CTE AS
(
SELECT *
FROM 
	(
    SELECT *,
    ROW_NUMBER() OVER ( PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM 
		world_layoffs.layoffs_staging
	) duplicates
WHERE row_num > 1
)
DELETE 
FROM DELETE_CTE;


-- Let's create a new staging table and add a row_num column 
CREATE TABLE `world_layoffs`.`layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Now we insert all the data from the layoffs and the code for the duplicate records.
INSERT INTO world_layoffs.layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

-- Let's check if it worked
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

-- Let's delete the duplicate records
DELETE
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

-- Let's check our duplicates earlier if only one record have been deleted
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Cazoo';



