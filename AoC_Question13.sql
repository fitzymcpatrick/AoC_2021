/*****************************************************************************
Filename:	AoC_Question13
Date:		Dec 8, 2021
Descripion:	

	--- Day 7: The Treachery of Whales ---

	A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

	Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep for them otherwise) zooms in to rescue you! They seem to be preparing to blast a hole in the ocean floor; sensors indicate a massive underground cave system just beyond where they're aiming!

	The crab submarines all need to be aligned before they'll have enough power to blast a large enough hole for your submarine to get through. However, it doesn't look like they'll be aligned before the whale catches you! Maybe you can help?

	There's one major catch - crab submarines can only move horizontally.

	You quickly make a list of the horizontal position of each crab (your puzzle input). Crab submarines have limited fuel, so you need to find a way to make all of their horizontal positions match while requiring them to spend as little fuel as possible.

	For example, consider the following horizontal positions:

	16,1,2,0,4,2,7,1,2,14

	This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

	Each change of 1 step in horizontal position of a single crab costs 1 fuel. You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2:

	- Move from 16 to 2: 14 fuel
	- Move from 1 to 2: 1 fuel
	- Move from 2 to 2: 0 fuel
	- Move from 0 to 2: 2 fuel
	- Move from 4 to 2: 2 fuel
	- Move from 2 to 2: 0 fuel
	- Move from 7 to 2: 5 fuel
	- Move from 1 to 2: 1 fuel
	- Move from 2 to 2: 0 fuel
	- Move from 14 to 2: 12 fuel

	This costs a total of 37 fuel. This is the cheapest possible outcome; more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

	Determine the horizontal position that the crabs can align to using the least fuel possible. How much fuel must they spend to align to that position?

USE [AdventOfCode2021]
*****************************************************************************/

--drop table Question13
CREATE TABLE Question13 (rownum INT IDENTITY(1,1) PRIMARY KEY, crabs INT)

CREATE INDEX idx_fuel ON Question13(crabs);

--TRUNCATE TABLE Question13;
INSERT INTO Question13 (crabs)
VALUES (1101),(1),(29),(67),(1102),(0),(1),(65),(1008),(65),(35),(66),(1005),(66),(28),(1),(67),(65),(20),(4),(0),(1001),(65),(1),(65),(1106),(0),(8),(99),(35),(67),(101),(99),(105),(32)
	,(110),(39),(101),(115),(116),(32),(112),(97),(115),(32),(117),(110),(101),(32),(105),(110),(116),(99),(111),(100),(101),(32),(112),(114),(111),(103),(114),(97),(109),(10),(27),(591)
	,(29),(1713),(943),(341),(593),(941),(152),(142),(746),(674),(269),(241),(20),(8),(991),(662),(34),(24),(669),(34),(233),(137),(576),(215),(957),(570),(553),(111),(205),(210),(27)
	,(1397),(941),(31),(246),(1064),(83),(53),(285),(517),(972),(29),(742),(34),(260),(185),(1582),(1273),(248),(1132),(346),(1208),(146),(171),(220),(1769),(47),(735),(719),(12),(39)
	,(517),(694),(253),(293),(244),(31),(133),(163),(22),(47),(20),(166),(190),(1072),(24),(17),(445),(250),(6),(139),(134),(361),(304),(812),(201),(825),(87),(118),(1213),(710),(132)
	,(261),(184),(37),(512),(90),(1276),(1007),(83),(132),(874),(0),(109),(1005),(513),(1544),(1759),(1447),(351),(1172),(1087),(1392),(643),(872),(3),(882),(805),(547),(1360),(20),(33)
	,(5),(844),(411),(121),(167),(586),(5),(39),(230),(1321),(1058),(197),(244),(178),(12),(900),(257),(21),(346),(280),(225),(571),(717),(62),(55),(368),(120),(254),(695),(766),(55),(534)
	,(266),(9),(273),(1),(466),(203),(870),(1188),(623),(15),(135),(538),(779),(698),(83),(850),(1244),(63),(562),(19),(1050),(6),(495),(243),(1388),(293),(38),(80),(265),(261),(1392),(351)
	,(505),(922),(434),(644),(721),(97),(227),(635),(753),(467),(6),(1649),(945),(1405),(492),(332),(789),(414),(440),(791),(105),(778),(1851),(959),(80),(291),(1077),(434),(928),(272),(156)
	,(72),(321),(180),(1281),(78),(15),(603),(1243),(306),(533),(1024),(637),(719),(62),(378),(3),(339),(1805),(1236),(647),(92),(574),(63),(418),(1342),(226),(85),(532),(9),(19),(893),(155)
	,(1686),(350),(54),(161),(51),(437),(1096),(508),(137),(920),(20),(146),(824),(142),(233),(328),(286),(289),(229),(90),(89),(760),(1005),(557),(7),(510),(1572),(64),(1378),(0),(624),(15)
	,(476),(368),(885),(1264),(260),(312),(141),(799),(1303),(1136),(706),(54),(1612),(395),(84),(508),(201),(213),(241),(293),(74),(132),(350),(652),(291),(239),(119),(184),(840),(594),(310)
	,(588),(129),(330),(311),(8),(177),(366),(379),(522),(527),(1332),(857),(853),(621),(560),(464),(339),(2),(839),(582),(23),(466),(1415),(325),(971),(582),(118),(391),(1098),(640),(1351)
	,(201),(800),(1579),(332),(100),(196),(1),(238),(1078),(157),(599),(378),(392),(1433),(34),(366),(473),(193),(90),(106),(245),(393),(164),(1751),(1054),(697),(749),(389),(1060),(66),(604)
	,(190),(444),(54),(1273),(175),(65),(1188),(1977),(829),(744),(918),(66),(1023),(404),(1436),(1392),(26),(366),(98),(1038),(254),(304),(723),(21),(606),(349),(5),(645),(610),(1626),(287)
	,(523),(411),(826),(155),(457),(230),(1124),(648),(271),(567),(671),(71),(918),(20),(16),(787),(975),(785),(133),(132),(330),(278),(2),(1460),(493),(696),(1264),(40),(319),(691),(332)
	,(1258),(26),(213),(1024),(389),(688),(183),(162),(604),(993),(539),(75),(998),(362),(466),(1033),(647),(78),(103),(666),(1338),(1158),(1397),(319),(1073),(416),(1274),(9),(52),(302),(83)
	,(427),(546),(132),(228),(499),(7),(829),(77),(76),(271),(68),(1),(1388),(874),(521),(530),(594),(531),(710),(7),(1104),(85),(832),(30),(7),(285),(40),(1414),(140),(243),(141),(1613),(575)
	,(805),(709),(627),(310),(97),(1093),(377),(364),(876),(283),(176),(545),(57),(300),(3),(1255),(360),(1100),(90),(87),(1017),(28),(9),(1094),(112),(1339),(20),(713),(134),(345),(559),(138)
	,(1078),(116),(874),(334),(485),(756),(585),(872),(846),(1072),(262),(11),(1285),(95),(1658),(36),(79),(308),(13),(221),(364),(264),(571),(110),(605),(102),(465),(3),(194),(619),(310),(890)
	,(880),(724),(26),(330),(378),(44),(1430),(642),(328),(89),(527),(111),(420),(1239),(93),(46),(267),(379),(18),(238),(1373),(303),(833),(521),(761),(30),(748),(343),(630),(289),(84),(1160)
	,(789),(45),(100),(734),(204),(275),(1543),(1072),(1787),(105),(87),(0),(164),(719),(354),(284),(309),(1743),(1608),(41),(259),(343),(76),(515),(310),(661),(986),(114),(203),(711),(73),(297)
	,(98),(1346),(372),(166),(1073),(111),(910),(679),(289),(56),(46),(114),(430),(411),(326),(48),(1117),(10),(330),(666),(107),(389),(68),(995),(171),(1690),(161),(1051),(1362),(741),(361),(418)
	,(702),(956),(1311),(621),(277),(816),(604),(160),(19),(1298),(25),(585),(189),(1259),(697),(89),(128),(543),(1148),(27),(270),(165),(1005),(1022),(400),(38),(423),(467),(43),(967),(1242),(133)
	,(719),(7),(1),(348),(597),(79),(122),(126),(168),(312),(898),(158),(1),(162),(133),(455),(366),(62),(6),(1159),(346),(529),(505),(29),(503),(177),(749),(190),(910),(386),(274),(1284),(525)
	,(520),(981),(743),(603),(17),(597),(330),(183),(276),(445),(380),(360),(936),(1562),(1007),(35),(492),(129),(716),(374),(412),(518),(117),(4),(1469),(713),(356),(92),(7),(372),(113),(128),(164)
	,(359),(1409),(1147),(543),(8),(179),(232),(1356),(1131),(168),(579),(133),(174),(1357),(1601),(21),(104),(365),(7),(32),(1052),(1656),(1313),(396),(171),(688),(840),(115),(370),(766),(309),(1477)
	,(38),(556),(5),(1696),(284),(310),(217),(158),(127),(208),(75),(443),(241),(120),(76),(13),(948),(227),(855),(29),(362),(362),(535),(313),(882),(233),(514),(152),(380),(630),(63),(29),(233)
	,(1623),(862),(139),(21),(828),(119),(154),(130),(1057),(542),(226),(868),(89),(160),(1267),(346),(209),(1067),(1001),(92),(170),(104),(557),(634),(161),(1825),(717),(622),(51),(190),(600),(22)
	,(114),(902),(11),(3),(388),(1773),(523),(224),(1455),(773),(283),(56),(102),(207),(23),(840),(67),(743),(407),(1017),(957),(94),(33),(38),(710),(176),(115),(926),(537),(338),(606),(257),(957)
	,(1573),(1270),(222),(591),(714),(1430),(209),(250),(17),(69),(917),(1270),(81),(648),(96),(74),(232),(426),(299),(598),(41),(1125),(1108),(50),(521),(209),(327),(452),(281),(609),(124),(1124)
	,(606),(1395),(554),(754),(15),(559),(174),(786),(1325),(634),(133),(93),(398)


--Find the MODE of the dataset
SELECT TOP 1 WITH TIES crabs
FROM   Question13
WHERE  crabs IS NOT NULL
GROUP  BY crabs
ORDER  BY COUNT(*) DESC
--1 is the ideal position for all of the crab submarines... but that doesn't make sense to me

SELECT MAX(crabs), MIN(crabs) FROM Question13
--0 to 1977 is range


--DROP TABLE Question13_2;
SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS [crabID]
	, crabs AS [position]
	, 0 AS [fuel]
INTO Question13_2
FROM Question13

SET NOCOUNT ON;

drop table #Test2
--Try recursion
CREATE TABLE #Test2 (rownum INT IDENTITY(1,1), crabID INT, position INT, fuels FLOAT)

DECLARE @x INT
SET @x = 1

WHILE @x <= (SELECT MAX(crabID) FROM Question13_2)
BEGIN

	;WITH cte_count AS
	(SELECT crabID, position, fuel FROM Question13_2 WHERE crabID = @x AND fuel = 0 -- anchor member
		UNION ALL
		SELECT C.crabID, CAST(C.position AS INT) + 1, C.fuel + 1 -- recursive member
		FROM cte_count C
		JOIN Question13_2 Q ON C.crabID = Q.crabID
		WHERE C.position <= 1976 -- terminator
	)
	INSERT INTO #Test2 (crabID, position, fuels)
	SELECT crabID, position, fuel
	FROM cte_count
	ORDER BY position
	OPTION (MAXRECURSION 2000);

	SET @x = @x + 1
END



--Find all fuel costs at each position for each crab submarine from it's starting point down to the lowes
DECLARE @y INT
SET @y = 1

WHILE @y <= (SELECT MAX(crabID) FROM Question13_2)
BEGIN

	;WITH cte_count AS
	(SELECT crabID, position, fuel FROM Question13_2 WHERE crabID = @y AND fuel = 0 -- anchor member
		UNION ALL
		SELECT C.crabID, CAST(C.position AS INT) - 1, C.fuel + 1 -- recursive member
		FROM cte_count C
		JOIN Question13_2 Q ON C.crabID = Q.crabID
		WHERE C.position >= 1 -- terminator
	)
	INSERT INTO #Test2 (crabID, position, fuels)
	SELECT crabID, position, fuel
	FROM cte_count
	WHERE fuel <> 0
	ORDER BY position
	OPTION (MAXRECURSION 2000);

	SET @y = @y + 1
END


SELECT position, SUM(fuels)
FROM #Test2
GROUP BY position
ORDER BY 2 ASC
--345862
--347509 correct!


SELECT * FROM (
	SELECT *, SUM(fuels) OVER(PARTITION BY crabID ORDER BY CAST(position AS INT)) AS [fuel2]
	FROM #Test2
	WHERE crabID = 25
		AND position > (SELECT position FROM #Test2 WHERE fuels = 0 AND crabID = 25)

	UNION

	SELECT *, SUM(fuels) OVER(PARTITION BY crabID ORDER BY CAST(position AS INT) DESC)
	FROM #Test2
	WHERE crabID = 25
		AND position < (SELECT position FROM #Test2 WHERE fuels = 0 AND crabID = 25)

	UNION

	SELECT *, 0 FROM #Test2 WHERE fuels = 0 AND crabID = 25
	) A 
ORDER BY position


SELECT * FROM #Test2 WHERE crabID = 25 ORDER BY position


--Part 2
CREATE TABLE #Part2 (crabID INT, position INT, fuels FLOAT, part2_fuel FLOAT)

--TRUNCATE TABLE #Part2;
DECLARE @y INT
SET @y = 1

WHILE @y <= (SELECT MAX(crabID) FROM Question13_2)
BEGIN

	INSERT INTO #Part2 (crabID, position, fuels, part2_fuel)
	SELECT crabID, position, fuels, fuel2 FROM (
		SELECT *, SUM(fuels) OVER(PARTITION BY crabID ORDER BY CAST(position AS INT)) AS [fuel2]
		FROM #Test2
		WHERE crabID = @y
			AND position > (SELECT position FROM #Test2 WHERE fuels = 0 AND crabID = @y)

		UNION

		SELECT *, SUM(fuels) OVER(PARTITION BY crabID ORDER BY CAST(position AS INT) DESC)
		FROM #Test2
		WHERE crabID = @y
			AND position < (SELECT position FROM #Test2 WHERE fuels = 0 AND crabID = @y)

		UNION

		SELECT *, 0 FROM #Test2 WHERE fuels = 0 AND crabID = @y
		) A 
	ORDER BY position


	SET @y = @y + 1
END


SELECT position, SUM(part2_fuel)
FROM #Part2
GROUP BY position
ORDER BY 2 ASC
--694023 too low
--98257206 correct!!!
