/*****************************************************************************
Filename:	AoC_Question7
Date:		Dec 1, 2021
Descripion:	

	--- Day 4: Giant Squid ---
	You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

	Maybe it wants to play bingo?

	Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

	The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

	7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

	22 13 17 11  0
	 8  2 23  4 24
	21  9 14 16  7
	 6 10  3 18  5
	 1 12 20 15 19

	 3 15  0  2 22
	 9 18 13 17  5
	19  8  7 25 23
	20 11 10 24  4
	14 21 16 12  6

	14 21 17 24  4
	10 16 15  9 19
	18  8 23 26 20
	22 11 13  6  5
	 2  0 12  3  7

	After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

	22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
	 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
	21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
	 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
	 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7

	After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

	22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
	 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
	21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
	 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
	 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7

	Finally, 24 is drawn:

	22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
	 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
	21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
	 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
	 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7

	At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).

	The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

	To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?

USE [AdventOfCode2021]
*****************************************************************************/

--Needed to alter the input file given:
-- Split the input data into two files, the bingo boards and the numbers called
-- For the bingo boards I also manually removed all double spacing into single spacing for easier importing into the database


--Create temp table for the numbers drawn and their order
CREATE TABLE #Drawn (draw_order INT IDENTITY(1,1), num_drawn INT)


;WITH MAIN AS (
	SELECT CAST(INPUT.value AS INT) AS num
	FROM Question7_2
	CROSS APPLY STRING_SPLIT([Column 0],',') INPUT
)
INSERT INTO #Drawn (num_drawn)
SELECT num FROM MAIN


SELECT * FROM #Drawn


--Imported via import wizard with "ragged right" format
SELECT * FROM Question7 

--Delete the empty rows 
SELECT * FROM Question7 WHERE Input = ''

DELETE FROM Question7 WHERE Input = ''

--Data hygine:
--Remove leading spaces on the single digit numbers in the first column
SELECT * FROM Question7 WHERE LEFT(Input,1) = ' ' --48 rows

UPDATE Question7 SET Input = LTRIM(Input)

SELECT * FROM Question7 WHERE LEFT(Input,1) = ' ' --0 rows


--Remove all double spaces
SELECT * FROM Question7 WHERE Input LIKE '%  %' --163 rows

UPDATE Question7 SET Input = REPLACE(Input,'  ',' ')

SELECT * FROM Question7 WHERE LEFT(Input,1) = ' ' --0 rows



--Create temp table that lists all game boards, with each space number as it's own row that also 
CREATE TABLE #GameBoards (rownum INT IDENTITY(1,1), space_num INT, boardID INT, columnID INT, rowID INT)


;WITH MAIN AS (
	SELECT CAST(INPUT.value AS INT) AS num
	FROM Question7
	CROSS APPLY STRING_SPLIT(Input,' ') INPUT
)
INSERT INTO #GameBoards (space_num)
SELECT num FROM MAIN


--Fill in boardID
;WITH MAIN AS (
	SELECT rownum
		, space_num
		, NTILE(100) OVER(ORDER BY rownum) AS [boardID] 
	FROM #GameBoards
)
UPDATE #GameBoards
SET #GameBoards.boardID = MAIN.boardID
FROM MAIN
WHERE MAIN.rownum = #GameBoards.rownum



--Fill in rowID
;WITH MAIN AS (
	SELECT rownum
		, space_num
		, boardID
		, NTILE(5) OVER(PARTITION BY boardID ORDER BY rownum) AS [rowID] 
	FROM #GameBoards
)
UPDATE #GameBoards
SET #GameBoards.rowID = MAIN.rowID
FROM MAIN
WHERE MAIN.rownum = #GameBoards.rownum


--Fill in columnID
;WITH MAIN AS (
	SELECT rownum
		, space_num
		, boardID
		, rowID
		, NTILE(5) OVER(PARTITION BY boardID, rowID ORDER BY rownum) AS [columnID] 
	FROM #GameBoards
)
UPDATE #GameBoards
SET #GameBoards.columnID = MAIN.columnID
FROM MAIN
WHERE MAIN.rownum = #GameBoards.rownum


--Noticed something funny, decided to check
SELECT * FROM #Drawn ORDER BY 2
--The numbers that are drawn are all numbers 0 to 100 but just not in order
--When I join the drawn numbers to the gameboard numbers, all rows are returned (2500) which means every space would be drawn at some point


--To find the first bingo game board winner we just need to sum the draw order and pick the lowest number
SELECT * FROM (
	--Group all columns in each game board together
	SELECT boardID, columnID, SUM(draw_order) AS [WinningSum], MAX(draw_order) AS [LastNumDrawn]
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, columnID

	UNION ALL

	--Group all rows in each game board together
	SELECT boardID, rowID, SUM(draw_order), MAX(draw_order)
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, rowID
) A ORDER BY 3

--Check answer
SELECT * FROM #GameBoards WHERE boardID = 64 AND columnID = 2
SELECT TOP 19 * FROM #Drawn
--woot woot, it all checks out


--Find final answer to AoC question
SELECT SUM(space_num)
FROM #GameBoards G
LEFT JOIN (SELECT * FROM #Drawn WHERE draw_order <= 19) D ON G.space_num = D.num_drawn
WHERE G.boardID = 64
	AND num_drawn IS NULL
--806

SELECT * FROM #Drawn WHERE draw_order = 19
--73




/************************************************
--- Part Two ---
On the other hand, it might be wise to try a different strategy: let the giant squid win.

You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.

In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.
*************************************************/


SELECT boardID, columnID, SUM(draw_order) AS [WinningSum], MAX(draw_order) AS [LastNumDrawn]
FROM #GameBoards
INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
GROUP BY boardID, columnID


--Find the board that wins last
SELECT boardID, MIN(LastNumDrawn) 
FROM (
	--Group all columns in each game board together
	SELECT boardID, columnID, 0 AS [rowID], MAX(draw_order) AS [LastNumDrawn]
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, columnID

	UNION ALL

	--Group all rows in each game board together
	SELECT boardID, 0, rowID, MAX(draw_order)
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, rowID
) A 
GROUP BY boardID
ORDER BY 2 DESC
--board 25 when the 83 number was drawn



SELECT * FROM (
	--Group all columns in each game board together
	SELECT boardID, columnID, SUM(draw_order) AS [WinningSum], MAX(draw_order) AS [LastNumDrawn]
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, columnID

	UNION ALL

	--Group all rows in each game board together
	SELECT boardID, rowID, SUM(draw_order), MAX(draw_order)
	FROM #GameBoards
	INNER JOIN #Drawn ON #GameBoards.space_num = #Drawn.num_drawn
	GROUP BY boardID, rowID
) A
WHERE boardID = 25
ORDER BY 3
--


--Find final answer to AoC question
SELECT *
FROM #GameBoards G
LEFT JOIN #Drawn D ON G.space_num = D.num_drawn
WHERE G.boardID = 34
	AND rowID = 4

SELECT SUM(space_num)
FROM #GameBoards G
LEFT JOIN (SELECT * FROM #Drawn WHERE draw_order <= 83) D ON G.space_num = D.num_drawn
WHERE G.boardID = 25
	AND num_drawn IS NULL
--136


SELECT * FROM #Drawn WHERE draw_order = 83
--46