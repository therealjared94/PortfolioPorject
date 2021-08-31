--Select *
--FROM PorfolioProject..['Covid-vacc-1$']
--order by 3,4

--Select *
--FROM PorfolioProject..['owid-covid-data$']
--order by 3,4


-- Data selection 

Select Location, Date, total_cases, new_cases, total_deaths, population
FROM PorfolioProject..['owid-covid-data$']
order by 1,2


--  Total Cases vs Total Deaths, percentage
Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Percentage_death
FROM PorfolioProject..['owid-covid-data$']
WHERE location = '%malaysia%'
order by 1,2


-- Percentage of population that dies from covid
Select Location, Date, total_cases, Population, (total_cases/Population)*100 AS Percentage_death
FROM PorfolioProject..['owid-covid-data$']
WHERE location = 'Malaysia'
order by 1,2

-- Looking at countries with Highest Infection rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM PorfolioProject..['owid-covid-data$']
Group by Location, Population
order by PercentPopulationInfected desc

-- Selecting Continents location
-- Continent is null is when the dataset only contain continents
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PorfolioProject..['owid-covid-data$']
where continent is null
Group by location
order by TotalDeathCount desc

-- Showing contintents with the highest death count 
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PorfolioProject..['owid-covid-data$']
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global death numbers
Select Sum(new_cases), Sum(cast(new_deaths as int)),  Sum(cast(new_deaths as int))/Sum(new_cases) AS Percentage_death
FROM PorfolioProject..['owid-covid-data$']
WHERE continent is not null
--Group By date
Order By 1,2


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) 
as RollingPeopleVaccinated, (RollingPeopleVaccinated/population)*100
From PorfolioProject..['Covid-vacc-1$'] vac 
Join PorfolioProject..['owid-covid-data$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Error and solutions 

-- USE CTE
-- Number of columns must be the same
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PorfolioProject..['Covid-vacc-1$'] vac 
Join PorfolioProject..['owid-covid-data$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac
Where Location = 'Australia'


-- Another way TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PorfolioProject..['Covid-vacc-1$'] vac 
Join PorfolioProject..['owid-covid-data$'] dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated
Where Location = 'Australia'
