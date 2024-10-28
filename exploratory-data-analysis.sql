-- Exploratory Data Analysis (EDA)

-- 1. The maximum number of workers laid off and the highest layoff percentage in a company.
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs;
-- Answer: The highest layoff count is 12,000 workers, and the maximum layoff percentage is 100%, indicating the company closed down.

-- 2. Which company with a 100% layoff had the highest total laid off?
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY total_laid_off DESC;
-- Answer: Katerra had the highest total layoffs with 2,434 employees.

-- 3. Which company has the highest total layoffs across all data?
SELECT company, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY SUM(total_laid_off) DESC;
-- Answer: Amazon had the highest total layoffs, with 18,150 employees.

-- 4. Date range covered in the data.
SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging2;
-- Answer: The date range spans from 2020-03-11 to 2023-03-06.

-- 5. Which industry has the highest total layoffs?
SELECT industry, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY industry ORDER BY SUM(total_laid_off) DESC;
-- Answer: The Consumer industry had the highest layoffs, followed closely by the Retail industry.

-- 6. Which country has the highest total layoffs?
SELECT country, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY country ORDER BY SUM(total_laid_off) DESC;
-- Answer: The United States had the most layoffs, followed by India and the Netherlands.

-- 7. Which year recorded the highest total layoffs?
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2 GROUP BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC;
-- Answer: The year 2022 recorded the highest layoffs. However, data for early 2023 shows a high layoff count, which may exceed 2022 if the trend continues.

-- 8. Which company stage had the highest total layoffs?
SELECT stage, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY stage ORDER BY SUM(total_laid_off) DESC;
-- Answer: Companies in the Post-IPO stage (e.g., Google, Amazon) had the highest layoffs.

-- 9. Rolling sum of total layoffs by month and year.
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL GROUP BY `MONTH` ORDER BY `MONTH`;

WITH rolling_sum (months, total_off) AS (
    SELECT SUBSTRING(`date`,1,7), SUM(total_laid_off)
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY SUBSTRING(`date`,1,7)
    ORDER BY SUBSTRING(`date`,1,7)
)
SELECT *, SUM(total_off) OVER(ORDER BY months) AS roll_sum FROM rolling_sum;
-- Answer: This provides a monthly rolling sum of layoffs, showing cumulative layoffs up to each month.

-- 10. Rank the top 5 companies with the highest total layoffs for each year.
SELECT company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2 GROUP BY company, YEAR(`date`);

WITH year_company (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS `rank`
    FROM year_company
    WHERE years IS NOT NULL
)
SELECT * FROM company_year_rank WHERE `rank` <= 5;
-- Answer: This ranks the top 5 companies with the highest layoffs each year.

-- 11. Count of companies that went under each year (2020-2023).
SELECT YEAR(`date`) AS year, COUNT(company) AS total_companies
FROM layoffs_staging2
WHERE percentage_laid_off = 1 AND YEAR(`date`) BETWEEN 2020 AND 2023
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`);
-- Answer: Companies that went under each year are: 36 in 2020, 8 in 2021, 58 in 2022, and 14 in early 2023.
