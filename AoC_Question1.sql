/*****************************************************************************
Filename:	AoC_Question1
Date:		Dec 1, 2021
Descripion:	

USE [AdventOfCode2021]
*****************************************************************************/


--Create table for 
CREATE TABLE Question1 (rownum INT IDENTITY(1,1), reading INT) 


--Review import and create calculate column
;WITH MAIN AS (
	SELECT reading, LAG(reading) OVER(ORDER BY rownum ASC) AS [previous] FROM Question1
)
SELECT *
	, CASE WHEN reading - previous > 0 THEN 1 ELSE 0 END AS [increasing]
FROM MAIN



--Count the total amount of increasing readings
;WITH MAIN AS (
	SELECT reading, LAG(reading) OVER(ORDER BY rownum ASC) AS [previous] FROM Question1
)
SELECT SUM(CASE WHEN reading - previous > 0 THEN 1 ELSE 0 END) AS [increasing]
FROM MAIN
