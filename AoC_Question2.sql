/*****************************************************************************
Filename:	AoC_Question2
Date:		Dec 1, 2021
Descripion:	

USE [AdventOfCode2021]
*****************************************************************************/


--Testing FETCH query
SELECT rownum, reading FROM Question1
ORDER BY rownum ASC
OFFSET 1 * (1 - 1) ROWS
FETCH NEXT 3 ROWS ONLY


--Loop through the full Question2 table and insert each 3 row window into temp table
DECLARE @Window INT
DECLARE @WindowSize INT
DECLARE @Windows TABLE (rownum INT, reading INT, window INT)

SET @Window = 1
SET @WindowSize = 3

WHILE @Window <= FLOOR((SELECT COUNT(*) FROM Question1) - 2)
BEGIN

	INSERT INTO @Windows (rownum, reading, window)
	SELECT rownum, reading, @Window AS [window] FROM Question1
	ORDER BY rownum ASC
	OFFSET 1 * (@Window - 1) ROWS
	FETCH NEXT @WindowSize ROWS ONLY

	SET @Window = @Window + 1
END;

SELECT * INTO Question2 FROM @Windows

SELECT * FROM Question2


--Count the total amount of increasing readings
;WITH MAIN AS (
	SELECT window, SUM(reading) AS [windowsum], LAG(SUM(reading)) OVER(ORDER BY window) AS [previous] FROM Question2 GROUP BY window
)
SELECT 
	--*, CASE WHEN windowsum - previous > 0 THEN 1 ELSE 0 END
	SUM(CASE WHEN windowsum - previous > 0 THEN 1 ELSE 0 END) AS [increasing]
FROM MAIN
