-- Select data that we will be using to explore and gather useful insights, trends and patterns regarding the covid-19 virus

-- This dataset was publically obtained from the World Health Organization(01/01/2020 - 03/01/2021)

-- With these queries i will extract the result sets and import into an excel file for further analysis, and create a visually appealing and story telling
-- dashboard utilizing the the Tableau data visualization software. 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths
ORDER BY location, date;

-- Looking at Total Cases vs Total deaths
-- % of cases where death occured

SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) AS "% OF DEATH"
FROM dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY location, date;

-- Looking at total cases vs population in united states
-- shows what percentage of the population got infected with covid virus

SELECT location, date, total_cases, population, round((total_cases/population)*100, 2) AS "% OF INFECTED"
FROM dbo.CovidDeaths
WHERE location like '%states%' AND continent IS NOT NULL
ORDER BY location, date;

-- what countries have the highest infection rates

SELECT location, population, MAX(total_cases) AS "TOTAL NUMBER OF CASES", round((MAX(total_cases)/population)*100, 2) AS "% OF INFECTED"
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY "% OF INFECTED" DESC;

-- Show countries with highest death rate

--SELECT location, population, MAX(total_deaths) AS "TOTAL DEATHS", round((MAX(total_deaths)/population)*100, 2) AS "% OF DEATH"
--FROM dbo.CovidDeaths
--GROUP BY location, population
--ORDER BY "% OF DEATH" DESC;

SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- LOOK AT TOTAL DEATHS BY CONTINENT

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeaths
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC;

-- Global Numbers

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS DeathPercentage
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


-- Looking at total population vs vaccinations

CREATE VIEW PercentPopulationVaccinated AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT * FROM PercentPopulationVaccinated;

-- temp table

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases) AS DeathPercentage
FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2;

SELECT location, SUM(CAST(new_deaths AS INT)) as TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent is NULL
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER by TotalDeathCount DESC;

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM dbo.CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM dbo.CovidDeaths
GROUP BY location, population, date
ORDER BY PercentagePopulationInfected DESC;
