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