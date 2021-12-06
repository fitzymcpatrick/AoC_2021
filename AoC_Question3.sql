/*****************************************************************************
Filename:	AoC_Question3
Date:		Dec 2, 2021
Descripion:	

	--- Day 2: Dive! ---
	Now, you need to figure out how to pilot this thing.

	It seems like the submarine can take a series of commands like forward 1, down 2, or up 3:

	- forward X increases the horizontal position by X units.
	- down X increases the depth by X units.
	- up X decreases the depth by X units.

	Note that since you're on a submarine, down and up affect your depth, and so they have the opposite result of what you might expect.

	The submarine seems to already have a planned course (your puzzle input). You should probably figure out where it's going. For example:

		>> forward 5
		>> down 5
		>> forward 8
		>> up 3
		>> down 8
		>> forward 2

	Your horizontal position and depth both start at 0. The steps above would then modify them as follows:

		- forward 5 adds 5 to your horizontal position, a total of 5.
		- down 5 adds 5 to your depth, resulting in a value of 5.
		- forward 8 adds 8 to your horizontal position, a total of 13.
		- up 3 decreases your depth by 3, resulting in a value of 2.
		- down 8 adds 8 to your depth, resulting in a value of 10.
		- forward 2 adds 2 to your horizontal position, a total of 15.

	After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)

	Calculate the horizontal position and depth you would have after following the planned course. What do you get if you multiply your final horizontal position by your final depth?

USE [AdventOfCode2021]
*****************************************************************************/


--Create table for question 3
CREATE TABLE Question3 (rownum INT IDENTITY(1,1), direction VARCHAR(20))

--Check
SELECT * FROM Question3


--Add additional columns to parse out the directions into values and description
ALTER TABLE Question3 ADD direction_desc VARCHAR(20), direction_value FLOAT

UPDATE Question3
SET direction_desc = LEFT(direction,PATINDEX('% %',direction))
	, direction_value = RIGHT(direction,1);


--Set all direction values of "up" to be negative so that summing "up" and "down" values together gets the final depth of the submarine
UPDATE Question3 SET direction_value = direction_value * -1 WHERE direction_desc = 'up'


--Sum "forward" vlues to get final horizontal value
SELECT SUM(direction_value)
FROM Question3
WHERE direction_desc = 'forward'


--Sum both "up" and "down" to get final depth value
SELECT SUM(direction_value)
FROM Question3
WHERE (direction_desc = 'up' OR direction_desc = 'down')
