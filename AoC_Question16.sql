/*****************************************************************************
Filename:	AoC_Question16
Date:		Dec 12, 2021
Descripion:	

	--- Day 9: Smoke Basin ---

	These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

	If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

	Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

	2199943210
	3987894921
	9856789892
	8767896789
	9899965678

	Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

	Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

	In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

	The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

	Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

USE [AdventOfCode2021]
*****************************************************************************/


--Use example to test code
CREATE TABLE #Example (rownum INT IDENTITY(1,1), C1 INT, C2 INT, C3 INT, C4 INT, C5 INT, C6 INT, C7 INT, C8 INT, C9 INT, C10 INT)

INSERT INTO #Example (C1,C2,C3,C4,C5,C6,C7,C8,C9,C10)
VALUES(2,1,9,9,9,4,3,2,1,0)
	,(3,9,8,7,8,9,4,9,2,1)
	,(9,8,5,6,7,8,9,8,9,2)
	,(8,7,6,7,8,9,6,7,8,9)
	,(9,8,9,9,9,6,5,6,7,8)


WITH ABOVE AS (
	SELECT rownum 
		, LAG(C1,1,99) OVER(ORDER BY rownum) AS [C1]
		, LAG(C2,1,99) OVER(ORDER BY rownum) AS [C2]
		, LAG(C3,1,99) OVER(ORDER BY rownum) AS [C3]
		, LAG(C4,1,99) OVER(ORDER BY rownum) AS [C4]
		, LAG(C5,1,99) OVER(ORDER BY rownum) AS [C5]
		, LAG(C6,1,99) OVER(ORDER BY rownum) AS [C6]
		, LAG(C7,1,99) OVER(ORDER BY rownum) AS [C7]
		, LAG(C8,1,99) OVER(ORDER BY rownum) AS [C8]
		, LAG(C9,1,99) OVER(ORDER BY rownum) AS [C9]
		, LAG(C10,1,99) OVER(ORDER BY rownum) AS [C10]
	FROM #Example
), BELOW AS (
	SELECT rownum 
		, LEAD(C1,1,99) OVER(ORDER BY rownum) AS [C1]
		, LEAD(C2,1,99) OVER(ORDER BY rownum) AS [C2]
		, LEAD(C3,1,99) OVER(ORDER BY rownum) AS [C3]
		, LEAD(C4,1,99) OVER(ORDER BY rownum) AS [C4]
		, LEAD(C5,1,99) OVER(ORDER BY rownum) AS [C5]
		, LEAD(C6,1,99) OVER(ORDER BY rownum) AS [C6]
		, LEAD(C7,1,99) OVER(ORDER BY rownum) AS [C7]
		, LEAD(C8,1,99) OVER(ORDER BY rownum) AS [C8]
		, LEAD(C9,1,99) OVER(ORDER BY rownum) AS [C9]
		, LEAD(C10,1,99) OVER(ORDER BY rownum) AS [C10]
	FROM #Example
)
SELECT CASE WHEN ((E.C2 - E.C1) > 0) AND ((A.C1 - E.C1) > 0) AND ((B.C1 - E.C1) > 0) THEN E.C1 ELSE '' END AS [Lowest_C1]
	, CASE WHEN ((E.C1 - E.C2) > 0) AND ((E.C3 - E.C2) > 0) AND ((A.C2 - E.C2) > 0) AND ((B.C2 - E.C2) > 0) THEN E.C2 ELSE '' END AS [Lowest_C2]
	, CASE WHEN ((E.C2 - E.C3) > 0) AND ((E.C4 - E.C3) > 0) AND ((A.C3 - E.C3) > 0) AND ((B.C3 - E.C3) > 0) THEN E.C3 ELSE '' END AS [Lowest_C3]
	, CASE WHEN ((E.C3 - E.C4) > 0) AND ((E.C5 - E.C4) > 0) AND ((A.C4 - E.C4) > 0) AND ((B.C4 - E.C4) > 0) THEN E.C4 ELSE '' END AS [Lowest_C4]
	, CASE WHEN ((E.C4 - E.C5) > 0) AND ((E.C6 - E.C5) > 0) AND ((A.C5 - E.C5) > 0) AND ((B.C5 - E.C5) > 0) THEN E.C5 ELSE '' END AS [Lowest_C5]
	, CASE WHEN ((E.C5 - E.C6) > 0) AND ((E.C7 - E.C6) > 0) AND ((A.C6 - E.C6) > 0) AND ((B.C6 - E.C6) > 0) THEN E.C6 ELSE '' END AS [Lowest_C6]
	, CASE WHEN ((E.C6 - E.C7) > 0) AND ((E.C8 - E.C7) > 0) AND ((A.C7 - E.C7) > 0) AND ((B.C7 - E.C7) > 0) THEN E.C7 ELSE '' END AS [Lowest_C7]
	, CASE WHEN ((E.C7 - E.C8) > 0) AND ((E.C9 - E.C8) > 0) AND ((A.C8 - E.C8) > 0) AND ((B.C8 - E.C8) > 0) THEN E.C8 ELSE '' END AS [Lowest_C8]
	, CASE WHEN ((E.C8 - E.C9) > 0) AND ((E.C10 - E.C9) > 0) AND ((A.C9 - E.C9) > 0) AND ((B.C9 - E.C9) > 0) THEN E.C9 ELSE '' END AS [Lowest_C9]
	, CASE WHEN ((E.C9 - E.C10) > 0) AND ((A.C10 - E.C10) > 0) AND ((B.C10 - E.C10) > 0) THEN E.C10 ELSE '' END AS [Lowest_C10]
FROM #Example E
JOIN ABOVE A ON A.rownum = E.rownum
JOIN BELOW B ON B.rownum = E.rownum




--Don't want to make a massive query with repeating columns
CREATE TABLE #TEMP (col VARCHAR(10), num INT)

DECLARE @i INT
DECLARE @l VARCHAR(5)
DECLARE @r VARCHAR(5)
DECLARE @c VARCHAR(5)
DECLARE @sql VARCHAR(4000)
SET @i = 2

WHILE @i < 10
BEGIN
	SET @l = 'C' + CAST(@i - 1 AS VARCHAR)
	SET @r = 'C' + CAST(@i + 1 AS VARCHAR)
	SET @c = 'C' + CAST(@i AS VARCHAR)
	
	SET @sql = '
	;WITH MAIN AS (
		SELECT ' + @l + ' AS [left]
			, ' + @c + ' AS [center]
			, ' + @r + ' AS [right]
			, LAG(' + @c + ',1,99) OVER(ORDER BY rownum) AS [above]
			, LEAD(' + @c + ',1,99) OVER(ORDER BY rownum) AS [below]
		FROM #Example
	)
	INSERT INTO #Temp
	SELECT ''' + @c + ''' AS [column], SUM(CASE WHEN (([left] - center) > 0) AND (([right] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center ELSE '''' END) AS [num]
	FROM MAIN'

	EXEC (@sql)

	SET @i = @i + 1
END


--First column
;WITH MAIN AS (
	SELECT --C1 AS [left]
		 C1 AS [center]
		, C2 AS [right]
		, LAG(C1,1,99) OVER(ORDER BY rownum) AS [above]
		, LEAD(C1,1,99) OVER(ORDER BY rownum) AS [below]
	FROM #Example
)
INSERT INTO #Temp
SELECT 'C1' AS [column], SUM(CASE WHEN (([right] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center ELSE '' END) AS [num]
FROM MAIN


--Last column
;WITH MAIN AS (
	SELECT C9 AS [left]
		, C10 AS [center]
		--, C2 AS [right]
		, LAG(C10,1,99) OVER(ORDER BY rownum) AS [above]
		, LEAD(C10,1,99) OVER(ORDER BY rownum) AS [below]
	FROM #Example
)
INSERT INTO #Temp
SELECT 'C10' AS [column], SUM(CASE WHEN (([left] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center ELSE '' END) AS [num]
FROM MAIN

SELECT * FROM #TEMP



/*****************************************************************************************************************************/

CREATE TABLE #Part1 (col VARCHAR(20), num INT)

--First column
;WITH MAIN AS (
	SELECT --C1 AS [left]
		 [Column 0] AS [center]
		, [Column 1] AS [right]
		, LAG([Column 0],1,99) OVER(ORDER BY rownum) AS [above]
		, LEAD([Column 0],1,99) OVER(ORDER BY rownum) AS [below]
	FROM Question16
)
INSERT INTO #Part1
SELECT 'Column 0' AS [column], CASE WHEN (([right] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center + 1 ELSE '' END AS [num]
FROM MAIN

SET NOCOUNT ON;

DECLARE @i INT
DECLARE @l VARCHAR(15)
DECLARE @r VARCHAR(15)
DECLARE @c VARCHAR(15)
DECLARE @sql VARCHAR(4000)
SET @i = 1

WHILE @i < 99
BEGIN
	SET @l = '[Column ' + CAST(@i - 1 AS VARCHAR) + ']'
	SET @r = '[Column ' + CAST(@i + 1 AS VARCHAR) + ']'
	SET @c = '[Column ' + CAST(@i AS VARCHAR) + ']'
	
	SET @sql = '
	;WITH MAIN AS (
		SELECT ' + @l + ' AS [left]
			, ' + @c + ' AS [center]
			, ' + @r + ' AS [right]
			, LAG(' + @c + ',1,99) OVER(ORDER BY rownum) AS [above]
			, LEAD(' + @c + ',1,99) OVER(ORDER BY rownum) AS [below]
		FROM Question16
	)
	INSERT INTO #Part1
	SELECT ''' + @c + ''' AS [column], CASE WHEN (([left] - center) > 0) AND (([right] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center + 1 ELSE '''' END AS [num]
	FROM MAIN'
	
	EXEC (@sql)
	
	SET @i = @i + 1
END



--Last column
;WITH MAIN AS (
	SELECT [Column 99] AS [center]
		, [Column 98] AS [left]
		, LAG([Column 99],1,99) OVER(ORDER BY rownum) AS [above]
		, LEAD([Column 99],1,99) OVER(ORDER BY rownum) AS [below]
	FROM Question16
)
INSERT INTO #Part1
SELECT 'Column 99' AS [column], CASE WHEN (([left] - center) > 0) AND ((above - center) > 0) AND ((below - center) > 0) THEN center + 1 ELSE '' END AS [num]
FROM MAIN


SELECT * FROM #Part1
SELECT SUM(num) FROM #Part1
--217 (too low)
--423 correct, I forgot to add the +1 for the risk factor