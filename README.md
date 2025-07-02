# 💼 Layoff Data Exploration Project
This project features end-to-end data cleaning and exploratory analysis on global layoff data using SQL. The goal was to uncover patterns in workforce reduction across industries, companies, and countries over time. The project also applies advanced SQL techniques to track temporal trends, remove duplicates, standardize messy entries, and evaluate the scale and progression of layoffs.

🎯 Objective
To clean and analyze layoff data by:
- Identifying key trends in layoffs across time and geography
- Profiling the most heavily affected companies and industries
- Applying SQL best practices for scalable and efficient exploration

🧰 Tools Used
- MySQL
- SQL Window Functions (ROW_NUMBER(), DENSE_RANK(), OVER)
- Common Table Expressions (CTEs)
- Text functions (TRIM(), SUBSTRING()), Aggregates
- Date Functions and STR_TO_DATE() for formatting
- Self-Joins for data enrichment

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
