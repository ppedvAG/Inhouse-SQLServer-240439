
EXEC dbo.PrepareWorkbench
	@create_table = 1,
	@fill_table = 1,
	@language_id = 1033;
GO

-- Let's create an index on message_id column in dbo.messages for the demos
CREATE UNIQUE NONCLUSTERED INDEX nuix_messages_message_id ON dbo.messages (message_id);
GO

-- 1. example with a temporary table and 1,000 records
CREATE TABLE #Selection (message_id INT NOT NULL PRIMARY KEY CLUSTERED);
GO

WITH R
AS
(
	SELECT	1	AS	message_id

	UNION ALL

	SELECT	R.message_id + 1
	FROM	R
	WHERE	R.message_id < 1000
)
INSERT INTO #Selection (message_id)
SELECT * FROM R
OPTION (MAXRECURSION 0);
GO

SELECT	M.*
FROM	dbo.messages AS M
		INNER JOIN #Selection AS S
		ON (M.message_id = S.message_id)
ORDER BY
		M.[Text];
GO

-- 2. Example with a table variable
DECLARE @Selection TABLE (message_id INT NOT NULL PRIMARY KEY CLUSTERED);

WITH R
AS
(
	SELECT	1	AS	message_id

	UNION ALL

	SELECT	R.message_id + 1
	FROM	R
	WHERE	R.message_id < 1000
)
INSERT INTO @Selection (message_id)
SELECT * FROM R
OPTION (MAXRECURSION 0);

SELECT	m.*
FROM	dbo.messages AS M
		INNER JOIN @Selection AS S
		ON (M.message_id = S.message_id)
ORDER BY
		M.[Text];
GO

-- Now with a RECOMPILE to check the number of rows in the table variable
DECLARE @Selection TABLE (message_id INT NOT NULL PRIMARY KEY CLUSTERED);

WITH R
AS
(
	SELECT	1	AS	message_id

	UNION ALL

	SELECT	R.message_id + 1
	FROM	R
	WHERE	R.message_id < 1000
)
INSERT INTO @Selection (message_id)
SELECT * FROM R
OPTION (MAXRECURSION 0);

SELECT	m.*
FROM	dbo.messages AS M
		INNER JOIN @Selection AS S
		ON (M.message_id = S.message_id)
ORDER BY
		M.[Text]
OPTION (RECOMPILE);
GO

EXEC dbo.PrepareWorkbench
	@create_table = 0;
GO