-- Creating Views to store data for vizualization

-- 1) View of Percentage of Population that has been vaccinated
drop view if exists percent_population_vaccinated_view;
create view percent_population_vaccinated_view as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as rolling_count_people_vaccinated
-- , rolling_count_people_vaccinated
from portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like 'NULL'
order by 2, 3;
select *
from percent_population_vaccinated_view;

-- 2) View of total deaths by continent
drop view if exists total_deaths_by_continent;
create view total_deaths_by_continent as
select location, MAX(total_deaths) as death_count
from covid_deaths
where continent like 'NULL' and location not like '%income' and location not like 'World'
group by location;
select *
from total_deaths_by_continent;

-- Actual SQL queries used for Tableau Public Dashboard:

-- 1. Global Numbers: Total Cases, Total Deaths, and Death Percentage
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
from covid_deaths
where location like '%states%' and continent not like 'Null' 
-- Group By date
order by 1,2;

-- 2. Total Deaths by Continent
Select location, SUM(new_deaths) as TotalDeathCount
From covid_deaths
-- Where location like '%states%'
where continent like 'Null' and location not in ('World', 'European Union') and location not like '%income%'
Group by location
order by TotalDeathCount desc;


-- 3. Percent Population Infected per Country --> Vizualized on a map
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths
-- Where location like '%states%'
-- where location not like '%income%'
Group by Location, Population
order by PercentPopulationInfected desc;


-- 4. Time Series of Percentage of Population Infected by Country --> Selected a few countries to make it easier to view
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths
-- Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc;
