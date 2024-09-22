# COVID-19 Data Exploration

This project involves the exploration and analysis of COVID-19 data using SQL skills such as Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views, and Converting Data Types. It focuses on various metrics to provide insights into the pandemic's impact across different regions and populations.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Skills Used](#skills-used)
3. [Data Source](#data-source)
4. [Analysis and Insights](#analysis-and-insights)
5. [Key SQL Queries](#key-sql-queries)
6. [Installation and Setup](#installation-and-setup)
7. [Conclusion](#conclusion)

## Project Overview
This project explores the impact of COVID-19 from January 1, 2020 until September 14, 2024 on various countries and continents using SQL queries. It investigates several key questions, such as the percentage of the population infected, likelyhood of dying if contracted based on country and how countries compare in terms of infection and death rates relative to their populations. Additionally, the analysis provides insights into global vaccination rates and their correlation with population size.

The dataset is processed using SQL techniques like Joins, Common Table Expressions (CTEs), Temp Tables, and Window Functions to provide insights into the pandemic's effects.

### Objectives:
- Analyze COVID-19's impact across different regions and populations.
- Use SQL to perform data transformations and explore trends.

## Skills Used
- **Joins**
- **Common Table Expressions (CTEs)**
- **Temporary Tables**
- **Window Functions**
- **Aggregate Functions**
- **Creating Views**
- **Converting Data Types**

## Data Source
The data used in this project was sourced from [https://ourworldindata.org/covid-deaths], which contains information on COVID-19 cases, recoveries, vaccinations, deaths, and more, across various countries and regions.

## Analysis and Insights
Some of the key insights gained through this analysis include:  
1. **Regional Analysis**
- Impact by Region: Identifying which regions (countries or continents) were most heavily affected by the pandemic, based on infection rates, death rates, and total case numbers.
- Continent-wise Breakdown: Provides a comparison of key COVID-19 metrics (cases, deaths, recoveries) across different continents, offering a broader geographical understanding of the pandemic's spread.
2. **Population Impact**
- Likelihood of Death: Assesses the probability of death if infected with COVID-19, broken down by country.
- Population Infection Rates: Calculates the percentage of the population in each country that was infected, providing insights into the spread of the virus within different population sizes.
- Top Countries by Infection and Death Rates: Identifies the countries with the highest infection and death rates relative to their population size, highlighting the most impacted nations.
3. **Time Trends and Global Overview**
- Global COVID-19 Numbers: Analyzes the total number of cases, new cases, deaths, and the overall percentage of the global population affected by the pandemic over time.
- Population vs. Vaccination Rates: Examines the correlation between a country’s population size and the percentage of the population that was vaccinated, offering insights into vaccination efforts and their potential effects on COVID-19 outcomes.

## Key SQL Queries
The project leverages several advanced SQL queries to extract insights:
1. **Join Queries**: To combine datasets for a comprehensive view of the COVID-19 impact.
2. **CTEs**: For modular queries that make it easier to reuse logic.
3. **Window Functions**: To analyze trends over time (e.g rolling sum).
4. **Temp Tables and Views**: To store intermediate results for more complex analysis.
   
Example Query:
```sql
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
ORDER BY 2,3
```

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/daniellekcodes/covid-19-data-exploration.git
   ```
2. Load the datasets into your SQL environment.
3. Run the SQL scripts provided in the sql file to explore the data.

## Conclusion
This project demonstrates how SQL can be used to explore COVID-19 data and uncover insights on a global scale. By analyzing infection rates, death rates, and vaccination data, it provides valuable information on the pandemic’s impact across various regions.
