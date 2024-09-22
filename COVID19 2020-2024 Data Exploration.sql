SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent <> '' AND continent is NOT NULL
ORDER BY 3, 4

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1, 2

-- Total Cases vs Total Deaths: Looking at the percentage of people who actually died after contracting Covid19.
-- Shows the likelihood of dying if you contract Covid depending on selected country location.

SELECT Location, Date, Total_cases, Total_deaths, (total_deaths/NULLIF(total_cases,0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

SELECT Location, Date, Total_cases, Total_deaths, (total_deaths/NULLIF(total_cases,0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%South Korea%'
ORDER BY 1, 2


-- Total Cases vs Population
-- Shows what percentage of a country's population contracted Covid19

SELECT Location, Date, Total_cases, Population, (total_cases/population)*100 AS InfectedPopulationPercentage
FROM PortfolioProject..CovidDeaths
--WHERE Location LIKE '%South Korea%'
ORDER BY 1, 2


-- Highest Infection Rate compared to Population
-- Looking at countries with the highest infection rates compared to their population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS InfectedPopulationPercentage
FROM PortfolioProject..CovidDeaths
--WHERE Location LIKE '%South Korea%'
GROUP BY Location, Population
ORDER BY InfectedPopulationPercentage DESC


-- Countries with Highest Death Count per Population

SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location LIKE '%South Korea%'
WHERE continent <> '' AND continent is NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Highest Death Count per Continent
-- Looking at the highest death count of each continent

SELECT Continent, MAX(cast(Total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths
Where Continent <> '' AND Continent IS NOT NULL
Group by Continent
order by HighestDeathCount DESC

-- Global death percentage
-- Looking at the global death percentage of Covid19 contraction cases

SELECT SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths, SUM(new_deaths)/NULLIF(SUM(new_cases), 0)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent <> '' AND Continent IS NOT NULL
order by 1, 2


-- Total Population vs Vaccinations
-- Looking at the number of vacinnations done by countries

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
ORDER BY 2,3

-- Looking at rolling number of vaccinations done by countries.
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
ORDER BY 2,3



-- Using CTE to perform calculations in Partition By to look at the rolling number of vaccinations done by countries

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '' 
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
 

 -- Using Temp Table to perform calculations in Partition By to look at the rolling number of vaccinations done by countries
 
DROP TABLE if exists #PopulationVaccinatedPercentage
CREATE TABLE #PopulationVaccinatedPercentage
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated bigint
)

INSERT INTO #PopulationVaccinatedPercentage
SELECT dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) 
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PopulationVaccinatedPercentage
ORDER BY 2, 3


-- Creating View for data visualizations

CREATE VIEW PopulationVaccinatedPercentage AS
SELECT dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) as New_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> ''

SELECT * 
FROM PopulationVaccinatedPercentage