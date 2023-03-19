--SELECT * FROM CovidDeaths ORDER BY 3,4

--SELECT * FROM CovidVaccination ORDER BY 3,4

SELECT *
FROM CovidDeaths
WHERE location = "World"
ORDER BY 1,2

--Looking at total cases  vs total deaths

SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as  DeathPercentage
FROM CovidDeaths
WHERE location like '%Ukraine'
ORDER BY 1,2


--Looking at total cases vs population

SELECT location, date, total_cases,  population, (total_cases/population)*100 as  TotalCasesPercentage
FROM CovidDeaths
WHERE location like '%Ukraine'
ORDER BY 1,2

--Looking at countries with highest rate of infection compare to popultaion

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopultaionInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopultaionInfected DESC

--Showing countries with highest death count per population

SELECT location, population, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
GROUP BY location
HAVING (location not like 'World'
    AND location not like 'High income'
    AND location not like ' Upper middle income'
    AND location not like ' Lower middle income'
    AND location not like ' Europe'
    AND location not like ' Asia'
    AND location not like ' North America'
    AND location not like ' South America'
    AND location not like ' Africa')
ORDER BY TotalDeathCount DESC


--Let's break this down by continent

SELECT continent, MAX(CAST(total_deaths AS INT)) AS Total_Death_count
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
order by Total_Death_count DESC

--Looking at total population vs vaccinations


Select DE.continent, DE.location, DE.date, DE.population, CV.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY CV.location)
FROM CovidDeaths DE
JOIN CovidVaccination CV
    ON DE.location = CV.location
    AND DE.date = CV.date
WHERE DE.continent is not null


--TEMP Table
drop table if exists PercentPopultaionVaccinated
CREATE table PercentPopultaionVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_Vaccination numeric
)

Insert into PercentPopultaionVaccinated
Select DE.continent, DE.location, DE.date, DE.population,  SUM(new_vaccinations) OVER (PARTITION BY CV.location)
FROM CovidDeaths DE
JOIN CovidVaccination CV
    ON DE.location = CV.location
    AND DE.date = CV.date
WHERE DE.continent is not null

SELECT * FROM PercentPopultaionVaccinated

Create view PPV as
SELECT  DE.continent, DE.location, DE.date, DE.population,  SUM(new_vaccinations) OVER (PARTITION BY CV.location)
FROM CovidDeaths DE
JOIN CovidVaccination CV
    ON DE.location = CV.location
    AND DE.date = CV.date
WHERE DE.continent is not null

