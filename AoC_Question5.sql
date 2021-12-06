/*****************************************************************************
Filename:	AoC_Question5
Date:		Dec 3, 2021
Descripion:	

	--- Day 3: Binary Diagnostic ---
	The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

	The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions of the submarine. The first parameter to check is the power consumption.

	You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

	Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:

	00100
	11110
	10110
	10111
	10101
	01111
	00111
	11100
	10000
	11001
	00010
	01010

	Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.

	The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

	The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

	So, the gamma rate is the binary number 10110, or 22 in decimal.

	The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.

	Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)

USE [AdventOfCode2021]
*****************************************************************************/

CREATE TABLE Question5 (rownum INT IDENTITY(1,1), input VARCHAR(20))

SELECT * FROM Question5
--010101110000


--Most common bit at each position
SELECT SUM(CAST(LEFT(input,1) AS INT)) AS [1]
	, SUM(CAST(SUBSTRING(input,2,1) AS INT)) AS [2]
	, SUM(CAST(SUBSTRING(input,3,1) AS INT)) AS [3]
	, SUM(CAST(SUBSTRING(input,4,1) AS INT)) AS [4]
	, SUM(CAST(SUBSTRING(input,5,1) AS INT)) AS [5]
	, SUM(CAST(SUBSTRING(input,6,1) AS INT)) AS [6]
	, SUM(CAST(SUBSTRING(input,7,1) AS INT)) AS [7]
	, SUM(CAST(SUBSTRING(input,8,1) AS INT)) AS [8]
	, SUM(CAST(SUBSTRING(input,9,1) AS INT)) AS [9]
	, SUM(CAST(SUBSTRING(input,10,1) AS INT)) AS [10]
	, SUM(CAST(SUBSTRING(input,11,1) AS INT)) AS [11]
	, SUM(CAST(SUBSTRING(input,12,1) AS INT)) AS [12]
	, ((SELECT COUNT(*) FROM Question5) / 2) AS [HalfCount]
FROM Question5



;WITH MAIN AS (
	SELECT SUM(CAST(LEFT(input,1) AS INT)) AS [1]
		, SUM(CAST(SUBSTRING(input,2,1) AS INT)) AS [2]
		, SUM(CAST(SUBSTRING(input,3,1) AS INT)) AS [3]
		, SUM(CAST(SUBSTRING(input,4,1) AS INT)) AS [4]
		, SUM(CAST(SUBSTRING(input,5,1) AS INT)) AS [5]
		, SUM(CAST(SUBSTRING(input,6,1) AS INT)) AS [6]
		, SUM(CAST(SUBSTRING(input,7,1) AS INT)) AS [7]
		, SUM(CAST(SUBSTRING(input,8,1) AS INT)) AS [8]
		, SUM(CAST(SUBSTRING(input,9,1) AS INT)) AS [9]
		, SUM(CAST(SUBSTRING(input,10,1) AS INT)) AS [10]
		, SUM(CAST(SUBSTRING(input,11,1) AS INT)) AS [11]
		, SUM(CAST(SUBSTRING(input,12,1) AS INT)) AS [12]
		, ((SELECT COUNT(*) FROM Question5) / 2) AS [HalfCount]
	FROM Question5
)
SELECT SUM(CASE WHEN [1] > HalfCount THEN POWER(2,11) ELSE 0 END
		+ CASE WHEN [2] > HalfCount THEN POWER(2,10) ELSE 0 END
		+ CASE WHEN [3] > HalfCount THEN POWER(2,9) ELSE 0 END
		+ CASE WHEN [4] > HalfCount THEN POWER(2,8) ELSE 0 END
		+ CASE WHEN [5] > HalfCount THEN POWER(2,7) ELSE 0 END
		+ CASE WHEN [6] > HalfCount THEN POWER(2,6) ELSE 0 END
		+ CASE WHEN [7] > HalfCount THEN POWER(2,5) ELSE 0 END
		+ CASE WHEN [8] > HalfCount THEN POWER(2,4) ELSE 0 END
		+ CASE WHEN [9] > HalfCount THEN POWER(2,3) ELSE 0 END
		+ CASE WHEN [10] > HalfCount THEN POWER(2,2) ELSE 0 END
		+ CASE WHEN [11] > HalfCount THEN POWER(2,1) ELSE 0 END
		+ CASE WHEN [12] > HalfCount THEN POWER(2,0) ELSE 0 END)
		AS [gamme_rate]
	, SUM(CASE WHEN [1] < HalfCount THEN POWER(2,11) ELSE 0 END
		+ CASE WHEN [2] < HalfCount THEN POWER(2,10) ELSE 0 END
		+ CASE WHEN [3] < HalfCount THEN POWER(2,9) ELSE 0 END
		+ CASE WHEN [4] < HalfCount THEN POWER(2,8) ELSE 0 END
		+ CASE WHEN [5] < HalfCount THEN POWER(2,7) ELSE 0 END
		+ CASE WHEN [6] < HalfCount THEN POWER(2,6) ELSE 0 END
		+ CASE WHEN [7] < HalfCount THEN POWER(2,5) ELSE 0 END
		+ CASE WHEN [8] < HalfCount THEN POWER(2,4) ELSE 0 END
		+ CASE WHEN [9] < HalfCount THEN POWER(2,3) ELSE 0 END
		+ CASE WHEN [10] < HalfCount THEN POWER(2,2) ELSE 0 END
		+ CASE WHEN [11] < HalfCount THEN POWER(2,1) ELSE 0 END
		+ CASE WHEN [12] < HalfCount THEN POWER(2,0) ELSE 0 END)
		AS [epsilon_rate]
FROM MAIN
