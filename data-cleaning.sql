-- 1. Removing Duplicates

SELECT * FROM layoffs;
-- Retrieve the original data.

CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
-- Create a new table to preserve the integrity of the original data.

SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num FROM layoffs_staging;
-- Assign a unique row number (row_num) to each record within specified groups.

WITH duplicate_cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
    FROM layoffs_staging
) 
SELECT * FROM duplicate_cte WHERE row_num > 1;
-- Select all duplicate records where row_num is greater than 1.

CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  date TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Create a new table named layoffs_staging2 with an additional row_num column.

INSERT INTO layoffs_staging2 
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging;
-- Insert records into layoffs_staging2, including the row_num column.

DELETE FROM layoffs_staging2 WHERE row_num > 1;
-- Remove duplicate entries by deleting rows with row_num greater than 1.

-- 2. Standardizing Values
SELECT DISTINCT(TRIM(company)) FROM layoffs_staging2;
-- Retrieve unique company names with extra whitespace removed.

UPDATE layoffs_staging2 SET company = TRIM(company);
-- Remove extra whitespace from the company names.

SELECT * FROM layoffs_staging2 WHERE industry LIKE 'Crypto%';
-- Find all rows where the industry starts with "Crypto" to identify variations.

UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
-- Standardize industry names to "Crypto" for entries starting with "Crypto".

SELECT DISTINCT industry FROM layoffs_staging2;
-- Retrieve unique industry names to check for inconsistencies.

SELECT DISTINCT country FROM layoffs_staging2 ORDER BY country;
-- List unique country names in alphabetical order.

UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';
-- Standardize country names to "United States" for variations starting with "United States".

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;
-- Preview the date format conversion for all date entries.

UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Update the date column to follow the `YYYY-MM-DD` format.

ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
-- Change the data type of the date column to DATE.

-- 3. Null and Blank Values
SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry = '';
-- Find rows where the industry field is empty or null.

UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';
-- Set empty industry fields to NULL for consistency.

SELECT * FROM layoffs_staging2 t1 JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
-- Find companies with a missing industry that have an entry with a populated industry field.

UPDATE layoffs_staging2 t1 JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
-- Update missing industry values by copying from matching company entries with an industry.

SELECT * FROM layoffs_staging2 WHERE company LIKE 'Bally%';
-- Retrieve rows with company names starting with "Bally" for inspection.

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- Identify rows with both `total_laid_off` and `percentage_laid_off` fields as NULL.

DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- Remove rows where both `total_laid_off` and `percentage_laid_off` are NULL, as they don't add value.

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
-- Remove the `row_num` column from the table.

SELECT * FROM layoffs_staging2;
-- View the final clean version of the table.
