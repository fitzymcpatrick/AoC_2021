/*****************************************************************************
Filename:	AoC_Question9
Date:		Dec 6, 2021
Descripion:	

	--- Day 5: Hydrothermal Venture ---

	You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

	They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

	0,9 -> 5,9
	8,0 -> 0,8
	9,4 -> 3,4
	2,2 -> 2,1
	7,0 -> 7,4
	6,4 -> 2,0
	0,9 -> 2,9
	3,4 -> 1,4
	0,0 -> 8,8
	5,5 -> 8,2

	Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:

	- An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
	- An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.

	For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

	So, the horizontal and vertical lines from the above list would produce the following diagram:

	.......1..
	..1....1..
	..1....1..
	.......1..
	.112111211
	..........
	..........
	..........
	..........
	222111....

	In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

	To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

	Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

USE [AdventOfCode2021]
*****************************************************************************/

--Going to attempt to use SQL spatial (geometry) queries!!!!!!!!!!!


CREATE TABLE Question9 (rownum INT IDENTITY(1,1), input VARCHAR(50), pointA VARCHAR(50), pointB VARCHAR(50), line GEOMETRY)

--Parsing the input data and filling in pointA and pointB columns
SELECT *, REPLACE(LTRIM(RTRIM(LEFT(input,PATINDEX('%->%',input)-1))),',',' '), REPLACE(LTRIM(RTRIM(RIGHT(input,LEN(input) - PATINDEX('%->%',input) - 1))),',',' ') FROM Question9

UPDATE Question9
SET pointA = REPLACE(LTRIM(RTRIM(LEFT(input,PATINDEX('%->%',input)-1))),',',' ')
	, pointB = REPLACE(LTRIM(RTRIM(RIGHT(input,LEN(input) - PATINDEX('%->%',input) - 1))),',',' ')


--Using the two points, create geometry linestrings and fill in the line column
UPDATE Question9
SET line = geometry::STGeomFromText('LINESTRING (' + pointA + ',' + pointB + ')', 0);


--Create temp table that only has vertical or horizontal lines (no diagonals)
SELECT * 
INTO #HVlines 
FROM Question9
WHERE (
		LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1)))
		OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB))))
	)


--Find intersecting lines
;WITH MAIN AS (
	SELECT H1.*
		, H1.line.STIntersection(H2.line).ToString() AS [intersection]
		, DENSE_RANK() OVER(PARTITION BY H1.line.STIntersection(H2.line).ToString() ORDER BY H1.rownum) AS [uniq]
		--, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN H1.line.STIntersection(H2.line).STNumPoints() ELSE H1.line.STIntersection(H2.line).STNumPoints() + 1 END AS [points]
		, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN 1 ELSE H1.line.STIntersection(H2.line).STLength() + 1 END AS [points]
	FROM #HVlines H1
		JOIN #HVlines H2 ON H1.line.STIntersects(H2.line) = 1
	WHERE H1.rownum <> H2.rownum
)
SELECT ROW_NUMBER() OVER(ORDER BY intersection) AS [rownum]
	, intersection
	, CAST(ROUND(LEFT(REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''),PATINDEX('% %',REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''))-1),0) AS VARCHAR) AS [pointA]
	, CAST(ROUND(LTRIM(RTRIM(RIGHT(REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''),LEN(REPLACE(RIGHT(intersection, LEN(intersection)-7),')','')) - PATINDEX('% %',REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''))))),0) AS VARCHAR) AS [pointB]
	, CAST(ROUND(LEFT(REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''),PATINDEX('% %',REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''))-1),0) AS VARCHAR)
		+ ',' + CAST(ROUND(LTRIM(RTRIM(RIGHT(REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''),LEN(REPLACE(RIGHT(intersection, LEN(intersection)-7),')','')) - PATINDEX('% %',REPLACE(RIGHT(intersection, LEN(intersection)-7),')',''))))),0) AS VARCHAR) AS [pointsAB]
INTO #UniquePoints
FROM MAIN
WHERE uniq = 1
	AND intersection LIKE 'POINT%'



--Deal with linestrings, need to extract them and then build a list of all points between A and B of the linestring
;WITH MAIN AS (
	SELECT H1.*
		, H1.line.STIntersection(H2.line).ToString() AS [intersection]
		, DENSE_RANK() OVER(PARTITION BY H1.line.STIntersection(H2.line).ToString() ORDER BY H1.rownum) AS [uniq]
		--, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN H1.line.STIntersection(H2.line).STNumPoints() ELSE H1.line.STIntersection(H2.line).STNumPoints() + 1 END AS [points]
		, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN 1 ELSE H1.line.STIntersection(H2.line).STLength() + 1 END AS [points]
	FROM #HVlines H1
		JOIN #HVlines H2 ON H1.line.STIntersects(H2.line) = 1
	WHERE H1.rownum <> H2.rownum
)
SELECT 	intersection
	, REPLACE(RIGHT(intersection, LEN(intersection)-12),')','')
	, LEFT(REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''),PATINDEX('%, %',REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''))-1) AS [pointA]
	, LEFT(LEFT(REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''),PATINDEX('%, %',REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''))-1),PATINDEX('% %',LEFT(REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''),PATINDEX('%, %',REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''))-1))-1) AS [pointAx]
	--,  AS [pointAy]
	, LTRIM(RTRIM(RIGHT(REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''),LEN(REPLACE(RIGHT(intersection, LEN(intersection)-12),')','')) - PATINDEX('%, %',REPLACE(RIGHT(intersection, LEN(intersection)-12),')',''))))) AS [pointB]
	--, () AS [pointBx]
	--, () AS [pointBy]
FROM MAIN
WHERE uniq = 1 AND intersection LIKE 'LINE%'




--Guesses:
--56xx
--154 (too low)
--5578 (too high)
--2840
--2881
--5952 (idiot!)


SELECT *
	, H1.line.STIntersection(H2.line).ToString() AS [intersection]
	, DENSE_RANK() OVER(PARTITION BY H1.line.STIntersection(H2.line).ToString() ORDER BY H1.rownum) AS [uniq]
	--, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN H1.line.STIntersection(H2.line).STNumPoints() ELSE H1.line.STIntersection(H2.line).STNumPoints() + 1 END AS [points]
	, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN 1 ELSE H1.line.STIntersection(H2.line).STLength() + 1 END AS [points]
FROM #HVlines H1
	JOIN #HVlines H2 ON H1.line.STIntersects(H2.line) = 1
WHERE H1.rownum <> H2.rownum
	AND H1.rownum = 61

--Need to get unique list of points, if two lines overlap each other then they also intersect with another line, when all three hit the same point it should count as only 1 point of intersection
SELECT * FROM #HVlines WHERE rownum IN (61,441,413,159,4,107,419,81,115,102,237,188)


/**************************************************************************************************************************************************************/

CREATE TABLE #Test (rownum INT IDENTITY(1,1), input VARCHAR(50), pointA VARCHAR(50), pointB VARCHAR(50), line GEOMETRY)

INSERT INTO #Test (pointA, pointB)
VALUES ('0 9','5 9'),
('8 0','0 8'),
('9 4','3 4'),
('2 2','2 1'),
('7 0','7 4'),
('6 4','2 0'),
('0 9','2 9'),
('3 4','1 4'),
('0 0','8 8'),
('5 5','8 2')

UPDATE #Test
SET line = geometry::STGeomFromText('LINESTRING (' + pointA + ',' + pointB + ')', 0);

SELECT * FROM (
	SELECT H1.*
	FROM (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H1
		JOIN (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H2 
			ON H1.line.STIntersects(H2.line) = 1
	WHERE H1.rownum <> H2.rownum

	UNION ALL

	SELECT H2.*
	FROM (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H1
		JOIN (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H2 
			ON H1.line.STIntersect(H2.line) = 1
	WHERE H1.rownum <> H2.rownum
) A


SELECT * INTO #T2 FROM #Test 
WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))

SELECT H1.*
	, H1.line.STIntersection(H2.line).ToString()
	, H1.line.STIntersection(H2.line).STNumPoints()
	, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN H1.line.STIntersection(H2.line).STNumPoints() ELSE H1.line.STIntersection(H2.line).STNumPoints() + 1 END AS [Points]
	, H1.line.STIntersection(H2.line).STLength()
FROM (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H1
	JOIN (SELECT * FROM #Test WHERE (LTRIM(RTRIM(LEFT(pointA,PATINDEX('% %',pointA)-1))) = LTRIM(RTRIM(LEFT(pointB,PATINDEX('% %',pointB)-1))) OR LTRIM(RTRIM(RIGHT(pointA,LEN(pointA) - PATINDEX('% %',pointA)))) = LTRIM(RTRIM(RIGHT(pointB,LEN(pointB) - PATINDEX('% %',pointB)))))) H2 
		ON H1.line.STIntersects(H2.line) = 1
WHERE H1.rownum <> H2.rownum


WITH MAIN AS (
	SELECT H1.*
		, H1.line.STIntersection(H2.line).ToString() AS [intersection]
		, DENSE_RANK() OVER(PARTITION BY H1.line.STIntersection(H2.line).ToString() ORDER BY H1.rownum) AS [uniq]
		, CASE WHEN H1.line.STIntersection(H2.line).STNumPoints() = 1 THEN H1.line.STIntersection(H2.line).STNumPoints() ELSE H1.line.STIntersection(H2.line).STNumPoints() + 1 END AS [points]
	FROM #T2 H1
		JOIN #T2 H2 ON H1.line.STIntersects(H2.line) = 1
	WHERE H1.rownum <> H2.rownum
)
SELECT SUM(points)
FROM MAIN
WHERE uniq = 1