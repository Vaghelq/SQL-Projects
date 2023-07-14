select *
from CovidDeaths
where continent is not null
Order by 3,4

--select *
--from CovidVaccinations
--Order by 3,4

Select Location, Date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by 1,2

--LOOKING AT TOTAL CASES vs TOTAL DEATHS
--Shows Likehood of Dying if you  contract covid in country
Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%States%'
order by 1,2


--Looking at total cases vs Population
Select Location, Date, total_cases, population, (total_deaths/population)*100 as PercentPopulationInfected
from CovidDeaths
where location like '%States%'
order by 1,2


--Looking at  countries with highest infection rate as compared to population
Select Location, Population, max(total_cases) as HighestInfectionCount, max(total_deaths/population)*100 as PercentPopulationInfected
from CovidDeaths
--where location like '%States%'
Group by location, population
order by PercentPopulationInfected desc

--showing countries with highest Death count per population
Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%States%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--Continent with highest Death per Population
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%States%'
where continent is  not null
Group by continent
order by TotalDeathCount desc


--global numbers

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location like '%States%'
where continent is not null
--group by date
order by 1,2

