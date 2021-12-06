/*****************************************************************************
Filename:	AoC_Question4
Date:		Dec 2, 2021
Descripion:	

	--- Part Two ---
	Based on your calculations, the planned course doesn't seem to make any sense. You find the submarine manual and discover that the process is actually slightly more complicated.

	In addition to horizontal position and depth, you'll also need to track a third value, aim, which also starts at 0. The commands also mean something entirely different than you first thought:

		>> down X increases your aim by X units.
		>> up X decreases your aim by X units.
		>> forward X does two things:
			>> It increases your horizontal position by X units.
			>> It increases your depth by your aim multiplied by X.

	Again note that since you're on a submarine, down and up do the opposite of what you might expect: "down" means aiming in the positive direction.

	Now, the above example does something different:

		- forward 5 adds 5 to your horizontal position, a total of 5. Because your aim is 0, your depth does not change.
		- down 5 adds 5 to your aim, resulting in a value of 5.
		- forward 8 adds 8 to your horizontal position, a total of 13. Because your aim is 5, your depth increases by 8*5=40.
		- up 3 decreases your aim by 3, resulting in a value of 2.
		- down 8 adds 8 to your aim, resulting in a value of 10.
		- forward 2 adds 2 to your horizontal position, a total of 15. Because your aim is 10, your depth increases by 2*10=20 to a total of 60.

	After following these new instructions, you would have a horizontal position of 15 and a depth of 60. (Multiplying these produces 900.)

	Using this new interpretation of the commands, calculate the horizontal position and depth you would have after following the planned course. What do you get if you multiply your final horizontal position by your final depth?

USE [AdventOfCode2021]
*****************************************************************************/


--Copy table from Question3 into new table called Question4
--And since windowed functions can only be used in 
SELECT * INTO Question4 FROM Question3

ALTER TABLE Question4 ADD aim FLOAT, depth FLOAT
 
SELECT * FROM Question4

UPDATE Question4 SET aim = 0 WHERE rownum = 1

WITH MAIN AS (
	SELECT *, SUM(CASE WHEN direction_desc = 'up' OR direction_desc = 'down' THEN direction_value ELSE 0 END) OVER(ORDER BY rownum) AS [aim_calc]
	FROM Question4
)
UPDATE Question4 SET aim = MAIN.aim_calc
FROM MAIN
WHERE Question4.rownum = MAIN.rownum


--Calculate each depth movement for every forward direction
UPDATE Question4
SET depth = direction_value * aim
WHERE direction_desc = 'forward'


--Sum "forward" vlues to get final horizontal value
SELECT SUM(direction_value), SUM(depth), SUM(direction_value) * SUM(depth)
FROM Question4
WHERE direction_desc = 'forward'
