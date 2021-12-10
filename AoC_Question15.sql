/*****************************************************************************
Filename:	AoC_Question15
Date:		Dec 10, 2021
Descripion:	



USE [AdventOfCode2021]
*****************************************************************************/


CREATE TABLE Question15 (rownum INT IDENTITY(1,1), signal_pattern VARCHAR(100), output_value VARCHAR(50))

;WITH MAIN AS (
	SELECT LEN(value) AS [length]
	FROM Question15
	CROSS APPLY STRING_SPLIT(output_value,' ')
)
SELECT COUNT(*) FROM MAIN WHERE [length] = 2 OR [length] = 3 OR [length] = 4 OR [length] = 7