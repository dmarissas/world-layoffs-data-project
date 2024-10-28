# 📊 World Layoffs Data Analysis (2020 - 2023)

This portfolio project explores global layoff trends from companies around the world between 2020 and early 2023. Using a dataset that provides information on companies, locations, countries, industries, and the total number of employees laid off, this project aims to uncover patterns and insights from recent layoffs.

## 📝 Project Overview

The objective of this project is to analyze layoff patterns, understand which countries, industries, and companies were most affected, and visualize the data to reveal the progression of layoffs over time.

## 🌍 Dataset Overview: Global Layoffs (2020–2023)
This dataset provides insights into global layoffs from 2020 to early 2023, sourced from a public Kaggle dataset. The data captures company-specific layoff details across industries and countries, offering a comprehensive view of workforce reductions worldwide.

Data Composition
The dataset contains a single table named layoffs with 1,995 records. Each record represents a layoff event with the following attributes:

| **Column Name**          | **Description**                          | **Data Type** |
|---------------------------|------------------------------------------|---------------|
| `company`                 | Name of the company                     | text          |
| `location`                | Company location                        | text          |
| `industry`                | Industry of the company                 | text          |
| `total_laid_off`          | Total number of employees laid off      | integer       |
| `percentage_laid_off`     | Percentage of workforce laid off        | text          |
| `date`                    | Date of layoff announcement             | date          |
| `stage`                   | Company's business stage               | text          |
| `country`                 | Country where the layoffs occurred      | text          |
| `funds_raised_millions`   | Funds raised by the company in millions | integer       |

This structured data enables an analysis of layoffs by company, industry, country, and stage of business, providing a basis for understanding patterns and trends in workforce reductions globally.

## 🛠️ Steps and Process

1. **Data Cleaning**
   - Removed duplicates to avoid redundant data.
   - Standardized data formats for consistency.
   - Handled missing data by filling or removing blanks.

2. **Exploratory Data Analysis (EDA)**
   - Identified the countries, companies, industries, and years with the highest number of layoffs.
   - Implemented a rolling sum to observe monthly layoff trends.
   - Ranked companies and years based on the highest layoffs to pinpoint key periods and entities.

3. **Data Visualization**
   - Created Tableau visualizations showcasing EDA findings, including the top 5 countries most impacted by layoffs, the top 10 affected industries, a world map of total layoffs, and a timeline of layoffs from 2020 to early 2023.
   - Tableau Visualization link: https://public.tableau.com/views/TotalLayoffs/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## 🛠️ Tools and Technologies Used

- **MySQL**: for data storage and processing.
- **Tableau**: for creating data visualizations and dashboards.

## 🔍 Insights and Findings

Summarize some key findings here, such as:
- Top affected countries and industries.
- Key years with peak layoffs.
- Patterns that reveal broader economic or industry trends.

## 🚀 Future Work

Include any ideas for expanding the analysis, like:
- Adding 2024 data to update the trends.
- Using predictive modeling to forecast future layoffs.
- Exploring additional datasets to enrich the analysis.
