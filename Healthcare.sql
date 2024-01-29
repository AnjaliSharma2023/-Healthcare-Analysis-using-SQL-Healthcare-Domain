Use [Healthcare Analysis]

select * 
from patients

select FIRST,LAST,BIRTHDATE
from patients


select distinct(COUNTRY) 
from patients

select distinct(GENDER) 
from patients

select distinct CITY, count(CITY)
from patients
group by CITY

-- Age of patient
select 
    DATEDIFF(YEAR, BIRTHDATE, GETDATE()) - 
    CASE 
        WHEN (MONTH(BIRTHDATE) > MONTH(GETDATE()) OR (MONTH(BIRTHDATE) = MONTH(GETDATE()) AND DAY(BIRTHDATE) > DAY(GETDATE())))
        THEN 1
        ELSE 0
    END AS age
from patients;

--Marital status, age with count
select 
    MARITAL,
    DATEDIFF(YEAR, BIRTHDATE, GETDATE()) - 
    CASE 
        WHEN (MONTH(BIRTHDATE) > MONTH(GETDATE()) OR (MONTH(BIRTHDATE) = MONTH(GETDATE()) AND DAY(BIRTHDATE) > DAY(GETDATE())))
        THEN 1
        ELSE 0
    END AS age,
    COUNT(*) AS count
from patients
GROUP BY MARITAL, 
    DATEDIFF(YEAR, BIRTHDATE, GETDATE()) - 
    CASE 
        WHEN (MONTH(BIRTHDATE) > MONTH(GETDATE()) OR (MONTH(BIRTHDATE) = MONTH(GETDATE()) AND DAY(BIRTHDATE) > DAY(GETDATE())))
        THEN 1
        ELSE 0
    END
	ORDER BY count DESC;

-- Total number of Female patients and their marital status
select distinct MARITAL,count(*) as count
from patients
group by MARITAL
order by count(*) desc


--Marital staus of majority of female patients attending the hospital their average age 
--Calculate the average age and count of patients based on their marital status
select 
    MARITAL,
    AVG(DATEDIFF(YEAR, BIRTHDATE, GETDATE()) - 
        CASE 
            WHEN (MONTH(BIRTHDATE) > MONTH(GETDATE()) OR (MONTH(BIRTHDATE) = MONTH(GETDATE()) AND DAY(BIRTHDATE) > DAY(GETDATE())))
            THEN 1
            ELSE 0
        END) AS avg_age,
    COUNT(*) AS count
from patients
GROUP BY MARITAL
ORDER BY count DESC;

--combinations of  encounter class (ENCOUNTERCLASS), average age (avg_age), and count (count)
SELECT 
    Distinct e.ENCOUNTERCLASS,
    AVG(DATEDIFF(YEAR, p.BIRTHDATE, GETDATE()) - 
        CASE 
            WHEN (MONTH(p.BIRTHDATE) > MONTH(GETDATE()) OR (MONTH(p.BIRTHDATE) = MONTH(GETDATE()) AND DAY(p.BIRTHDATE) > DAY(GETDATE())))
            THEN 1
            ELSE 0
        END) AS avg_age,
    COUNT(*) AS count
FROM patients as p 
JOIN encounters as e
ON p.Id = e.Patient
GROUP BY e.ENCOUNTERCLASS
ORDER BY count DESC

--
SELECT 
    p.MARITAL,e.ENCOUNTERCLASS,
    COUNT(*) AS count
FROM patients as p 
JOIN encounters as e
ON p.Id = e.Patient
where e.ENcounterclass = 'ambulatory'
GROUP BY p.MARITAL,e.ENCOUNTERCLASS
ORDER BY count DESC

--select * 
from encounters

select distinct PAYER,count(PAYER)
from encounters
group by PAYER
order by count(PAYER) desc

--	Types of Encounter class and number of patients in each class
select ENCOUNTERCLASS, count(ENCOUNTERCLASS) as Count
from encounters
group by ENCOUNTERCLASS
order by count(ENCOUNTERCLASS) desc

---- Details where Encounterclass = Ambulatory which is highest in count
select  DESCRIPTION , ENCOUNTERCLASS, count(*) as count
from encounters
Where ENCOUNTERCLASS= 'ambulatory'
group by DESCRIPTION, ENCOUNTERCLASS
order by count(*) desc


--what the different types of insurance company which patients use and their count
select distinct Payer, count(*) as Patient_count
from encounters
group by Payer 
order by count(*) desc

--How many patients are there without insurance 
select Payer, count(*) as Patient_count
from encounters
where Payer = 'No Insurance'
group by Payer 


-- Encounter description count and type
select distinct DESCRIPTION,count(*) as count
from encounters
group by DESCRIPTION
order by count(*) desc

select distinct PAYER,count(PAYER)
from encounters
group by PAYER
order by count(PAYER) desc

-- Details where Encounterclass = Inpatient
select * 
from encounters
Where ENCOUNTERCLASS= 'inpatient'



-- Details where Encounterclass = Inpatient and patient is in ICU between Jan  2023 to Dec 2023
select * 
from encounters
Where ENCOUNTERCLASS= 'inpatient'
and DESCRIPTION = 'ICU Admission'
and STOP between'2023-01-01 00:00' and '2023-12-31 23:59'

select *
from encounters
Where ENCOUNTERCLASS= 'outpatient' or ENCOUNTERCLASS= 'ambulatory'

select * 
from encounters
Where ENCOUNTERCLASS in('outpatient','ambulatory')

select * 
from conditions


--list of medical conditions along with their respective counts

select Description,
	count(*) as count_of_condition
from conditions
group by Description
order by count_of_condition desc


-- desciption with count more than 2000

select Description,
	count(*) as count_of_condition
from conditions
group by Description
having count(*) > 2000
order by count(*) desc


-- desciption with count more than 5000 with description not include body mass
select Description,
	count(*) as count_of_condition
from conditions
where Description != 'Body Mass Index 30.0-30.9, adult'
group by Description
having count(*) > 5000
order by count(*) desc


--all of the patients from Boston

select * 
from patients
where CITY = 'Boston'

--all patients who diagnosed with Chronic Kidney disease(ICD-9 code - 585.1 585.2 585.3 and 585.4)

select * 
from conditions
where Code in ('585.1', '585.2',' 585.3','585.4')


--lists out the number of patients per City in descending order
--and that city does not include Boston and 
--you must have at least 100 patients

--the count of all patients from their city of residence
--and there must have been at least 100 patients cities do not include Boston

select CITY, count(*)
from patients 
where CITY != 'Boston'
group by CITY
having count(*) >=100
order by count(*) desc


--Joins
select * 
from Immunizations



select distinct(Description)
from Immunizations

--Count of description where it is Seasonal flu
select Description,
	count(*) 
from Immunizations
where Description = 'Seasonal Flu Vaccine'
group by Description

--Join two tables 
select t1.*,
		t2.FIRST,
		t2.LAST,
		t2.BIRTHDATE
from Immunizations as t1
left join patients as t2
on t1.Patient = t2.Id



select pat.BirthDate,
	pat.race,
	pat.Id,
	pat.FIRST,pat.LAST
from patients as pat

select * 
from Immunizations
where Description = 'Seasonal Flu Vaccine'

