-- QUESTIONS
-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS gender_count
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) AS count
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;
-- 3. What is the age distribution of employees in the company?
SELECT 
	min(age) AS Youngest,
    max(age) AS Oldest
FROM hr
WHERE age>=21 AND termdate = '0000-00-00';

SELECT
	CASE
		WHEN age>=20 AND age<= 25 THEN '20-25'
        WHEN age>=26 AND age<= 35 THEN '26-35'
        WHEN age>=36 AND age<= 45 THEN '36-45'
        WHEN age>=46 AND age<= 55 THEN '46-55'
        WHEN age>=56 AND age<= 66 THEN '56-66'
        ELSE '67+'
	END AS age_group,
    count(*) AS count
FROM HR
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT
	CASE
		WHEN age>=20 AND age<= 25 THEN '20-25'
        WHEN age>=26 AND age<= 35 THEN '26-35'
        WHEN age>=36 AND age<= 45 THEN '36-45'
        WHEN age>=46 AND age<= 55 THEN '46-55'
        WHEN age>=56 AND age<= 66 THEN '56-66'
        ELSE '67+'
	END AS age_group, gender,
    count(*) AS count
FROM HR
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employee work at the Headquaters vs Remote locates?

SELECT location, count(*) AS count
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employement for employee who have been terminated?

SELECT
	round (avg(datediff(termdate, hire_date))/365,0) AS avg_length_emp
FROM hr
WHERE termdate <=curdate() AND age>=21 AND termdate <> '0000-00-00';
    
-- 6. How does the gender distribution vary across departments and job titles?

SELECT department,gender, COUNT(*) AS count
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY department,gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?

SELECT jobtitle, count(*) AS COUNT
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT department,
	total_count,
	terminated_count,
	terminated_count/total_count AS termination_rate
FROM(
SELECT department,
COUNT(*) AS total_count,
SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM HR
WHERE age >=21
GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. Which job titles have the highest turnover rates? 

SELECT
    jobtitle,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate<= curdate() THEN 1 ELSE 0 END) AS terminated_employees,
    (SUM(CASE WHEN termdate <> '0000-00-00' AND termdate<= curdate() THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS turnover_rate
FROM
    hr
GROUP BY
    jobtitle
ORDER BY
    turnover_rate DESC;


-- 10. What is the distribution of employees across locations by state?

SELECT location_state, COUNT(*) AS COUNT
FROM hr
WHERE age>=21 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY COUNT DESC;

-- 11. How has the company's employee count changed over time based on hire and term dates?

SELECT 
year,
hires,
terminations,
hires-terminations AS net_change,
round((hires-terminations)/hires * 100,2) AS net_percent_change
FROM (
	SELECT year(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age >=21
    GROUP BY year(hire_date)
    ) AS subquery
    ORDER BY YEAR ASC;

-- 12. What is the tenure distribution for each department?

SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate<= curdate() AND termdate <> '0000-00-00' AND age >21
GROUP BY department;