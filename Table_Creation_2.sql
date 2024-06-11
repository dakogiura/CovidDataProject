-- Creating new table: covid_vaccinations and populating from csv file
-- Loading data from csv file to SQL using LOAD DATA INFILE since the import wizard was going to take forever

use portfolioproject;
drop table if exists covid_vaccinations;
CREATE TABLE covid_vaccinations
(
iso_code varchar(255),
continent varchar(255),
location varchar(255),
date date,
total_tests bigint,
new_tests bigint,
total_tests_per_thousand float,
new_tests_per_thousand float,
new_tests_smoothed float,
new_tests_smoothed_per_thousand float,
positive_rate float,
tests_per_case float,
tests_units varchar(255),
total_vaccinations bigint,
people_vaccinated bigint,
people_fully_vaccinated bigint,
total_boosters bigint,
new_vaccinations bigint,
new_vaccinations_smoothed bigint,
total_vaccinations_per_hundred float,
people_vaccinated_per_hundred float,
peopl_fully_vaccinated_per_hundred float,
total_boosters_per_hundred float,
new_vaccinations_smoothed_per_million bigint,
new_people_vaccinated_smoothed bigint,
new_people_vaccinated_smoothed_per_hundred float,
stringency_index float,
population_density float,
median_age float,
aged_65_older float,
aged_70_older float,
gdp_per_capita float
);

LOAD DATA INFILE 'covid_vaccinations.csv' INTO TABLE covid_vaccinations
FIELDS TERMINATED BY ','
IGNORE 1 LINES;