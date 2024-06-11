-- Creating new table: covid_deaths and populating from csv file
-- Loading data from csv file to SQL using LOAD DATA INFILE since the import wizard was going to take forever

use portfolioproject;
drop table if exists covid_deaths;
CREATE TABLE covid_deaths
(
iso_code varchar(255),
continent varchar(255),
location varchar(255),
date date,
population bigint,
total_cases bigint,
new_cases bigint,
new_cases_smoothed float,
total_deaths bigint,
new_deaths bigint,
new_deaths_smoothed float,
total_cases_per_million float,
new_cases_per_million float,
new_cases_smoothed_per_million float,
total_deaths_per_million float,
new_deaths_per_million float,
new_deaths_smoothed_per_million float,
reproduction_rate float,
icu_patients int,
icu_patients_per_million float,
hosp_patients int,
hosp_patients_per_million float,
weekly_icu_admissions int,
weekly_icu_admission_per_million float,
weekly_hosp_admissions int,
weekly_hosp_admissions_per_million float
);

LOAD DATA INFILE 'covid_deaths.csv' INTO TABLE covid_deaths
FIELDS TERMINATED BY ','
IGNORE 1 LINES;