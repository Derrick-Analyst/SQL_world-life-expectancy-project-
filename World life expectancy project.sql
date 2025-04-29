# World life expectancy project (cleaning and standardizing)


SELECT * 
FROM world_life_expectancy;


SELECT country,year,concat(country,year),count(concat(country,year))
FROM world_life_expectancy
group by  country,year,concat(country,year)
having count(concat(country,year)) >1;

select*
from(
	select row_id,
	concat(country,year),
	row_number() over(partition by concat(country,year) order by concat(country,year)) as row_num
FROM world_life_expectancy) as row_table
where row_num >1;


delete from world_life_expectancy
where Row_ID in( select row_id
from(
	select row_id,
	concat(country,year),
	row_number() over(partition by concat(country,year) order by concat(country,year)) as row_num
	FROM world_life_expectancy) as row_table
where row_num >1);


SELECT * 
FROM world_life_expectancy
where Status = '';

SELECT distinct(status)
FROM world_life_expectancy
where Status <> '';

SELECT distinct(country)
FROM world_life_expectancy
where Status = 'developing';

update world_life_expectancy
set status = 'developing'
where country in(SELECT distinct(country)
				FROM world_life_expectancy
				where Status = 'developing');   -- did not work
                
                
                
update world_life_expectancy t1
join  world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'developing'
where t1.status = ''
and t2.status <> ''
and t2.status = 'developing';

SELECT * 
FROM world_life_expectancy
where Status = '';

SELECT *
FROM world_life_expectancy
where country = 'United States of America';


update world_life_expectancy t1
join  world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'developed'
where t1.status = ''
and t2.status <> ''
and t2.status = 'developed';

SELECT Country,year,`life expectancy`
FROM world_life_expectancy
where `life expectancy` = '';


SELECT t1.Country,t1.year,t1.`life expectancy`,t2.Country,t2.year,t2.`life expectancy`
FROM world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1;



SELECT t1.Country,t1.year,t1.`life expectancy`,
t2.Country,t2.year,t2.`life expectancy`,
t3.Country,t2.year,t3.`life expectancy`,
round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
    where t1.`life expectancy` = '';


update  world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
set t1.`life expectancy` = round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
where t1.`life expectancy` ='';



SELECT *
FROM world_life_expectancy
where `life expectancy` = '';


# EXPLORATORY ANALYSIS

SELECT *
FROM world_life_expectancy;

SELECT country,min(`Life expectancy`),max(`Life expectancy`),
round(max(`Life expectancy`)-min(`Life expectancy`),1) as life_increase_15years
FROM world_life_expectancy
group by Country
having min(`Life expectancy`) <> 0
and max(`Life expectancy`) <> 0
order by life_increase_15years desc;

SELECT year,round(avg(`Life expectancy`),2)
FROM world_life_expectancy
where (`Life expectancy`) <> 0
and (`Life expectancy`) <> 0
group by year
order by year;

SELECT *
FROM world_life_expectancy;

SELECT Country,round(avg(`Life expectancy`),1) as life_exp,round(avg(gdp),1) as gdp
FROM world_life_expectancy
group by country
having life_exp > 0
and gdp >0
order by gdp desc;

SELECT 
sum(case when  gdp >= 1500 then 1 else 0 end ) high_gdp_count,
avg(case when  gdp >= 1500 then `life expectancy` else null end ) high_gdp_life_expectancy,
sum(case when  gdp <= 1500 then 1 else 0 end ) high_gdp_count,
avg(case when  gdp <= 1500 then `life expectancy` else null end ) high_gdp_life_expectancy
FROM world_life_expectancy;


SELECT Status,round(avg(`Life expectancy`),1)
FROM world_life_expectancy
group by Status;


SELECT Status, count(distinct country),round(avg(`Life expectancy`),1)
FROM world_life_expectancy
group by Status;


SELECT Country,round(avg(`Life expectancy`),1) as life_exp,round(avg(bmi),1) as bmi
FROM world_life_expectancy
group by country
having life_exp > 0
and bmi > 0
order by bmi asc;

SELECT Country,
year, `Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by Country order by year) as rolling_total
FROM world_life_expectancy
where country like '%united%';








































































