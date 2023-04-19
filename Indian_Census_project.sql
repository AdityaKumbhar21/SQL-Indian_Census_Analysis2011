USE Indian_Census;

select * from census1;
select * from census2;

-- What is the total population of india
SELECT SUM(Population) as Total_Poluation from census2;

-- Avearge growth of the country
SELECT Round(AVG(Growth),2) as Average_Growth from census1;

-- Average Sex Ratio of the country
SELECT Round(AVG(Sex_Ratio),.0) as Average_Sex_Ratio from census1;
 
-- Average Literacy rate of the country
SELECT Round(AVG(Literacy),2) as Average_Literacy from census1;

-- Literacy rate state wise
SELECT State, Literacy FROM census1
GROUP BY State;

-- Select States that have literacy rate above the average
SELECT   State FROM census1
WHERE Literacy > (
SELECT AVG(Literacy) FROM census1)
GROUP BY State
ORDER BY State
;

-- Select top 3 states having high literacy rate 
SELECT DISTINCT State,Literacy 
FROM census1
GROUP BY State
ORDER BY Literacy desc 
LIMIT 3;

-- Select the states that have Growth above average
SELECT DISTINCT State,Growth 
FROM census1
WHERE Growth > (
SELECT AVG(GROWTH) from census1)
GROUP BY State;

-- Select States with higher sex ratio  top 5
SELECT DISTINCT State, Sex_Ratio
FROM census1 
GROUP BY State
ORDER BY Sex_Ratio desc LIMIT 5;

-- Select Bottom 3 states having lowest literacy rate
SELECT State,Literacy 
FROM census1 
GROUP BY State
ORDER BY Literacy asc
LIMIT 3;

-- Select the district of the state having highest literacy rate which contributes more.
-- As Mizoram is the State with highest Literacy rate
SELECT District, Literacy 
FROM census1
WHERE State  = 'Mizoram'
ORDER BY Literacy desc 
LIMIT 1;

-- Select state that have the highest area in area_km2
SELECT State , SUM(Area_km2) AS Area_Km2 FROM census2
GROUP BY State
ORDER BY SUM(Area_km2) desc 
LIMIT 1;

-- Select the population of the state with highest area
-- Rajasthan is the state with highest area as obtaines from above query.
SELECT State, SUM(Population) Population
FROM census2 
WHERE
State = 'Rajasthan'
GROUP BY State;



-- The census data for state Maharashtra and Karnataka.
-- And show data of Maharashtra shoul be first and in alphabetical order of districts
SELECT * FROM census1
JOIN census2 ON
census1.District = census2.District
WHERE census1.State IN ('Maharashtra','Karnataka')
ORDER BY census1.State desc ,  census1.District asc;

-- Select total number of male and female
-- sex ratio = males/female
-- With the help of this formula we hav derived
-- males = population/(Sex_Ratio+1)
-- females = (Population*(Sex_Ratio))/ (Sex_Ratio+1)

SELECT b.State,SUM(b.Males) Males,SUM(b.Females) Females FROM( 
SELECT a.District , a.State, ROUND((a.Population)/(a.Sex_Ratio +1),.0) Males, ROUND(((a.population*a.Sex_Ratio)/(Sex_Ratio + 1)),.0) Females FROM
(SELECT c1.District , c1.Sex_Ratio/1000 Sex_ratio,c1.State, c2.Population
FROM census1 c1 INNER JOIN census2 c2 ON
c1.District = c2.District) a)b
GROUP BY b.State;

-- Which state has the highest number of females
SELECT b.State, SUM(b.Females) Females FROM
(SELECT a.District , a.State, ROUND((a.Population)/(a.Sex_Ratio +1),.0) Males, ROUND(((a.population*a.Sex_Ratio)/(Sex_Ratio + 1)),.0) Females FROM
(SELECT c1.District , c1.Sex_Ratio/1000 Sex_ratio,c1.State, c2.Population
FROM census1 c1 INNER JOIN census2 c2 ON
c1.District = c2.District) a
)b 
GROUP BY State
ORDER BY b.Females DESC LIMIT 1;

-- Previous census population
SELECT sum(n.pre_pop1) Previous_Census_Population, sum(n.cur_pop1) Current_Census_Population , n.Growth   FROM(
SELECT h.State,sum(h.pre_pop) as pre_pop1, sum(h.cur_pop) as cur_pop1,  h.Growth FROM  
(SELECT g.District, g.State,ROUND(g.Population/(1+g.Growth),0) as pre_pop, g.Population as cur_pop, g.Growth FROM
(SELECT a.District, a.State, a.Growth, b.Population
-- ROW_NUMBER() OVER (PARTITION BY a.State) as Row_num
FROM census1 a INNER JOIN census2 b  
ON a.District = b.District )
 g)h
 GROUP BY h.State)
n;

