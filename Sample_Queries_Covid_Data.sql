-- 1) Select Data that we are going to be using
select location, date, new_cases, total_cases, new_deaths, total_deaths, population
from covid_deaths
order by 1, 2;

-- 2) Show countries that we are using for this data
select location
from covid_deaths
where continent not like 'NULL'
group by location;

-- 3) Looking at the Total Deaths versus Total Deaths
-- Shows the likelihood of dying if you contract COVID-19 in your country (this example was for the United States)
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as death_percentage
from covid_deaths
where location = 'United States'
order by 1, 2;

-- 4) Looking at the Total Cases versus Population
-- Shows what percentage of population of the location has gotten COVID-19
select location, date, total_cases, population, (total_cases/population) * 100 as positive_percentage
from covid_deaths
where location = 'United States'
order by 1, 2;

-- 5) Looking at countries with highest infection rate relative to population
select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population) * 100) as percent_population_infected
from covid_deaths
where continent not like 'NULL'
group by location, population
order by 4 desc;

-- 6) Showing the countries with highest casualties per population
select location, MAX(total_deaths) as death_count
from covid_deaths
where continent not like 'NULL'
group by location
order by death_count desc; 

-- 7) This is the correct syntax for continent breakdown
-- The one above is incorrect. Take a look at query #2, it shows all of the countries excluding full continent data
-- Most likely the continent data where continent is NULL and country = continent is where full continent data is stored
-- The previous query is simply a summation of the different countries and the continents they belong to
select location, MAX(total_deaths) as death_count
from covid_deaths
where continent like 'NULL'
group by location
order by location;

-- 8) Global Numbers
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) * 100 as death_percentage
from covid_deaths
where continent not like 'NULL'
group by date
order by 1, 2;

-- Percentage of deaths globally versus total global cases
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) * 100 as death_percentage
from covid_deaths
where continent not like 'NULL';
-- group by date
-- order by 1, 2

-- COVID_VACCINATIONS TABLE
select*
from covid_vaccinations;

-- Joining the two tables
select*
from portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date;
    
-- Looking at Total Population versus Vaccinations -- With new column that counts up the amount of new vaccines
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as Rolling_Count_People_Vaccinated
from portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like 'NULL' -- and dea.location = 'Albania'
order by 2, 3;

-- Using CTE: How many people in the country are vaccinated?

with population_vs_vaccinated (continent, location, date, population, new_vaccinations, rolling_count_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as rolling_count_people_vaccinated
-- , rolling_count_people_vaccinated
from portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like 'NULL' -- and dea.location = 'Albania'
order by 2, 3
)
select *, (rolling_count_people_vaccinated/population) * 100 as percentage_vaccinated
from population_vs_vaccinated;

-- TEMP TABLE
drop table if exists percent_population_vaccinated;
create table percent_population_vaccinated
(
continent varchar(255),
location varchar(255),
date date,
population bigint,
new_vaccinations bigint,
rolling_count_people_vaccinated bigint
);
insert into percent_population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as rolling_count_people_vaccinated
-- , rolling_count_people_vaccinated
from portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like 'NULL'
order by 2, 3;
select *, (rolling_count_people_vaccinated/population) * 100 as percentage_vaccinated
from percent_population_vaccinated;
--

-- Creating View to store data for vizualization
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
from percent_population_vaccinated_view