# 💼 Layoff Data Exploration Project
This project focuses on cleaning and exploring a global layoff dataset using structured SQL techniques. The goal is to transform messy, inconsistent data into a reliable foundation for insight generation—identifying trends in company layoffs across industries, countries, and time.  

🎯 Objective
- Remove duplicate records, standardize column entries, and handle missing or blank values
- Normalize dates, locations, industries, and numeric types for consistency
- Explore aggregated layoff trends by company, sector, region, and year
- Use SQL window functions to calculate rolling totals and yearly rankings  

🧰 Tools Used
- - SQL (MySQL / SQL Server)
- Common Table Expressions (CTEs)
- Window Functions: ROW_NUMBER(), DENSE_RANK(), OVER()
- String Functions: TRIM(), SUBSTRING(), REPLACE()
- Date Parsing: STR_TO_DATE(), YEAR()
- Data Source: Custom-imported layoff dataset in a world_layoffs schema

⚙️ Steps Taken
- Created Staging Tables to isolate and clean raw data
- Removed duplicate records using ROW_NUMBER() and deleted flagged rows
- Standardized text fields (trimming whitespace, fixing country and industry names)
- Formatted date column into proper DATE type using STR_TO_DATE()
- Imputed missing industry values using self-joins on company + location
- Deleted records with unusable NULL values
- Explored temporal trends by year, month, and rolling cumulative totals
- Ranked top companies per year by layoff volume using DENSE_RANK()

🗂️ Dataset
- You can find the dataset [here](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- Fields include: company, industry, location, total_laid_off, percentage_laid_off, date, country, funds_raised_millions, etc.
