
--checking the columns of CovidDeaths
select * from CovidDeaths;

--looking at total cases vs total deaths
select 
		location, 
		date, 
		total_cases,
		total_deaths,
		(cast(total_deaths as float)/cast(total_cases as int)) *100   DeathPercent
from CovidDeaths;


--where and when was the death percent highest?
select top 1 location, date,
			cast(total_deaths as float)/cast(total_cases as int) *100   DeathPercent
from CovidDeaths 
order by 3 desc


--what percent of population got infected and died in each country?

select location, population, sum(new_cases) as total_cases, 
		sum(new_deaths) as total_deaths, 
		sum(cast(new_cases as float))/cast(population as bigint)*100 InfectedPercent,
		sum(cast(new_deaths as float))/cast(population as bigint)*100 DeathPercent
from CovidDeaths
where continent is not null 
group by location, population
order by 4 desc;

--how many got infected and how many lost their life in each continents?

select continent, sum(population) as TotalPopn, 
		sum(new_cases) as total_cases, 
		sum(new_deaths) as total_deaths, 
		sum(cast(new_cases as float))/sum(cast(population as bigint))*100 InfectedPercent,
		sum(cast(new_deaths as float))/sum(cast(population as bigint))*100 DeathPercent,
		sum(cast(new_deaths as float))/sum(cast(new_cases as bigint))*100 DeathPercentPerCases
from CovidDeaths
where continent is not null 
group by continent
order by 4 desc;


--when did the most people get infected?
select date, sum(new_cases) as Infected from 
CovidDeaths
group by date
order by 2 desc

--when did the most people die?
select date, sum(new_deaths) as Deaths from 
CovidDeaths
group by date
order by 2 desc

--checking vaccinations table
select * from CovidVaccinations;


--how many got vaccinated in each country?

select location, population, sum(cast(new_vaccinations as float)) as total_vaccinations, 
		sum(cast(new_vaccinations as float))/cast(population as bigint)*100 VaccinationPercent
from CovidVaccinations
where continent is not null 
group by location, population
order by 1;

--how many got vaccinated in each continents?

select continent, sum(population) as TotalPopn, 
		sum(cast(new_vaccinations as float)) as total_vaccinations, 
		sum(cast(new_vaccinations as float))/sum(cast(population as bigint))*100 VaccinationPercent
from CovidVaccinations
where continent is not null 
group by continent
order by 4 desc;

--when did the most people get vaccinated and how many died that day?
select vac.date, sum(new_deaths) as total_deaths, sum(cast(new_vaccinations as float)) as vaccinations from 
CovidVaccinations as vac inner join CovidDeaths as Dea on 
vac.date=dea.date
where Dea.continent is not null
group by vac.date
order by 1 desc
